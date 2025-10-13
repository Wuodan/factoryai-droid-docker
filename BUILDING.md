# Building FactoryAI Droid Docker Image

## Normal Build

```shell
docker build -t factoryai-droid:latest .
```

## Multi-Arch Build

### One-time only setup: Switch to `multiarch` builder

```shell
docker buildx create --name multiarch --driver docker-container --use
docker buildx inspect --bootstrap
```

Verify with
```shell
docker buildx ls
```
The `multiarch` builder must be marked with `*`

> To switch back to default builder and remove `multiarch` builder run:<br/>
> ```shell
> docker buildx rm multiarch
> ```

### Build and load locally

```shell
docker buildx build -t factoryai-droid:latest --load .
```

### Build multi-arch locally

```shell
docker buildx build --platform linux/amd64,linux/arm64 -t factoryai-droid:latest .
```

## Note for Users

Users should use the pre-built image `wuodan/factoryai-droid:latest` from Docker Hub rather than building from source.
