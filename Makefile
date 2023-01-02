postgres:
	docker run --rm --name postgres12 -p 5432:5432 -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

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

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test