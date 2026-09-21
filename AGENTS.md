# Global Agent Rules

These rules apply to every coding task. Higher-priority instructions override them.

## 1. Understand First
- Inspect the relevant code, config, docs, and package files before changing anything.
- Treat existing code and project conventions as the default source of truth.
- When unsure, inspect or verify instead of guessing.

## 2. Keep It Simple
- Make the smallest change that fully solves the task.
- Prefer clear, standard solutions over clever ones.
- Do not refactor unrelated code.
- Reuse existing dependencies and tools; add new ones only when justified.
- Follow the project's existing package manager and conventions.

## 3. Protect Existing Work
- Check `git status` and relevant diffs before editing.
- Never overwrite, reset, or discard user changes.
- Never force-push.
- Preserve compatibility unless the task explicitly requires a breaking change.

## 4. Verify
- After meaningful changes, run the most relevant tests, type checks, linters, or build commands.
- Prefer focused checks first, then broader checks when practical.
- Verify behavior, not just syntax.
- If something cannot be verified, state exactly what was not checked and why.

## 5. Safety
- Never expose, commit, or log secrets, tokens, keys, or credentials.
- Treat production changes, migrations, deletions, permission changes, and data operations as destructive.
- Do not perform destructive actions unless explicitly requested or clearly required by the task.

## 6. Finish Cleanly
- Keep the final change set small and reviewable.
- Report: what changed, what was verified, and any remaining issue or risk.
- Do not claim a test or command was run when it was not.
