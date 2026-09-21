# Bash Agent Guide

## Core
- Use Bash for orchestration, deployment glue, and system automation—not complex application logic.
- Prefer shell builtins over spawning external commands when the difference matters.
- Quote variables by default: `"$var"`.
- Use arrays for argument lists; never build command strings when an array will do.

## Naming
- snake_case for functions/variables; UPPER_SNAKE_CASE for exported/config constants.
- Functions should be verbs: `install_packages`, `wait_for_service`.
- Avoid single-letter names outside tiny loops.

## Safety
- Start with `set -euo pipefail` when appropriate, but understand its edge cases.
- Validate required commands, arguments, paths, and environment before destructive operations.
- Use `--` before user-controlled paths where supported.
- Never silently ignore failures from critical commands.

## Performance
- Each external process has overhead. Avoid loops that repeatedly invoke `sed`, `grep`, `cat`, etc. when Bash builtins can do the job.
- Do not rewrite substantial text-processing logic into Bash just to avoid another tool; readability wins.
- For heavy parsing, concurrency, or data processing, use Python/Go/Rust instead.

## Testing
- ShellCheck is mandatory for non-trivial scripts when available.
- Keep side effects behind functions so core decisions can be tested.
- For important scripts, use Bats or a project-equivalent test framework.

## Avoid
Unquoted expansions, `eval`, parsing human-oriented command output when machine-readable output exists, giant Bash scripts, clever one-liners.
