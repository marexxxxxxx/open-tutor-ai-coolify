# Open TutorAI Coolify Template

This template provides a complete deployment solution for Open TutorAI on Coolify, combining the Python FastAPI backend and Svelte frontend into a single, optimized container.

## 🚀 Quick Start

1. **Deploy to Coolify**
   - In your Coolify dashboard, click "Add Application"
   - Select "From Template" and choose this Open TutorAI template
   - Configure your settings and click "Deploy"

2. **Access Your Application**
   - Once deployed, access your application at the provided URL
   - Default port: 8080
   - First-time setup will guide you through initial configuration

## 📋 System Requirements

- **CPU**: 2 cores minimum, 4 cores recommended
- **Memory**: 4GB minimum, 8GB recommended
- **Storage**: 20GB minimum (for AI models and user data)
- **Database**: PostgreSQL 15 (managed by Coolify)

## ⚙️ Configuration Options

### Build Arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `USE_CUDA` | `false` | Enable CUDA support for GPU acceleration |
| `USE_OLLAMA` | `true` | Include Ollama support in the container |
| `USE_EMBEDDING_MODEL` | `sentence-transformers/all-MiniLM-L6-v2` | Sentence transformer model for embeddings |
| `USE_RERANKING_MODEL` | `""` | Reranking model for RAG (optional) |

### Environment Variables

#### Required
- `POSTGRES_HOST` - PostgreSQL host address
- `POSTGRES_PORT` - PostgreSQL port (default: 5432)
- `POSTGRES_DB` - PostgreSQL database name
- `POSTGRES_USER` - PostgreSQL username
- `POSTGRES_PASSWORD` - PostgreSQL password
- `WEBUI_SECRET_KEY` - Secret key for session management

#### Optional
- `OLLAMA_BASE_URL` - Ollama API base URL (default: http://localhost:11434)
- `OPENAI_API_BASE_URL` - OpenAI API base URL
- `OPENAI_API_KEY` - OpenAI API key
- `ENABLE_SIGNUP` - Enable user registration (default: true)
- `WHISPER_MODEL` - Whisper model for speech recognition (default: base)
- `RAG_EMBEDDING_MODEL` - Embedding model for RAG (default: all-MiniLM-L6-v2)
- `AUTOMATIC1111_BASE_URL` - AUTOMATIC1111 API URL for image generation

## 🏗️ Architecture

This template combines both backend and frontend services into a single container:

- **Backend**: Python FastAPI application with PostgreSQL integration
- **Frontend**: Svelte application built and served as static files
- **Database**: PostgreSQL with pgvector extension for vector embeddings
- **Storage**: Persistent volumes for data, uploads, and model caching

## 📁 Volume Mounts

| Host Volume | Container Path | Purpose |
|-------------|----------------|---------|
| `open-tutorai-data` | `/app/backend/data` | Application data and cache |
| `open-tutorai-uploads` | `/app/backend/data/uploads` | User uploads storage |
| `open-tutorai-models` | `/app/backend/data/cache/embedding/models` | AI models cache |

## 🔧 Post-Deployment Setup

After deployment, the application will automatically:

1. Wait for PostgreSQL to be ready
2. Run database migrations
3. Setup application configuration
4. Start the FastAPI server

### Manual Setup (if needed)

If you need to run setup manually:

```bash
# Access your container
coolify ssh <your-app-name>

# Run setup script
/usr/local/bin/coolify-setup.sh

# Run migrations
/usr/local/bin/migrate.sh
```

## 🧪 Testing Your Deployment

### Health Check
The application provides a health endpoint:
```
GET /health
```

### Basic Functionality Test
1. Access the web interface
2. Create a test user account (if signup is enabled)
3. Test chat functionality with available AI models
4. Verify file upload capabilities
5. Test image generation (if configured)

## 🔍 Monitoring and Logs

### Health Monitoring
- Coolify monitors the `/health` endpoint every 30 seconds
- Application must respond within 10 seconds
- 5 retries before marking as unhealthy

### Log Access
Access application logs through your Coolify dashboard:
1. Go to your application in Coolify
2. Click "Logs" to view real-time application output
3. Use search and filter options to find specific events

## 🚨 Troubleshooting

### Common Issues

#### Database Connection Errors
```
Error: Could not connect to PostgreSQL
```
**Solution**: Verify PostgreSQL service is running and credentials are correct.

#### Migration Failures
```
Error: Alembic migration failed
```
**Solution**: Check database permissions and ensure pgvector extension is installed.

#### Model Download Failures
```
Error: Could not download AI models
```
**Solution**: Check internet connectivity and storage space availability.

#### Frontend Build Issues
```
Error: Frontend assets not found
```
**Solution**: Rebuild the container with `USE_OLLAMA=true` if models are needed.

### Debug Commands

```bash
# Check application status
curl http://localhost:8080/health

# Check database connection
pg_isready -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB

# View application logs
tail -f /app/backend/data/logs/app.log

# Check disk usage
df -h /app/backend/data
```

## 🔄 Updates and Maintenance

### Updating the Application
1. Pull the latest changes from the repository
2. Rebuild the container in Coolify
3. Deploy the updated version

### Database Backups
Coolify provides automatic database backup options:
1. Configure backup schedule in Coolify settings
2. Set retention period for backup files
3. Test restore procedures regularly

### Model Management
AI models are cached in `/app/backend/data/cache/embedding/models`:
- Models are downloaded automatically on first use
- Cache persists across container restarts
- Clear cache to force model re-download if needed

## 🛡️ Security Considerations

### Environment Variables
- Store sensitive data (API keys, passwords) as secrets in Coolify
- Never commit secrets to version control
- Use strong, unique secret keys

### Network Security
- Use HTTPS in production environments
- Configure firewall rules appropriately
- Monitor for unusual traffic patterns

### Data Protection
- Regularly backup database and user data
- Implement proper access controls
- Follow data retention policies

## 📞 Support

For additional support:
- Check the [main Open TutorAI documentation](https://opentutorai.com/docs/intro)
- Join the [Open TutorAI Discord community](https://discord.gg/BTQtE2deEm)
- Report issues on the [GitHub repository](https://github.com/Open-TutorAi/open-tutor-ai-CE)

## 📄 License

This template is provided under the BSD-3-Clause license. See the main repository for full license details.