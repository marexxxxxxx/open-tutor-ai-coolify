#!/bin/bash
set -e

echo "🔄 Running database migrations..."

# Change to backend directory
cd /app/backend

# Check if alembic is available
if ! command -v alembic &> /dev/null; then
    echo "❌ Alembic not found, installing..."
    pip install alembic
fi

# Run migrations
echo "Running alembic upgrade head..."
alembic upgrade head

echo "✅ Database migrations completed successfully"