package main

import (
	"net/http"
)

type mailMessage struct {
	From    string `json:"from"`
	To      string `json:"to"`
	Subject string `json:"subject"`
	Message string `json:"message"`
}

func (app *Config) SendMail(w http.ResponseWriter, r *http.Request) {
	var reqPayload mailMessage

	if err := app.readJSON(w, r, &reqPayload); err != nil {
		_ = app.errorJSON(w, err)
		return
	}

	msg := Message{
		From:    reqPayload.From,
		To:      reqPayload.To,
		Subject: reqPayload.Subject,
		Data:    reqPayload.Message,
	}

	if err := app.Mailer.SendSMTPMessage(msg); err != nil {
		_ = app.errorJSON(w, err)
		return
	}

	payload := jsonResponse{
		Error:   false,
		Message: "sent to " + reqPayload.To,
	}

	_ = app.writeJSON(w, http.StatusAccepted, payload)
}
