package main

import (
	"context"
	"fmt"
	"github.com/RokibulHasan7/go-microservice/logger-service/data"
	"github.com/RokibulHasan7/go-microservice/logger-service/logs"
	"google.golang.org/grpc"
	"log"
	"net"
)

type LogServer struct {
	logs.UnimplementedLogServiceServer
	Models data.Models
}

func (l *LogServer) WriteLog(ctx context.Context, req *logs.LogRequest) (*logs.LogResponse, error) {
	input := req.GetLogEntry()

	// write log
	logEntry := data.LogEntry{
		Name: input.Name,
		Data: input.Data,
	}

	err := l.Models.LogEntry.Insert(logEntry)
	if err != nil {
		res := &logs.LogResponse{
			Result: "failed",
		}
		return res, err
	}

	// return response
	res := &logs.LogResponse{
		Result: "Logged!",
	}

	return res, nil
}

func (app *Config) gRPCListen() {
	lis, err := net.Listen("tcp", fmt.Sprintf(":%s", grpcPort))
	if err != nil {
		log.Fatal("Failed to listen for gRPC: ", err)
	}

	s := grpc.NewServer()
	logs.RegisterLogServiceServer(s, &LogServer{
		Models: app.Models,
	})

	log.Println("gRPC server started on port: ", grpcPort)
	if err = s.Serve(lis); err != nil {
		log.Fatal("Failed to listen for gRPC: ", err)
	}
}
