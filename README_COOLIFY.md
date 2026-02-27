# Open TutorAI - Coolify Deployment Guide

This guide explains how to deploy Open TutorAI using Coolify with external AI services (llama.cpp) instead of local Ollama installation.

## Overview

This configuration allows you to:
- Deploy Open TutorAI on Coolify without installing Ollama or Atomic locally
- Connect to external AI services (llama.cpp) running on another machine
- Use the application via API endpoint at 192.168.1.24:8080

## Prerequisites

### External AI Service Setup
Before deploying Open TutorAI, ensure your external AI service is running:

1. **llama.cpp Server** on 192.168.1.24:8080
   - Install and configure llama.cpp with OpenAI-compatible API
   - Ensure the server is accessible from your Coolify deployment
   - Test the connection: `curl http://192.168.1.24:8080/v1/models`

2. **Network Access**
   - Ensure 192.168.1.24:8080 is reachable from your Coolify server
   - Check firewall settings if connection fails

## Deployment Steps

### 1. Clone the Repository
```bash
git clone https://github.com/your-repo/open-tutor-ai-CE.git
cd open-tutor-ai-CE
```

### 2. Configure Coolify Template
The `.coolify/template.json` file is pre-configured with:
- `USE_OLLAMA: false` - Disables Ollama installation
- External AI service endpoint: `http://192.168.1.24:8080/v1`
- Proper environment variables for external AI connection

### 3. Deploy via Coolify
1. In Coolify, create a new application
2. Select "Dockerfile" deployment type
3. Point to this repository
4. Use `Dockerfile.coolify` as the Dockerfile
5. Configure the build arguments:
   - `USE_OLLAMA: false` (default)
   - `USE_CUDA: false` (default, unless you need GPU)
6. Set environment variables:
   - `POSTGRES_HOST`: Your PostgreSQL host
   - `POSTGRES_PORT`: PostgreSQL port (default: 5432)
   - `POSTGRES_DB`: Database name
   - `POSTGRES_USER`: Database user
   - `POSTGRES_PASSWORD`: Database password
   - `WEBUI_SECRET_KEY`: Auto-generated if not provided

### 4. Application Configuration
The application will automatically configure:
- External AI service at `http://192.168.1.24:8080/v1`
- No local AI services (Ollama, Atomic)
- Proper CORS and network settings

## Environment Variables

### Required
- `POSTGRES_HOST`: PostgreSQL database host
- `POSTGRES_PORT`: PostgreSQL port (default: 5432)
- `POSTGRES_DB`: Database name
- `POSTGRES_USER`: Database username
- `POSTGRES_PASSWORD`: Database password
- `WEBUI_SECRET_KEY`: Session secret key

### Optional (Pre-configured)
- `OLLAMA_BASE_URL`: Leave empty (disabled)
- `OPENAI_API_BASE_URL`: `http://192.168.1.24:8080/v1` (llama.cpp endpoint)
- `OPENAI_API_KEY`: Leave empty (no auth for llama.cpp)
- `ENABLE_SIGNUP`: Enable user registration (default: true)

## Verification

After deployment:

1. **Check Application Health**
   - Visit your application URL
   - Verify the health check passes

2. **Test AI Connection**
   - The application will test connection to 192.168.1.24:8080 during startup
   - Check logs for connection status

3. **Verify Functionality**
   - Create a test user account
   - Try creating a support request
   - Test AI responses through the interface

## Troubleshooting

### Connection Issues
If the application cannot connect to 192.168.1.24:8080:

1. **Check Network Connectivity**
   ```bash
   # From your Coolify server
   ping 192.168.1.24
   telnet 192.168.1.24 8080
   ```

2. **Verify llama.cpp Server**
   ```bash
   # From the AI server
   curl http://localhost:8080/v1/models
   ```

3. **Check Firewall Settings**
   - Ensure port 8080 is open on 192.168.1.24
   - Check for any network restrictions

### Application Issues
1. **Check Logs**
   - Review Coolify deployment logs
   - Look for database connection errors
   - Check AI service connection messages

2. **Environment Variables**
   - Verify all required environment variables are set
   - Ensure PostgreSQL credentials are correct

## Security Notes

- The application uses OpenAI-compatible API format
- No authentication required for llama.cpp (adjust if needed)
- Consider using HTTPS for production deployments
- Secure your PostgreSQL database with proper credentials

## Support

For issues related to:
- **Coolify Deployment**: Check Coolify documentation
- **Open TutorAI**: Refer to main README.md
- **llama.cpp Configuration**: Check llama.cpp documentation
- **Network Issues**: Verify your network setup and firewall rules

## Files Modified for Coolify

- `Dockerfile.coolify`: Updated to disable Ollama, configure external AI
- `.coolify/template.json`: Coolify deployment template
- `scripts/coolify-setup.sh`: Setup script with external AI configuration
- `scripts/entrypoint.sh`: Startup script with connection testing