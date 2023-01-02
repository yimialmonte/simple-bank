package main

import (
	"database/sql"
	"log"

	_ "github.com/lib/pq"
	"github.com/yimialmonte/simple-bank/api"
	db "github.com/yimialmonte/simple-bank/db/sqlc"
	"github.com/yimialmonte/simple-bank/util"
)

func main() {
	conf, err := util.LoadConf(".")
	if err != nil {
		log.Fatal("can not read conf file", err)
	}

	conn, err := sql.Open(conf.DBDriver, conf.DBSource)
	if err != nil {
		log.Fatal("can not connect to db: ", err)
	}

	store := db.NewStore(conn)
	server := api.NewServer(store)

	err = server.Start(conf.ServerAddress)
	if err != nil {
		log.Fatal("cannot start the server", err)
	}
}
