# factory-droid-docker

## Build

### One-time only: Switch to `multiarch` builder
```commandline
docker buildx create --name multiarch --driver docker-container --use
docker buildx inspect --bootstrap
```
Verify with
```commandline
docker buildx ls
```
The `multiarch` builder must be marked with `*`

> To remove `multiarch` builder and switch to default builder run:<br/>
> `docker buildx rm multiarch`<br/>
> but why would anyone want to do that :-)

### Build and import locally

```commandline
docker buildx bake -f docker-bake.hcl --load
```

### Build multi-arch locally

```commandline
docker buildx bake --set '*.platform=linux/amd64,linux/arm64'
```