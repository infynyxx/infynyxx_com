package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"strings"
)

func CacheFiles(dir string, m map[string]string) {
	files, err := ioutil.ReadDir(dir)
	if err != nil {
		log.Fatal(err)
	}

	for _, file := range files {
		if file.IsDir() {
			CacheFiles(strings.TrimRight(dir, "/")+"/"+file.Name(), m)
		} else {
			var fileName = dir + "/" + file.Name()
			var content, err = ioutil.ReadFile(fileName)
			if err != nil {
				log.Fatal(err)
			}
			str_ := string(content[:])
			m[fileName] = str_
		}
	}
}

func staticHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		var key string
		if r.URL.Path == "/" { // empty index
			key = indexPath
		} else {
			key = staticDir + r.URL.Path
		}
		content, ok := cache[key]
		if ok {
			w.WriteHeader(http.StatusOK)
			fmt.Fprintf(w, content)
		} else {
			w.WriteHeader(http.StatusNotFound)
			fmt.Fprintf(w, "Not found!")
		}
	} else {
		w.WriteHeader(http.StatusMethodNotAllowed)
	}
}

var cache = make(map[string]string)
var staticDir = "./static"
var indexPath = staticDir + "/" + "index.html"

func main() {
	CacheFiles(staticDir, cache)
	http.HandleFunc("/", staticHandler)
	http.ListenAndServe(":8080", nil)
}
