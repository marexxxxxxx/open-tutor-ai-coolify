#!/bin/bash
set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="/app"

echo "🚀 Starting Open TutorAI Coolify deployment..."

# Function to check if PostgreSQL is ready
wait_for_postgres() {
    echo "⏳ Waiting for PostgreSQL to be ready..."
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if pg_isready -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" >/dev/null 2>&1; then
            echo "✅ PostgreSQL is ready!"
            return 0
        fi
        
        echo "⏳ Attempt $attempt/$max_attempts - PostgreSQL not ready, waiting 5 seconds..."
        sleep 5
        attempt=$((attempt + 1))
    done
    
    echo "❌ PostgreSQL failed to become ready after $max_attempts attempts"
    exit 1
}

# Function to run database migrations
run_migrations() {
    echo "🔄 Running database migrations..."
    cd "$APP_DIR/backend"
    
    # Run migrations using alembic
    python -m alembic upgrade head
    
    echo "✅ Database migrations completed"
}

# Function to setup application
setup_application() {
    echo "⚙️  Setting up application..."
    
    # Run post-install setup
    if [ -f "$SCRIPT_DIR/coolify-setup.sh" ]; then
        bash "$SCRIPT_DIR/coolify-setup.sh"
    fi
    
    echo "✅ Application setup completed"
}

# Function to start the application
start_application() {
    echo "🚀 Starting Open TutorAI application..."
    cd "$APP_DIR/backend"
    
    # Start the FastAPI application
    exec uvicorn open_tutorai.main:app --host 0.0.0.0 --port ${PORT:-8080} --workers 1
}

# Main execution
main() {
    # Check required environment variables
    if [ -z "$POSTGRES_HOST" ] || [ -z "$POSTGRES_PORT" ] || [ -z "$POSTGRES_DB" ] || [ -z "$POSTGRES_USER" ] || [ -z "$POSTGRES_PASSWORD" ]; then
        echo "❌ Error: Missing required PostgreSQL environment variables"
        echo "Required: POSTGRES_HOST, POSTGRES_PORT, POSTGRES_DB, POSTGRES_USER, POSTGRES_PASSWORD"
        exit 1
    fi
    
    # Wait for PostgreSQL
    wait_for_postgres
    
    # Run migrations
    run_migrations
    
    # Setup application
    setup_application
    
    # Start application
    start_application
}

# Handle signals for graceful shutdown
trap 'echo "🛑 Received shutdown signal, exiting..."; exit 0' SIGTERM SIGINT

# Run main function
main