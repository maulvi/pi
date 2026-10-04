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


## LSP-first Development

This workstation installs a system-wide language server for the supported languages below. Use LSP capabilities as the first choice for semantic code understanding when the active coding agent exposes them.

| Language | LSP |
| --- | --- |
| JavaScript / TypeScript | `typescript-language-server` |
| Python | `pyright-langserver` / `pyright` |
| Rust | `rust-analyzer` |
| Go | `gopls` |
| PHP | `phpactor` |
| Bash | `bash-language-server` |
| C / C++ | `clangd` |
| C# | `csharp-ls` |
| Java | `jdtls` |
| Kotlin | JetBrains Kotlin LSP (`kotlin-lsp`) |

### LSP Rules
- Prefer LSP for go-to-definition, find-references, symbols, type information, diagnostics, rename, and code actions when supported.
- Do not replace semantic LSP operations with grep/find-only approaches when an LSP is available.
- Respect the project's existing configuration and build metadata such as `tsconfig.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `composer.json`, `pom.xml`, and Gradle files.
- Do not add a second project-local language server unless the project explicitly pins or requires a different implementation.
- When an LSP is unavailable or cannot index the project, fall back to the language compiler, type checker, linter, or direct source inspection.
- Treat LSP output as evidence, not absolute truth; verify important behavior with tests and project tooling.

### Supported Language Tooling
- JavaScript/TypeScript uses `typescript-language-server` with TypeScript.
- Python uses Pyright.
- Rust uses the `rust-analyzer` rustup component and `rust-src`.
- Go uses the official `gopls` server.
- PHP uses Phpactor and Composer.
- Bash uses `bash-language-server` with ShellCheck.
- C/C++ uses LLVM `clangd`.
- C# uses `csharp-ls` on .NET 10.
- Java uses Eclipse JDT Language Server on JDK 21+.
- Kotlin uses JetBrains' official Kotlin Language Server.

Keep the LSP layer independent from application code. Do not hard-code a specific editor's LSP configuration into projects unless the project already uses that editor.

## Finish Cleanly
- Keep the final change set small and reviewable.
- Report what changed, what was verified, and any remaining issue or risk.
- Never claim a command or test was run when it was not.
