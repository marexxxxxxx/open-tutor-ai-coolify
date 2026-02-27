#!/bin/bash
set -e

# Health check script for Open TutorAI
HEALTH_URL="http://localhost:8080/health"
TIMEOUT=10

echo "🔍 Running health check..."

# Check if the application is responding
if curl -f -s --max-time $TIMEOUT "$HEALTH_URL" >/dev/null; then
    echo "✅ Application health check passed"
    exit 0
else
    echo "❌ Application health check failed"
    exit 1
fi