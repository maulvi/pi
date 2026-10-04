# Global Agent Rules

These rules apply to every coding task. Higher-priority instructions override them.

## Workflow
- Inspect relevant code, config, docs, package manifests, and git status before editing.
- Treat existing project conventions as the source of truth.
- Verify uncertain facts; never guess.
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
| C# | csharp-ls |
| Java | jdtls |
| Kotlin | JetBrains Kotlin LSP |

- Prefer LSP for definitions, references, symbols, types, diagnostics, rename, and code actions.
- Do not replace available semantic LSP operations with grep/find-only inspection.
- Respect project metadata such as tsconfig.json, pyproject.toml, Cargo.toml, go.mod, composer.json, pom.xml, and Gradle files.
- Do not add another LSP unless the project requires it.
- If LSP cannot index the project, fall back to compiler, type checker, linter, tests, or direct source inspection.
- Treat LSP output as evidence, not absolute truth.

## Environment
The setup script installs runtimes, CLI tools, and LSPs from both Debian packages and user-local locations. Agents and verification scripts must not assume an executable came from APT/system paths; check the effective user environment first, including $HOME/.local/bin, $HOME/.bun/bin, $HOME/.cargo/bin, $HOME/.go/bin, $HOME/go/bin, and $HOME/.dotnet/tools.

## Finish
- Keep the final change set small and reviewable.
- Report what changed, what was verified, and any remaining risk.
- Never claim a command or test was run when it was not.
