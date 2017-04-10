FROM golang:1.8-onbuild
WORKDIR /app

COPY static /app/static
COPY main.go /app/
COPY Makefile /app/
RUN make

ENTRYPOINT /app/bin/infynyxx_com

EXPOSE 8080
