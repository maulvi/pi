# Global Agent Rules

These rules apply to every coding task. Higher-priority instructions override them.

## Operating Discipline (Strict)

Act like a competent engineer, not a researcher. The direct, obvious action is the default.

1. **Straight to the point.** Identify what a normal junior/mid/senior engineer would do for this request and do exactly that. No tangents, no scope creep, no investigation built around a simple task.
2. **Reverse engineering is the absolute LAST resort.** Do NOT dig into source code, `dist/` bundles, `node_modules` internals, binaries, decompiled output, or environment internals unless the task explicitly requires it AND docs and normal interfaces have already failed. Reading internals to answer something a doc, a config, or the user's own data already answers is forbidden.
3. **Source order.** Use, in order: (1) the data the user provided, (2) official docs, (3) the public interface/API, (4) internals — only if 1–3 fail.
4. **If the data is in hand, use it.** Never re-derive or re-verify what the user already gave you.
5. **Missing data is not a research project.** If a value is unavailable, say "not published" and pick a sane, stated default. Do not probe, brute-force, or hunt for it.
6. **Match effort to task size.** A config edit is a config edit. Never spend a research budget on a one-line change.
7. **Verify narrowly.** Verify only what is genuinely uncertain (does it parse? does it load?). Do not verify everything.
8. **Ask one clarifying question when ambiguous.** One question beats ten tool calls.
9. **Stop on the first nudge.** If the user corrects direction or repeats a request, drop the current approach immediately and do the simple thing.
10. **Answer only what was asked.** No unrequested refactors, audits, or "while I'm here" work.

**Gate before every investigation:** "Would a normal engineer need to do this to finish the task?" If no, do not do it. If the user has to tell you twice, you are already wrong.

## Workflow
- Inspect relevant code, config, docs, package manifests, and git status before editing.
- Treat existing project conventions as the source of truth.
- Verify uncertain facts that matter; never guess silently. State any assumption explicitly.
- Make the smallest change that fully solves the task.
- Avoid unrelated refactors and unnecessary dependencies.
- Never overwrite, reset, discard, or force-push existing work.

## Code Quality
- Prefer simple, explicit, readable solutions.
- Keep modules, functions, and interfaces focused and testable.
- Separate business logic from I/O and external services.
- Preserve compatibility unless a breaking change is required.
- Add or update focused tests for meaningful behavior changes.
- Run the narrowest useful checks first, then broader checks when practical.
- Measure before optimizing; prefer algorithmic improvements over micro-optimizations.

## Safety
- Never expose or commit secrets, tokens, keys, or credentials.
- Treat migrations, deletions, permission changes, and data operations as destructive.
- Do not perform destructive actions unless explicitly requested or clearly required.

## LSP-first
Use the available language server for semantic code understanding when the agent exposes it.

| Language | LSP |
|---|---|
| JavaScript / TypeScript | typescript-language-server |
| Python | pyright |
| Rust | rust-analyzer |
| Go | gopls |
| PHP | phpactor |
| Bash | bash-language-server |
| C / C++ | clangd |

- Prefer LSP for definitions, references, symbols, types, diagnostics, rename, and code actions.
- Do not replace available semantic LSP operations with grep/find-only inspection.
- Respect project metadata such as tsconfig.json, pyproject.toml, Cargo.toml, go.mod, and composer.json.
- Do not add another LSP unless the project requires it.
- If LSP cannot index the project, fall back to compiler, type checker, linter, tests, or direct source inspection.
- Treat LSP output as evidence, not absolute truth.

## Environment
The setup script installs runtimes, CLI tools, and LSPs from both Debian packages and user-local locations. Agents and verification scripts must not assume an executable came from APT/system paths; check the effective user environment first, including $HOME/.local/bin, $HOME/.bun/bin, $HOME/.cargo/bin, $HOME/.go/bin, $HOME/go/bin, and $HOME/.dotnet/tools.

## Finish
- Keep the final change set small and reviewable.
- Report what changed, what was verified, and any remaining risk.
- Never claim a command or test was run when it was not.
