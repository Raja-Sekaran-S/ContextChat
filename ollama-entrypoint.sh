#!/bin/bash
set -e

# Start ollama server in the background
ollama serve &
SERVER_PID=$!

# Wait for ollama server to be ready
echo "Waiting for Ollama server to start..."
for i in {1..30}; do
    if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
        echo "Ollama server is ready!"
        break
    fi
    echo "Waiting... ($i/30)"
    sleep 2
done

# Pull mistral model
echo "Pulling mistral model..."
ollama pull mistral

# Keep the server running
echo "Ollama setup complete!"
wait $SERVER_PID
