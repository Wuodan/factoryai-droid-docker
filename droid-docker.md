# Droid Docker Helper

Runs FactoryAI Droid in Docker with persistent configuration per project folder.

## Key Differences from Normal Droid

- **Isolated Configuration**: Each project folder gets its own cache at `~/.factoryai-droid-docker/{project-path}/.factory/`

## Usage

```bash
# Run from a project directory (not from droid-docker's own folder)
/path/to/droid-docker/droid-docker

# Pass arguments to droid
/path/to/droid-docker/droid-docker exec --output-format json "list files"
```

**Important**: Call this script from your project folder, not from the
droid-docker directory itself.

## Configuration

### API Key Setup

First run prompts for FactoryAI API key (hidden input) and stores in
`~/.factoryai-droid-docker/{project-path}/.env` with `chmod 600` permissions.

> **Note**: Unlike normal droid, API key must be entered once per project folder,
> not globally.

### Cache Location

Configuration cache stored at: `~/.factoryai-droid-docker/{project-path}/.factory/`

## Docker Setup

Runs `wuodan/factoryai-droid` image with:
- Interactive terminal (`-it`)
- Init process (`--init`)
- Volume mount for configuration persistence
- API key environment injection

## Troubleshooting

### Error: FACTORY_API_KEY is not set

- Delete `.env` file and rerun to re-enter API key
- Verify `.env` format: `FACTORY_API_KEY='your-key'`

### Permission errors

- Check project directory read/write access
- Verify Docker path permissions
