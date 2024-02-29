#!/bin/bash

# Set the port number to listen on
PORT=5140

# Function to handle incoming connections
handle_connection() {
    # Read data from the client
    data=$(nc -l -p $PORT)

    # Print received data
    echo "Received: $data"

    # Respond to the client
    echo "Response from server" | nc -q 0 localhost $PORT
}

# Main loop to listen for incoming connections
while true; do
    handle_connection
done
