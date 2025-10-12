# Droid Docker Helper Script

This script provides a convenient way to run the FactoryAI Droid in a Docker container with persistent configuration and secure API key management.

## Features

- **Secure API Key Management**: Prompts for API key on first run and stores it securely with proper permissions (600)
- **Project-based Configuration**: Creates separate configuration directories for each project path
- **Persistent Settings**: Maintains Droid configuration and settings across container restarts
- **Path Flexibility**: Supports running from any directory or specifying a custom project path

## Usage

### Basic Usage

```bash
# Run from current directory
./droid-docker

# Run from specific project directory
./droid-docker /path/to/your/project

# Pass arguments to droid (must be last parameter)
./droid-docker exec --output-format json "list files"
```

### Command Line Arguments

The script accepts the following arguments:

1. **Optional project path** (first argument): Specify a custom project directory
2. **Droid arguments** (remaining arguments): Passed through to the droid command inside the container

## Configuration

### API Key Setup

On first run, the script will:
1. Prompt for your FactoryAI API key securely (hidden input)
2. Store it in `~/.factoryai-droid-docker/{project-path}/.env`
3. Set proper permissions (readable only by owner)

### Configuration Cache

The script creates a configuration cache at:
```
~/.factoryai-droid-docker/{project-path}/.factory/
```

This directory contains:
- Droid settings and preferences
- MCP (Model Context Protocol) configurations
- Other persistent data

### Git Ignore

Automatically creates a `.gitignore` file in the cache directory to prevent committing sensitive files:

```gitignore
# contains API key
.env
# contains API key
**/.factory/settings.json
# can contain API keys
**/.factory/mcp.json
```

## Docker Container

The script runs the `wuodan/factoryai-droid` Docker image with:
- Interactive terminal access (`-it`)
- Init process (`--init`)
- Persistent volume mounting for configuration
- API key environment variable injection

## Security Notes

- API keys are stored with `chmod 600` permissions (owner read-only)
- The `.env` file is automatically added to `.gitignore`
- Configuration files containing sensitive data are excluded from version control
- The Docker container runs with the current user's permissions

## Troubleshooting

### Common Issues

1. **"Error: path is not a valid directory"**
   - Ensure the specified path exists and is a directory
   - Check permissions on the path

2. **"Error: FACTORY_API_KEY is not set"**
   - Delete the `.env` file and run again to re-enter the API key
   - Check that the `.env` file contains the correct format: `FACTORY_API_KEY='your-key'`

3. **Permission denied errors**
   - Ensure you have read/write access to the project directory
   - Check that Docker can access the specified paths

### Manual Configuration

If you need to manually edit the API key:
```bash
# Edit the .env file
nano ~/.factoryai-droid-docker/{project-path}/.env

# Reset permissions after editing
chmod 600 ~/.factoryai-droid-docker/{project-path}/.env
