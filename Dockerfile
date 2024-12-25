# syntax=docker/dockerfile:1

# Stage 1: Build
FROM golang:1.22.10 AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Stage 2: Run
FROM alpine:latest

# Set the Current Working Directory inside the container
WORKDIR /root/

# Copy the pre-built binary file from the builder stage
COPY --from=builder /app/main .

# Copy the .env file (if needed)
COPY .env ./

# Expose the application on port 5000
EXPOSE 5000

# Command to run the executable
CMD ["./main"]
