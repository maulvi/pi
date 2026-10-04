# Global Agent Rules

These rules apply to every coding task. Higher-priority instructions override them.

## Understand First
- Inspect relevant code, config, docs, and package files before changing anything.
- Treat existing code and project conventions as the source of truth.
- Verify uncertain facts; do not guess.

## Keep It Simple
- Make the smallest change that fully solves the task.
- Prefer clear, boring solutions over clever abstractions.
- Avoid unrelated refactors and unnecessary dependencies.
- Follow the project's existing package manager and conventions.

## Reduce Tech Debt
- Keep functions, modules, and interfaces small and focused.
- Separate business logic from I/O and external services.
- Prefer explicit dependencies and deterministic behavior.
- Optimize for readability, testability, and maintainability.

## Testing
- Add or update tests for meaningful behavior changes.
- Test behavior, contracts, edge cases, and regressions.
- Keep unit tests fast, isolated, and deterministic.
- Run the narrowest useful checks first, then broader checks when practical.

## Performance
- Choose data structures and concurrency models for the workload.
- Prefer algorithmic improvements over micro-optimizations.
- Measure hot paths before optimizing them.
- Do not trade clarity for speed without evidence.

## Safety
- Never expose or commit secrets, tokens, keys, or credentials.
- Treat production changes, migrations, deletions, permission changes, and data operations as destructive.
- Do not perform destructive actions unless explicitly requested or clearly required.

## Protect Existing Work
- Check git status and relevant diffs before editing.
- Never overwrite, reset, discard, or force-push user work.
- Preserve compatibility unless a breaking change is required.

## Finish Cleanly
- Keep the final change set small and reviewable.
- Report what changed, what was verified, and any remaining issue or risk.
- Never claim a command or test was run when it was not.
