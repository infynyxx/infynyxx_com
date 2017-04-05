FROM golang:1.8-onbuild
WORKDIR /app

COPY . /app
RUN make all

ENTRYPOINT /app/bin/infynyxx_com

EXPOSE 8080
