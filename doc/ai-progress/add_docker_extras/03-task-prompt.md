# Prompt: Enhance `droid-docker` Flexibility

## Context

You are working in the `factoryai-droid-docker` repository. The primary artifact
is the `droid-docker` Bash wrapper that launches the `wuodan/factoryai-droid`
container with per-project persistence. The `Dockerfile` and `entrypoint.sh`
define the base image used by that wrapper. Developers of varying familiarity
with FactoryAI but comfortable with Docker rely on this tooling.

## Objectives

1. Allow callers to provide additional Docker environment variables, volume
   mounts, and port mappings when running `droid-docker`, without interfering
   with the current behavior that forwards CLI arguments directly into the
   containerized `droid` command.
2. Offer an opt-in configuration so the launched container can start sibling
   containers on the host (Docker-in-Docker style capability) or install Docker
   tooling internally so the `docker` command is available for nested tests.
3. Respect constraints:
   - Arguments passed to `droid-docker` must continue flowing to the container;
     STDIO is already consumed by the container.
   - Favor environment-based or file-based configuration that can be stored
     under the existing per-project cache (e.g.,
     `~/.factoryai-droid-docker/{project}/`).
   - Solutions should be permissive: perform best-effort parsing and let Docker
     report malformed entries.
   - The enhancements must apply to both interactive sessions (`droid-docker`)
     and headless executions (`droid-docker exec ...`).
4. Document the chosen mechanism in-repo before implementation begins and
   obtain approval (from the human operator) on that design document.

## Process Requirements

1. **Discovery**: Inspect current scripts (`droid-docker`, `entrypoint.sh`) and
   relevant docs to understand existing flows.
2. **Design Document**: Produce a markdown file in
   `doc/ai-progress/add_docker_extras/` describing how additional
   envs/volumes/ports will be specified given the constraints. Include file
   formats, lookup order, and how they integrate with the script. Request
   explicit approval before coding.
3. **Planning Log**: Maintain a plan file (e.g.,
   `doc/ai-progress/add_docker_extras/plan.md`) that lists implementation
   phases. Update it as phases start or complete.
4. **Implementation**:
   - Modify `droid-docker` (and `entrypoint.sh` if truly necessary) to load and
     apply the new configuration.
   - Ensure both interactive and exec flows honor the configuration.
   - Keep parsing minimal; hand off syntax errors to Docker.
   - Implement features sequentially: start with port mappings, extend tests to
     cover with/without ports, ensure they pass, then proceed to volume
     handling with corresponding test updates, followed by extra environment
     variables, and finally the Docker nesting capability (either host access or
     in-container installation).
5. **Testing**: After each meaningful code change, run targeted tests (e.g.,
   dry-run commands, sample invocations) and record outcomes in the plan or a
   test log file. Expand automated test coverage alongside each feature before
   moving to the next, including scenarios for enabling the Docker nesting
   capability.
6. **Documentation Update**: Once code works, update relevant docs
   (`README.md`, `droid-docker.md`, etc.) to describe the new configuration
   mechanism.

## Quality Gates

- Run ShellCheck on any modified shell scripts.
- Run PyMarkdown on all touched markdown files.
- Run Hadolint if the Dockerfile changes.
- For other text-based files, use `editorconfig-checker` (install if needed) to
  ensure formatting consistency.

## Deliverables

1. Approved design document detailing the configuration approach for extra
   Docker options.
2. Updated implementation with iterative testing evidence.
3. Revised documentation explaining how users supply additional env vars,
   volumes, and ports.
4. Linting reports (or evidence) showing ShellCheck, PyMarkdown, and any other
   applicable linters were run and issues resolved.
