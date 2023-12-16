package rest

import (
	"encoding/json"
	"net/http"
	"strings"

	"github.com/liliang-cn/hello-api/translation"
)

type Resp struct {
	Language    string `json:"language"`
	Translation string `json:"translation"`
}

func TranslateHandler(w http.ResponseWriter, r *http.Request) {
	enc := json.NewEncoder(w)
	w.Header().Set("Content-Type", "application/json; charset=utf-8")

	language := r.URL.Query().Get("language")

	if language == "" {
		language = "english"
	}

	word := strings.ReplaceAll(r.URL.Path, "/", "")

	translationRes := translation.Translate(word, language)

	if translationRes == "" {
		w.WriteHeader(404)
		return
	}

	resp := Resp{
		Language:    language,
		Translation: translationRes,
	}
	if err := enc.Encode(resp); err != nil {
		panic("unable to encode response")
	}
}
