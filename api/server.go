package api

import (
	"github.com/gin-gonic/gin"
	db "github.com/yimialmonte/simple-bank/db/sqlc"
)

// Server...
type Server struct {
	store  db.Store
	router *gin.Engine
}

// NewServer...
func NewServer(store db.Store) *Server {
	server := Server{store: store}
	router := gin.Default()

	router.POST("/accounts", server.createAccount)
	router.GET("/accounts/:id", server.getAccount)
	router.GET("/accounts", server.listAccount)
	router.DELETE("/accounts/:id", server.deleteAccount)

	server.router = router

	return &server
}

// Start...
func (server *Server) Start(address string) error {
	return server.router.Run()
}

func errorResponse(err error) gin.H {
	return gin.H{
		"error": err.Error(),
	}
}
