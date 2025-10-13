# Task: Expand ".gitignore" Handling in "droid-docker"

## Goal

Ensure the ".gitignore" produced by "droid-docker" includes the comment
"# Contains access token" and the entry ".factory/auth.json" so that
credential-bearing files remain ignored by default.

## Requirements

- Locate the logic that emits the ".gitignore" contents.
- Append the comment and path in the established order, without adding an
  idempotent append path for existing files.
- Retain the concise commenting style already present in the script.

## Process

1. **Planning** – Review how the file is generated, prepare the change, and
   present the approach for approval before implementing it.
2. **Implementation and Testing** – Update the script, synchronize expectations
   in the verification tests, and run the full "droid-docker" test suite on a
   real Docker setup so all stages pass.
3. **Review** – Share the changes for feedback prior to linting.

## Quality

After the review, run ShellCheck on the modified Bash files and fix any
diagnostics. Summarize the code changes together with lint and test results,
then wait for explicit approval before closing the task.
