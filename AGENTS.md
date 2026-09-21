# Global Agent Rules

These rules apply to every coding task. Higher-priority instructions override them.

## 1. Understand First
- Inspect relevant code, config, docs, and package files before changing anything.
- Treat existing code and project conventions as the source of truth.
- Verify uncertain facts; do not guess.

## 2. Keep It Simple
- Make the smallest change that fully solves the task.
- Prefer clear, boring solutions over clever abstractions.
- Do not refactor unrelated code.
- Reuse existing dependencies and tools; add new ones only when justified.
- Follow the project's existing package manager and conventions.

## 3. Design for Low Tech Debt
- Keep functions, modules, and interfaces small and focused.
- Separate business logic from I/O, frameworks, and external services.
- Prefer deterministic code with explicit dependencies over hidden global state.
- Optimize for readability, testability, and changeability before micro-optimizing.
- When touching an area, fix small obvious debt when it reduces future complexity; avoid unrelated rewrites.

## 4. Testing
- Add or update tests with meaningful behavior changes.
- Test behavior, contracts, edge cases, and regressions—not implementation trivia.
- Keep unit tests fast, isolated, deterministic, and free from real network/external services.
- Mock or fake at system boundaries, not deep inside business logic.
- Run the narrowest useful checks first, then broader checks when practical.

## 5. Protect Existing Work
- Check `git status` and relevant diffs before editing.
- Never overwrite, reset, or discard user changes.
- Never force-push.
- Preserve compatibility unless a breaking change is required.

## 6. Performance
- Choose data structures and concurrency models for the workload.
- Prefer algorithmic improvements over micro-optimizations.
- Measure hot paths before optimizing them.
- Do not trade clarity for speed without evidence.

## 7. Safety
- Never expose, commit, or log secrets, tokens, keys, or credentials.
- Treat production changes, migrations, deletions, permission changes, and data operations as destructive.
- Do not perform destructive actions unless explicitly requested or clearly required.

## 8. Language Playbooks
When working in a language, read the matching guide in `languages/<language>/AGENTS.md` when it exists. It contains language-specific design, naming, performance, and testing rules.

## 9. Finish Cleanly
- Keep the final change set small and reviewable.
- Report what changed, what was verified, and any remaining issue or risk.
- Never claim a command or test was run when it was not.
