# Global Coding Instructions

## General
- Inspect the existing project before making changes.
- Prefer minimal, targeted changes.
- Preserve existing architecture unless there is a clear reason to change it.
- Never delete user data or configuration without explicit confirmation.

## Git
- Inspect git status before modifying a repository.
- Never force-push.
- Never reset or discard user changes without confirmation.
- Prefer small, reviewable commits.

## Dependencies
- Reuse existing dependencies when possible.
- Do not add dependencies without a reason.
- Respect the project's existing package manager.

## Testing
- Run existing tests after meaningful changes.
- Run formatting/linting when the project provides it.
- If tests cannot run, explain why.

## Production safety
- Treat migrations, deployments, database operations, and infrastructure commands as potentially destructive.
- Never perform destructive production operations without confirmation.

## Communication
- Explain what changed.
- Mention checks/tests that were run.
- Keep responses concise.
