# FactoryAI Droid Docker

Isolated AI Development Environment

---

Run FactoryAI Droid in Docker with persistent configuration and host isolation.

## What is FactoryAI Droid?

FactoryAI Droid is an AI-powered development agent that automates software
development workflows. Learn more at [factory.ai](https://factory.ai/).

## Usage

### Direct Docker Run

```bash
# Set your API key
export FACTORY_API_KEY="your-api-key-here"

# Run from your project directory
docker run --rm -it \
  -v "$(pwd)":/home/appuser/work \
  -e FACTORY_API_KEY="$FACTORY_API_KEY" \
  wuodan/factoryai-droid:latest
```

### droid-docker command

For per-project persistence and easier API key management:

```bash
# Install droid-docker globally
curl -o /tmp/droid-docker https://raw.githubusercontent.com/Wuodan/factoryai-droid-docker/main/droid-docker
sudo mv /tmp/droid-docker /usr/local/bin/
sudo chmod +x /usr/local/bin/droid-docker

# Run from your project directory
droid-docker

# Execute commands
droid-docker exec "analyze codebase"
```

## Configuration

Per-project configuration persists in `~/.factoryai-droid-docker/{project-path}/.factory/`.

See [droid-docker.md](droid-docker.md) for detailed usage.

## Building

See [BUILDING.md](BUILDING.md) for build instructions.
