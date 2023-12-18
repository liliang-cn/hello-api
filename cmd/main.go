package main

import (
	"log"
	"net/http"

	"github.com/liliang-cn/hello-api/handlers"
	"github.com/liliang-cn/hello-api/handlers/rest"
	"github.com/liliang-cn/hello-api/translation"
)

func main() {
	addr := ":8081"
	mux := http.NewServeMux()

	translationService := translation.NewStaticService()
	translateHandler := rest.NewTranslatorHandler(translationService)

	mux.HandleFunc("/hello", translateHandler.TranslateHandler)
	mux.HandleFunc("/health", handlers.HealthCheck)

	log.Printf("listening on %s\n", addr)

	log.Fatal(http.ListenAndServe(addr, mux))
}

type Resp struct {
	Language    string `json:"language"`
	Translation string `json:"translation"`
}
