# base go image
#FROM golang:1.20-alpine as builder
#
#RUN mkdir /app
#
#COPY . /app
#
#WORKDIR /app
#
#RUN CGO_ENABLED=0 go build -o brokerApp ./cmd/api
#
#RUN chmod +x /app/brokerApp
#
## build a tiny docker image
#FROM alpine:latest
#
#RUN mkdir /app
#
#COPY --from=builder /app/brokerApp /app
#
#CMD ["/app/brokerApp"]



# We have the image now so we can write this. It will be faster to run
FROM alpine:latest

RUN mkdir /app

COPY brokerApp /app

CMD ["/app/brokerApp"]