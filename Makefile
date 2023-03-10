postgres:
	docker run --rm  --network bank-network --name postgres12 -p 5432:5432 -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=postgres --owner=postgres postgres

dropdb:
	docker exec -it postgres12 dropdb postgres

migrateup:
	migrate -path db/migration -database "postgresql://postgres:secret@localhost:5432/postgres?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://postgres:secret@localhost:5432/postgres?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./... 

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/yimialmonte/simple-bank/db/sqlc Store

build_docker:
	docker build -t simplebank:latest .

run_docker:
	docker run --rm -e GIN_MODE=release --network bank-network --name simplebank -e "DB_SOURCE=postgresql://postgres:secret@postgres12:5432/postgres?sslmode=disable" -p 8080:8080 simplebank:latest

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test mock
