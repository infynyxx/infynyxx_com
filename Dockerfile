FROM golang:1.9-alpine
WORKDIR /app

RUN apk add --no-cache curl make

COPY static /app/static
COPY main.go /app/
COPY Makefile /app/
RUN make

ENTRYPOINT /app/bin/infynyxx_com

EXPOSE 8080
