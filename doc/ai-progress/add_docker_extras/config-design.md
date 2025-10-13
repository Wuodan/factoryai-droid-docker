# Configuration Design: Extensible Docker Options for `droid-docker`

## Goals
- Preserve current `droid-docker` invocation semantics while enabling optional port mappings, volume mounts, additional environment variables, and Docker nesting.
- Keep configuration per-project by default, with lightweight overrides suitable for command-line workflows.
- Ensure enhancements apply to both interactive (`droid-docker`) and headless (`droid-docker exec …`) usages.

## Configuration Sources & Priority
1. **Environment override** (`DROID_DOCKER_CONFIG_FILE`) – when provided, points to an alternate config file (absolute or relative to CWD). Parsed first. If parsing fails, fall back to environment lists.
2. **Default per-project config file** – located at `~/.factoryai-droid-docker/{cwd}/config.yml`. Attempt YAML parsing; if that fails, retry as JSON (`config.json`) to support users who prefer JSON. Missing files simply mean no extras.
3. **Environment lists** – `DROID_DOCKER_EXTRA_PORTS`, `DROID_DOCKER_EXTRA_VOLUMES`, and `DROID_DOCKER_EXTRA_ENVS`. Each accepts a comma-separated set of raw Docker CLI fragments (e.g., `host:guest`, `./path:/path:ro`, `KEY=value`). These override or append to file values depending on key type (see merge rules).

Result precedence: `config file` values are loaded first, then environment list overrides merge in (replacing existing env keys, appending ports/volumes). `FACTORY_API_KEY` remains mandatory and is never overridden.

## Config File Schema (`config.yml` or `config.json`)

```yaml
ports:
  # Accept either raw strings (forwarded to docker `-p`)…
  - "127.0.0.1:8000:8000"
  - "9000:9000/udp"

volumes:
  # Raw strings passthrough
  - "./host-cache:/home/appuser/cache:ro"
  # Or structured entries converted into `-v` flags
  - name: "shared-cache"
    source: "shared-cache"
    target: "/var/cache"
    mode: "rw"

env:
  FOO: "bar"
  LONG_VAR: "${HOME}/thing"

docker:
  access: "host-socket"   # values: "none" (default) or "host-socket"
  socket_path: "/var/run/docker.sock"
  install_cli: true        # download CLI when access != none
```

### Parsing Notes
- Structured volume entries require `target`; `source` defaults to the project cache path if omitted (useful for named volumes). `mode` defaults to Docker’s standard `rw`.
- Environment values are treated literally; no shell expansion occurs.
- Unknown keys are ignored to maintain forward compatibility.

## Docker Nesting Strategy
- **Default**: `docker.access` is `none`; no additional mounts occur.
- **Host socket access** (`docker.access: host-socket`):
  - Mount configured `socket_path` (default `/var/run/docker.sock`) read-write into the container.
  - Attempt to mount host Docker CLI binary if readable (`/usr/bin/docker` by default). If missing and `install_cli: true`, download a static `docker` client (once per project) into `~/.factoryai-droid-docker/{cwd}/docker-cli/docker`, mounted read-only at `/usr/local/bin/docker` and prepended to `PATH` via `-e PATH=…`.
  - Record download checksum in the cache to avoid redundant fetches.
- Security considerations: mounting the host socket grants the container full Docker control, similar risk profile to DinD but lighter weight and familiar to developers; DinD is not provided to avoid privileged nested daemons.

## Integration Plan for `droid-docker`
1. **Load config file**:
   - Resolve path using overrides/defaults; read contents if present.
   - Use embedded Python (`python3 - <<'PY' … PY`) to attempt YAML parse (`yaml.safe_load`). If YAML unavailable or fails, retry JSON (`json.load`). Treat non-existent file as empty config.
2. **Merge environment overrides**:
   - Ports & volumes: split on commas, strip whitespace, ignore empties; append to lists.
   - Env vars: split on commas, then on first `=`; update/insert key/value pairs.
3. **Compose docker arguments** in deterministic order:
   - Additional `-p` flags for each port.
   - Additional `-v` mounts (structured entries converted to `source:target[:mode]`).
   - Additional `-e KEY=value` for env vars.
   - Host socket mount and CLI path adjustments when `docker.access` enabled.
4. **Preserve existing behavior**: Base mounts for `.factory` and `work`, plus CLI argument passthrough (`exec docker run … "$@"`).
5. **Cache files**: add `.gitignore` rule for new `config.yml`, `config.json`, and `docker-cli/` artifacts to keep secrets out of VCS. Ensure created directories honor `chmod 600` where sensitive (e.g., downloaded CLI checksum not secret but keep consistent perms).

## Testing Strategy
- Extend shell tests sequentially per feature, injecting temporary configs and verifying `docker run` invocations via dry-run / capturing command arguments.
- Add tests for:
  - Ports specified via file and environment.
  - Volume mounts (raw & structured) with precedence checks.
  - Additional env vars ensuring they reach the exec command.
  - Docker nesting (socket present, CLI download path, disabled-by-default behavior).
- Document executed tests and outcomes in `doc/ai-progress/add_docker_extras/plan.md` as each phase progresses.

## Required Tooling
- Run ShellCheck on `droid-docker` (and `entrypoint.sh` if modified).
- Run PyMarkdown on newly created/updated markdown docs.
- Run editorconfig-checker on updated text files. Hadolint only if Dockerfile changes.

## Next Steps
1. Initialize `doc/ai-progress/add_docker_extras/plan.md` with phase checklist and testing log placeholders.
2. Implement features phase-by-phase per roadmap once plan log is in place.
