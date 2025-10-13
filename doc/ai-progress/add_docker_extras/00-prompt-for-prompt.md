# Task: Create initial prompt for task

To let agentic coding do the software change I need a good initial prompt.
you shall help me write such a prompt by this process
- Task material 1: parse relevant files in this project, especially the Dockerfile, the README.md and the `droid-docker` and `droid-docker.md` 
- Task material 2: parse `short task description` below
- Questions 1: iteratively ask me questions until the scope of the project becomes clear
- work-documentation 1: write a markdown with your summary of the project to doc/ai-progress/add_docker_extras/01-project-description.md
- Questions 2: iteratively ask me questions until the task is clear
- work-documentation 1: write a markdown with your summary of the task to doc/ai-progress/add_docker_extras/02-task-description.md
- Your actual task: Propose me a new prompt in file doc/ai-progress/add_docker_extras/03-task-prompt.md which I can later give to an agentic AI code assistant.
- Ask for my approval and make changes based on my feedback.

Here below is the `short task description

```
# Task: Add options to script `droid-docker` which starts docker container

`droid-docker` currently starts docerk containers with hardcoded ENV vars and hard-coded volumes and no ports.
This is not very flexible - it must be possible to pass additional env-vars, volumes and ports.

Arguments can probably not be used to pass anything to `droid-docker` as arguments to it are passed to the docker container by design.
The docker container which is started also listens on STDIO so most likely that is also not a valid option to pass valies to `droid-docker`.

So the first part of the task is to find a way to pass values given the above technical constraints.
The description of this solution must be in file form, not just in chat.
Approval for this is needed!

And the second part is the change itself.
I expect a planning phase, iterative testing after each small change not only testing after all code changes.
The plan must be persisted in file form and updated when a phase is complete.
Update of documentation comes last.

During the process use appropriate linters for all file types:
- ShellCheck for shell scripts
- PyMarkdown for markdown files
- Hadolint for Dockerfiles
- Propose a linter to me for other file types