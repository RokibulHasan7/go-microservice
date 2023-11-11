FRONT_END_BINARY=frontApp
BROKER_BINARY=brokerApp
AUTH_BINARY=authApp
LOGGER_BINARY=loggerApp
MAIL_BINARY=mailApp
LISTENER_BINARY=listenerApp

# starts all container in the background without forcing build
up:
	@echo "Starting Docker images..."
	docker compose up -d
	@echo "Docker images started!"

# stops docker compose (if running), builds all projects and starts docker compose
up-build: build-broker build-auth build-logger build-mail
	@echo "Stopping docker images (if running...)"
	docker compose down
	@echo "Building and starting docker images..."
	docker compose up --build -d
	@echo "Docker images build and started!"

# stop docker compose
down:
	@echo "Stopping docker compose..."
	docker compose down
	@echo "Done!"

# builds the broker binary as a linux executable
build-broker:
	@echo "Building broker binary..."
	cd ./broker-service && env GOOS=linux CGO_ENABLED=0 go build -o ${BROKER_BINARY} ./cmd/api
	@echo "Done!"

# builds the auth binary as a linux executable
build-auth:
	@echo "Building auth binary..."
	cd ./auth-service && env GOOS=linux CGO_ENABLED=0 go build -o ${AUTH_BINARY} ./cmd/api
	@echo "Done!"

# builds the logger binary as a linux executable
build-logger:
	@echo "Building logger binary..."
	cd ./logger-service && env GOOS=linux CGO_ENABLED=0 go build -o ${LOGGER_BINARY} ./cmd/api
	@echo "Done!"

# builds the mail binary as a linux executable
build-mail:
	@echo "Building mail binary..."
	cd ./mail-service && env GOOS=linux CGO_ENABLED=0 go build -o ${MAIL_BINARY} ./cmd/api
	@echo "Done!"

# builds the listener binary as a linux executable
build-listener:
	@echo "Building listener binary..."
	cd ./listener-service && env GOOS=linux CGO_ENABLED=0 go build -o ${LISTENER_BINARY} ./cmd/api
	@echo "Done!"

# builds the front end binary
build-front:
	@echo "Building front end binary..."
	cd ./front-end && env CGO_ENABLED=0 go build -o ${FRONT_END_BINARY} ./cmd/web
	@echo "Done!"

# starts the front end
start: build-front
	@echo "Starting front end..."
	cd ./front-end && ./${FRONT_END_BINARY} &

# stops the front end
stop:
	@echo "Stopping front end..."
	@-pkill -SIGTERM -f "./${FRONT_END_BINARY}"
	@echo "Stopped front end!"