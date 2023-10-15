package main

import (
	"fmt"
	"log"

	"github.com/chisty/distributedGoSvc/internal/server"
)

func main() {
	server := server.NewHttpServer(":8080")
	fmt.Println("Server started at :8080")

	log.Fatal(server.ListenAndServe())
}
