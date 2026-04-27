# ContextChat 🤖

A Retrieval-Augmented Generation (RAG) based context-aware chatbot application. This project combines modern LLMs with vector search capabilities to provide intelligent, context-aware conversations grounded in your custom data.

## 📋 Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [Usage](#usage)
- [API Endpoints](#api-endpoints)
- [Technologies](#technologies)
- [Environment Variables](#environment-variables)
- [Contributing](#contributing)
- [License](#license)

## ✨ Features

- **Retrieval-Augmented Generation (RAG)**: Combines vector search with LLM generation for accurate, context-aware responses
- **Vector Database**: Powered by Qdrant for efficient semantic search
- **Local LLM**: Uses Ollama for running LLMs locally without external API dependencies
- **RESTful API**: Python backend with Flask/FastAPI
- **Web Interface**: Interactive frontend for seamless chat experience
- **Docker Support**: Complete containerization for easy deployment
- **Contextual Memory**: Maintains conversation history for better context understanding

## 🏗️ Architecture

```
┌─────────────────┐
│   Frontend      │ (Web UI)
└────────┬────────┘
         │
┌────────▼────────┐
│  Nginx Reverse  │ (Load Balancing & Routing)
│     Proxy       │
└────────┬────────┘
         │
┌────────▼────────┐
│    Backend      │ (API Server)
│  (Flask/FastPI) │
└────────┬────────┘
    ┌────┴────┐
    │          │
┌───▼──┐  ┌───▼──────┐
│Qdrant│  │  Ollama  │
│(Vector│  │  (LLM)   │
│ DB)   │  └──────────┘
└───────┘
```

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Docker** (v20.10 or higher)
- **Docker Compose** (v1.29 or higher)
- **Git**
- **Port availability**: 80 (nginx), 6333/6334 (Qdrant), 11434 (Ollama), 5001 (Backend)

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/ContextChat.git
cd ContextChat
```

### 2. Create Environment File

Create a `.env` file in the root directory:

```bash
cp .env.example .env
```

Edit `.env` with your configuration (see [Environment Variables](#environment-variables))

### 3. Build and Start Services

```bash
docker-compose up -d
```

This will start all services:
- Qdrant vector database on `http://localhost:6333`
- Ollama LLM service on `http://localhost:11434`
- Backend API on `http://localhost:5001`
- Frontend on `http://localhost:80`

### 4. Verify Installation

```bash
# Check if all containers are running
docker-compose ps

# Check Qdrant health
curl http://localhost:6333/health

# Check Ollama health
curl http://localhost:11434/api/tags
```

## 🎯 Quick Start

### 1. Access the Application

Open your browser and navigate to:
```
http://localhost
```

### 2. Upload Context Documents

1. Use the file upload feature to add documents
2. Documents will be processed and embedded into the Qdrant vector database
3. Supported formats: PDF, TXT, DOCX, Markdown

### 3. Start Chatting

1. Type your question in the chat interface
2. The system retrieves relevant context from your documents
3. Ollama generates a response based on the retrieved context
4. Conversation history is maintained for better context

## 📁 Project Structure

```
ContextChat/
├── backend/                 # Python Flask/FastAPI backend
│   ├── app.py
│   ├── requirements.txt
│   ├── Dockerfile
│   ├── config/
│   ├── routes/
│   ├── services/
│   └── utils/
├── frontend/                # React/Vue frontend application
│   ├── public/
│   ├── src/
│   ├── package.json
│   └── Dockerfile
├── data/                    # Data storage and processing
│   ├── documents/           # User uploaded documents
│   └── embeddings/          # Cached embeddings
├── docker-compose.yml       # Docker service orchestration
├── nginx.conf              # Nginx configuration
├── README.md               # This file
├── .env.example            # Environment variables template
└── test.txt                # Test data/utilities
```

## ⚙️ Configuration

### Backend Configuration

Edit `backend/config.py` or environment variables:

```python
# LLM Configuration
OLLAMA_BASE_URL = "http://ollama:11434"
MODEL_NAME = "mistral"  # or your preferred model

# Vector Database Configuration
QDRANT_URL = "http://qdrant:6333"
QDRANT_COLLECTION = "context_chat"

# API Configuration
API_HOST = "0.0.0.0"
API_PORT = 5000
DEBUG = False
```

### Frontend Configuration

Edit `frontend/.env`:

```
REACT_APP_API_URL=http://localhost:5001
REACT_APP_API_TIMEOUT=30000
```

## 📡 API Endpoints

### Chat Endpoint

```bash
POST /api/chat
Content-Type: application/json

{
  "query": "Your question here",
  "conversation_id": "optional-id",
  "top_k": 5
}

Response:
{
  "response": "Generated answer",
  "sources": ["document1.pdf", "document2.txt"],
  "conversation_id": "id"
}
```

### Upload Documents

```bash
POST /api/upload
Content-Type: multipart/form-data

{
  "file": <binary>
}
```

### Health Check

```bash
GET /api/health

Response:
{
  "status": "healthy",
  "qdrant": "connected",
  "ollama": "available"
}
```

## 🛠️ Technologies

- **Backend**: Python, Flask/FastAPI
- **Frontend**: React/Vue.js, Axios
- **Vector Database**: Qdrant
- **LLM**: Ollama (supports Mistral, Llama2, Neural Chat, etc.)
- **Containerization**: Docker, Docker Compose
- **Web Server**: Nginx
- **Reverse Proxy**: Nginx

## 🔐 Environment Variables

Create a `.env` file with the following variables:

```env
# Qdrant Configuration
QDRANT_API_KEY=your_optional_api_key
QDRANT_URL=http://qdrant:6333

# Ollama Configuration
OLLAMA_BASE_URL=http://ollama:11434
OLLAMA_MODEL=mistral

# Backend Configuration
FLASK_ENV=production
DEBUG=False
API_HOST=0.0.0.0
API_PORT=5000

# Frontend Configuration
REACT_APP_API_URL=http://localhost:5001

# Docker Compose Resource Limits
# Qdrant
QDRANT_MEMORY_LIMIT=2G
QDRANT_MEMORY_RESERVATION=1G

# Ollama
OLLAMA_MEMORY_LIMIT=6G
OLLAMA_MEMORY_RESERVATION=5G
```

## 🧹 Cleanup

To stop and remove all containers:

```bash
docker-compose down

# To also remove volumes
docker-compose down -v
```

## 📝 Usage Examples

### Example 1: Simple Query

```bash
curl -X POST http://localhost:5001/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "query": "What is machine learning?",
    "top_k": 3
  }'
```

### Example 2: With Conversation Context

```bash
curl -X POST http://localhost:5001/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Tell me more about it",
    "conversation_id": "conv-123",
    "top_k": 5
  }'
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Troubleshooting

### Qdrant Connection Error

```bash
# Check if Qdrant is running
docker-compose logs qdrant

# Verify Qdrant health
curl http://localhost:6333/health
```

### Ollama Model Not Found

```bash
# Pull a model
curl -X POST http://localhost:11434/api/pull -d '{"name": "mistral"}'

# List available models
curl http://localhost:11434/api/tags
```

### Backend Connection Issues

```bash
# Check backend logs
docker-compose logs backend

# Verify backend is running
curl http://localhost:5001/api/health
```

## 📞 Support

For issues and questions, please open an issue on the GitHub repository.

---

**Last Updated**: April 2026  
**Project Status**: Active Development
