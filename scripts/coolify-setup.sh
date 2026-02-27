#!/bin/bash
set -e

echo "⚙️  Running Coolify setup for Open TutorAI..."

# Create necessary directories
mkdir -p /app/backend/data/cache/embedding/models
mkdir -p /app/backend/data/cache/whisper/models
mkdir -p /app/backend/data/uploads
mkdir -p /app/backend/data/logs

# Set proper permissions
chown -R ${UID:-1000}:${GID:-1000} /app/backend/data

# Generate a random secret key if not provided
if [ -z "$WEBUI_SECRET_KEY" ]; then
    export WEBUI_SECRET_KEY=$(openssl rand -base64 32)
    echo "🔑 Generated new secret key"
fi

# Create environment file for the application
cat > /app/backend/.env << EOF
# Database Configuration
POSTGRES_HOST=${POSTGRES_HOST:-localhost}
POSTGRES_PORT=${POSTGRES_PORT:-5432}
POSTGRES_DB=${POSTGRES_DB:-open_tutorai}
POSTGRES_USER=${POSTGRES_USER:-tutorai_user}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}

# Application Configuration
WEBUI_SECRET_KEY=${WEBUI_SECRET_KEY}
ENABLE_SIGNUP=${ENABLE_SIGNUP:-true}
PORT=${PORT:-8080}

# AI Configuration (External llama.cpp)
OLLAMA_BASE_URL=${OLLAMA_BASE_URL:-""}
OPENAI_API_BASE_URL=${OPENAI_API_BASE_URL:-http://192.168.1.24:8080/v1}
OPENAI_API_KEY=${OPENAI_API_KEY:-""}
WHISPER_MODEL=${WHISPER_MODEL:-base}
RAG_EMBEDDING_MODEL=${RAG_EMBEDDING_MODEL:-sentence-transformers/all-MiniLM-L6-v2}
TIKTOKEN_ENCODING_NAME=${TIKTOKEN_ENCODING_NAME:-cl100k_base}

# Image Generation
AUTOMATIC1111_BASE_URL=${AUTOMATIC1111_BASE_URL}

# Security
SCARF_NO_ANALYTICS=true
DO_NOT_TRACK=true
ANONYMIZED_TELEMETRY=false
EOF

echo "✅ Coolify setup completed"