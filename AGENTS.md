# Agent Engineering Guide

These rules apply to every task in this repository, including code, scripts, configuration, tests, and documentation. Higher-priority instructions and explicit user requirements always take precedence.

## 1. Principles

- **Solve the actual problem.** Understand the requested outcome and constraints before changing anything. Do not substitute a different task, add scope, or perform unrequested refactors.
- **Be practical, not passive.** When the task is clear, take the obvious engineering action. Do not ask the user to do investigation you can reasonably do yourself.
- **Use evidence.** Prefer supplied information, repository state, runtime output, project documentation, and authoritative references over assumptions.
- **Preserve working behavior.** Make the smallest complete change that solves the problem without unnecessarily changing interfaces, configuration, dependencies, or unrelated files.
- **Keep going when something fails.** A failed command, test, or first implementation is feedback. Understand the failure, revise the hypothesis, and try again.
- **Match effort to risk.** Simple changes stay simple. Security-sensitive, compatibility-sensitive, shared, or destructive changes require deeper investigation and stronger verification. A safe default is fine only when the decision is low-risk, reversible, and consistent with project conventions.
- **Be honest.** Never invent facts, claim a check passed when it was not run, or conceal uncertainty and limitations. If blocked by missing access or information, explain the exact blocker and what remains unverified — do not claim success.

## 2. Engineering Loop

Iterate until the requested behavior works or a genuine external blocker is established.

1. **Understand the task.** Identify the expected result, constraints, and what demonstrates success. Use information the user already supplied. For a bug: observed vs expected behavior, error messages, and reproduction conditions. Identify the affected component — do not assume the visible symptom is the root cause. Ask one concise clarifying question only when a missing decision materially blocks safe or correct implementation; otherwise state a reasonable assumption and proceed.
2. **Inspect the existing project.** Check relevant files, documentation, manifests, runtime/version declarations, tests, configuration, and `git status`/diff before editing. Follow established patterns and configured tooling — do not assume the newest installed version is the project's supported version. Keep inspection proportional to the task.
3. **Investigate what you do not know.** Resolve knowledge gaps instead of guessing. Sources, rough order: project docs/tests/manifests → official documentation for the exact tool/package/version → release notes and issue trackers → precise search-engine queries → maintainer discussions → relevant implementation source. Search results are leads, not proof; confirm they apply to the project's actual versions.
4. **Form a hypothesis and implement.** Use evidence to find the most likely cause or requirement. Prefer a small, explainable change over speculative rewrites. Consider compatibility, defaults, permissions, side effects, and failure paths. Implement the complete solution in one pass (no avoidable manual merges or incomplete workarounds). Keep unrelated files and existing user configuration untouched.
5. **Verify the behavior** — the outcome, not merely that the file parses. Choose checks appropriate to the change: syntax/validation, unit or integration tests, a safe runtime reproduction, compatibility or regression checks. Run focused checks first, expand when the change affects shared behavior, security, installation, or system state. Do not run irrelevant tests for activity; do not omit meaningful checks to finish faster.
6. **Debug and repeat.** Read the complete error output and exit status. Determine what the failure proves and does not prove. Check assumptions about versions, paths, permissions, environment, dependencies, and execution context. Revise the hypothesis, apply the smallest change for it, and rerun. Do not repeat a failed command without new evidence. A user correction is important evidence: drop the disproven approach and act on the corrected requirement.

## 3. Investigation Depth

| Risk | Approach |
|---|---|
| Low: isolated, reversible | Inspect relevant context, implement, run a basic targeted check. |
| Medium: dependencies, shared behavior, compatibility | Trace affected interfaces and configuration, verify version support, test affected behavior plus likely regressions. |
| High: security, auth, networking, storage, data integrity, production | Investigate assumptions and failure modes, verify at the system boundary, consider rollback and recovery. |
| Destructive: deletion, migration, permission changes, data loss | Establish scope and impact, preserve recoverability, get explicit authorization unless the user already requested that exact operation. |

Ask before extra investigation: will this materially improve correctness, safety, compatibility, or finishing the task? If not, stay focused.

## 4. Conventions and Compatibility

- Follow existing code, file layout, naming, formatter, linter, type checker, and test conventions.
- Treat manifests, lockfiles, runtime declarations, CI workflows, and support docs as evidence of supported versions. Use APIs, syntax, flags, and options those versions support; do not introduce deprecated or EOL features. Confirm deprecation against official documentation for the applicable version — do not label something deprecated merely because it is old.
- Investigate compiler, linter, type-checker, and LSP diagnostics; confirm a warning applies to the target version before suppressing it.
- Prefer existing dependencies and standard-library functionality. Add a dependency only for a concrete problem it solves.
- Preserve backward compatibility unless a breaking change is required and in scope.

## 5. Code Design and Readability

- Prefer simple, explicit, idiomatic code over clever or compressed solutions. Give each function a clear responsibility with explicit inputs, outputs, and side effects.
- Reuse existing helpers. Extract repeated logic when a focused helper meaningfully reduces duplication; avoid premature abstraction and generic frameworks for one-off tasks.
- Use guard clauses and early returns; avoid unnecessary nesting and mutable global state.
- Names communicate purpose and follow local conventions: action verbs for operations, condition-style names for booleans.
- Comments explain intent, contracts, constraints, invariants, or non-obvious decisions — do not narrate obvious lines. Document public APIs when purpose, parameters, returns, side effects, or failure behavior are not self-evident.
- Do not optimize on guesswork; measure before performance-specific changes.

## 6. Configuration, Input, and Security

- Keep each setting or default in one authoritative place. Distinguish user-configurable values, environment variables, internal defaults, and derived values. Preserve existing user configuration unless the task requires changing it.
- Validate untrusted input at system boundaries: arguments, environment variables, files, networks, external processes.
- Never hard-code, expose, log, or commit secrets, credentials, keys, or machine-specific personal paths.
- Handle errors deliberately; do not silently ignore failures unless the failure is optional and understood. Return meaningful exit codes and actionable error messages without leaking sensitive information.
- Validate state and inputs before privileged or destructive operations; keep elevated privileges narrowly scoped.
- Make installers and system-configuration scripts safe to rerun: detect existing state, avoid duplicates, preserve user data, minimize unnecessary changes.
- Prefer atomic writes and safe temp-file handling; plan cleanup or rollback for multi-step operations.
- Make network downloads fail visibly; verify signatures or checksums when trustworthy verification data exists.
- Avoid broad error suppression (blanket ignore commands, empty catches, wide lint suppressions) except for understood, explained failure paths.

## 7. Tooling and Language References

- Check project instructions first: README, manifests (`package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `composer.json`), compiler settings, formatter/linter config, CI workflows.
- Prefer the configured LSP for navigation and diagnostics; otherwise use the project's compiler, type checker, linter, and tests. Run only tools relevant to the change.
- Standard checks: JS/TS — package scripts, `tsc`; Python — pytest, configured type checker; Rust — `cargo fmt`, `clippy`, `test`; Go — `gofmt`, `go vet`, `go test`; Bash — `bash -n`, ShellCheck.

## 8. Environment

- For missing commands or version issues: `command -v`, `type -a`, `PATH`, `HOME`, active user, and tool version. Check project config and shell startup files (`.profile`, `.bashrc`, `.zshrc`) before assuming a tool is absent.
- Check user-local binaries: `$HOME/.local/bin`, `$HOME/.bun/bin`, `$HOME/.cargo/bin`, `$HOME/.go/bin`, `$HOME/go/bin`, `$HOME/.dotnet/tools`.
- `sudo`, root, and the logged-in user may have different `HOME`, `PATH`, tools, and configuration.

## 9. Change Review

Before finishing, review the complete diff and confirm:

1. The change solves the requested problem and stays within scope.
2. Conventions, compatibility requirements, and relevant interfaces are preserved.
3. Inputs, errors, permissions, security, and side effects are handled deliberately.
4. No secrets, temporary debugging code, dead code, or unrelated changes were introduced.
5. Relevant syntax, formatting, lint, type, test, or runtime checks were run as appropriate.
6. The requested behavior was actually verified, not merely assumed from a successful command.

Keep the final change set small and reviewable. Report what changed, which checks were actually run and their results, and any remaining uncertainty or risk.

## 10. Final Decision Rule

When multiple solutions are technically valid, prefer the one that is easiest to understand, compatible with the project's supported versions, safe to operate and rerun, explicit about errors and side effects, and least complex while fully solving the problem.

These standards guide engineering judgment; they are not a reason to over-engineer simple tasks or to stop investigating a problem that can reasonably be solved.
