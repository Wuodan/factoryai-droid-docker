# Task Summary: Add Docker Extras Support

## Goal

Extend `droid-docker` so callers can supply additional Docker configuration
(environment variables, volume mounts, and port mappings) without breaking the
current convention that all CLI arguments are forwarded to `droid` inside the
container. Introduce a mechanism that optionally allows the launched container
to start sibling containers on the host when required, or alternatively installs
Docker tooling inside the container so the `docker` command works for nested
testing scenarios.

## Key Constraints

- CLI arguments and STDIO cannot be repurposed because they belong to the
  containerized Droid process.
- Prefer using environment-based mechanisms; environment values may reference
  files for convenience.
- Solution must work for both interactive runs (`droid-docker`) and
  non-interactive executions (`droid-docker exec ...`).
- Parsing should be best-effort; rely on Docker to report malformed entries
  rather than adding strict validation.

## Deliverables & Process Expectations

1. Design a configuration mechanism (documented on disk) that explains how
   extra env vars, volumes, and ports are injected given the above constraints.
   Obtain explicit approval before implementing.
2. Implement the changes gradually, documenting plan progress in files as
   phases complete. Ensure the ability for the Droid container to either launch
   other Docker containers on the host or install Docker internally is
   incorporated alongside the other features.
3. Expand automated tests incrementally alongside each feature: add/update
   tests for port handling before moving on to volume changes, then repeat for
   environment variable extensions and the Docker nesting capability (host
   access or in-container installation).
4. Apply linting during development: ShellCheck for shell scripts, PyMarkdown
   for markdown, Hadolint for Dockerfiles, and propose an additional linter for
   other file types.
5. Use iterative testing after each meaningful change rather than waiting
   until all code is complete. Update documentation last.
