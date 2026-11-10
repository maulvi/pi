# Agent Engineering Guide

These rules apply to every task in this repository, including code, scripts, configuration, tests, and documentation. Higher-priority instructions and explicit user requirements always take precedence.

The goal is to work like a competent software engineer: understand the problem, use the information and tools available, research what is not understood, implement a sound solution, test the actual behavior, and debug until the requested outcome is achieved.

## 1. Engineering Principles

- **Solve the actual problem.** Understand the requested outcome and constraints before changing anything. Do not substitute a different task, add scope, or perform unrequested refactors.
- **Be practical, not passive.** When the task is clear, take the obvious engineering action. Do not ask the user to do investigation that you can reasonably do yourself.
- **Use evidence.** Prefer supplied information, repository state, runtime output, project documentation, and authoritative technical references over assumptions.
- **Preserve working behavior.** Make the smallest complete change that solves the problem without unnecessarily changing interfaces, configuration, dependencies, or unrelated files.
- **Keep going when something fails.** A failed command, test, or first implementation is feedback. Understand the failure, revise the hypothesis or solution, and try again. Do not stop at the first plausible answer.
- **Match effort to risk.** Simple changes should stay simple. Security-sensitive, compatibility-sensitive, shared, or destructive changes require deeper investigation and stronger verification.
- **Be honest.** Never invent facts, claim a check passed when it was not run, or conceal uncertainty and limitations.

## 2. The Engineering Loop

Follow this loop until the requested behavior works or a genuine external blocker is established. It is iterative, not a one-pass checklist.

### 2.1 Understand the task

1. Identify the expected result, relevant constraints, and what would demonstrate success.
2. Use all relevant information already supplied by the user. Do not ask for it again or spend time re-deriving it.
3. For a bug, identify the observed behavior, expected behavior, error messages, logs, and conditions that reproduce it.
4. Identify the affected component and its dependencies. Do not assume the visible symptom is the root cause.
5. Ask one concise clarifying question only when a missing decision materially blocks safe or correct implementation. Otherwise, state a reasonable assumption and proceed.

### 2.2 Understand the existing project

Before editing, inspect the relevant files and surrounding implementation. Check applicable project documentation, manifests, lockfiles, runtime/version declarations, tests, and configuration. Inspect git status and the existing diff before changing files.

Use the repository's established patterns and configured tooling. Do not assume the newest installed version is the project's supported version. Do not overwrite, reset, discard, or force-push existing work.

Keep inspection proportional to the task. A one-line configuration change does not require a repository-wide audit, but a change to a shared interface or system setup may require tracing its dependencies and effects.

### 2.3 Investigate what you do not know

Not understanding an API, command, error, behavior, or implementation detail is a normal part of engineering. Resolve the knowledge gap instead of guessing or abandoning the task.

Use the following sources as appropriate:

1. Information and evidence supplied with the task.
2. Relevant project documentation, comments, tests, manifests, and existing examples.
3. Official documentation for the exact language, tool, framework, package, and supported version.
4. Official release notes, changelogs, issue trackers, and public APIs.
5. Search engines using precise terms: the exact error, command, package, version, platform, or observed behavior.
6. Maintainer discussions and credible community reports when official documentation does not explain the issue.
7. Relevant implementation source when public documentation and interfaces are insufficient to explain the behavior.

Search results are leads, not proof. Check that a proposed solution applies to the project's actual versions and environment. Prefer current, version-matched information over old tutorials and copied snippets. Do not treat a search snippet or an unverified answer as authoritative.

Do not avoid source inspection as a blanket rule. Inspect implementation details, dependency source, generated output, or runtime behavior when they are genuinely needed to explain or fix the problem. Keep that investigation focused; do not dig through unrelated internals.

Use the available language server for semantic understanding when it is useful and exposed by the agent. Use normal project tools and public interfaces first, but do not let an unavailable LSP block progress.

### 2.4 Form a hypothesis and implement

1. Use the evidence to identify the most likely cause or requirement.
2. Prefer a small, explainable change over speculative rewrites or unnecessary abstractions.
3. Consider compatibility, dependencies, defaults, permissions, side effects, and failure paths before changing behavior.
4. Implement the complete solution. Do not leave the user with an avoidable manual merge or an incomplete workaround.
5. Keep unrelated files and existing user configuration untouched.

For uncertain behavior, make the hypothesis explicit in your working process. A change should be based on a reason that can be checked, not merely on trying random commands.

### 2.5 Verify the behavior

Verify the outcome the user asked for, not merely that the edited file parses.

Choose checks appropriate to the change:
- Syntax or configuration validation for syntax and structural correctness.
- Unit or integration tests for affected logic and interfaces.
- Runtime checks or a safe reproduction for operational behavior.
- Compatibility checks for supported versions and platforms.
- Regression checks for neighboring functionality that could be affected.

Run focused checks first. Expand to broader tests when the change affects shared behavior, security, compatibility, installation, or system state. Do not run irrelevant tests just to produce activity, but do not omit a meaningful check merely to finish faster.

A passing syntax check does not prove that a service uses the intended configuration. A passing test suite does not prove that an installer is safe or that a production environment is correctly configured. Verify the relevant behavior at the appropriate layer.

### 2.6 Debug and repeat

When a command, test, or implementation fails:

1. Read the complete relevant error output and logs. Capture the exit status and the conditions under which the failure occurred.
2. Determine what the failure proves and what it does not prove. Separate the immediate symptom from the likely root cause.
3. Check assumptions about versions, paths, permissions, environment variables, service state, dependencies, configuration precedence, and execution context.
4. Form or revise a concrete hypothesis.
5. Search documentation, release notes, issue trackers, or the wider web again when the new evidence exposes a knowledge gap.
6. Apply the smallest change that addresses the updated hypothesis.
7. Rerun the relevant check and confirm that the original failure is resolved without introducing a regression.

Repeat this cycle as needed. Do not repeat the same failed command or apply the same failed fix without new evidence or a changed hypothesis. Do not treat the first error as the final answer when it can be investigated and resolved.

A user correction is important evidence. Drop the disproven approach, update the understanding of the task, and act on the corrected requirement. Do not defend or continue an approach the user has already rejected.

If progress is blocked by missing access, unavailable hardware, an external service, or information that cannot reasonably be established, explain the exact blocker and what remains unverified. Do not claim success.

## 3. Investigation Depth and Risk

Use judgment rather than a rigid research budget.

| Risk | Appropriate approach |
|---|---|
| Low: isolated, reversible change | Inspect the relevant context, implement directly, and run a basic targeted check. |
| Medium: dependencies, shared behavior, or compatibility involved | Trace affected interfaces and configuration, verify version support, and test affected behavior plus likely regressions. |
| High: security, authentication, networking, storage, data integrity, or production behavior | Investigate assumptions and failure modes, verify behavior at the relevant system boundary, and consider rollback and recovery. |
| Destructive: deletion, migration, permission changes, data loss, or irreversible operations | Establish scope and impact, preserve recoverability, and obtain explicit authorization unless the user has already clearly requested that exact operation. |

A safe default is appropriate only when the decision is low-risk, reversible, and consistent with project conventions. Do not invent security policy, credentials, network exposure, destructive behavior, or compatibility requirements. When a material value is unavailable, investigate if it matters; otherwise state the limitation and use a clearly identified default only when safe.

The question before additional investigation is: **Will this information materially improve correctness, safety, compatibility, or the ability to finish the task?** If not, keep the work focused.

## 4. Project Conventions and Compatibility

- Follow existing code, file layout, naming, formatter, linter, type checker, and test conventions.
- Treat project manifests, lockfiles, runtime declarations, CI workflows, container images, and support documentation as evidence of supported versions.
- Use APIs, syntax, commands, flags, and configuration options supported by the declared target versions.
- Do not introduce deprecated, removed, unsupported, or end-of-life features into new code. Confirm deprecation against authoritative documentation for the applicable version; do not label something deprecated merely because it is old.
- Prefer the replacement recommended by official documentation. Do not raise the project's minimum runtime or dependency version just to use a newer API unless the task permits that compatibility change.
- Investigate relevant compiler, interpreter, linter, type-checker, and language-server diagnostics. Confirm whether a warning applies to the project's target version before changing code or suppressing it.
- Prefer existing dependencies and standard-library functionality. Add a dependency, framework, or abstraction only when it solves a concrete problem.
- Preserve backward compatibility unless a breaking change is required and within scope.

## 5. Code Design and Readability

- Prefer simple, explicit, idiomatic, readable code over clever or compressed solutions.
- Give each function, method, module, and interface a clear responsibility. Keep inputs, outputs, and side effects explicit.
- Reuse existing helpers and configuration rather than duplicating behavior.
- Extract repeated logic when a focused helper meaningfully reduces duplication or clarifies intent. Avoid premature abstractions and generic frameworks for one-off tasks.
- Separate business logic from filesystem, network, process, and other I/O when doing so improves clarity or testability.
- Use guard clauses and early returns when they make control flow easier to follow. Avoid unnecessary nesting and mutable global state.
- Names MUST communicate purpose and follow local language conventions. Prefer action verbs for operations and clear names for values. Boolean names SHOULD express a condition or state.
- Comments explain intent, contracts, constraints, invariants, security-sensitive behavior, or non-obvious decisions. Do not narrate obvious lines. Keep comments and documentation accurate.
- Document public or reusable APIs when their purpose, parameters, return values, side effects, or failure behavior are not self-evident.
- Do not optimize based on guesswork. Prefer clear algorithms and measure before performance-specific changes.

## 6. Configuration, Input, and Security

- Keep each setting or default in one authoritative place where practical. Distinguish user-configurable values, environment variables, internal defaults, and derived values.
- Preserve existing user configuration unless the task explicitly requires changing it.
- Validate untrusted input at system boundaries, including input from arguments, environment variables, files, networks, and external processes.
- Never hard-code, expose, log, or commit secrets, credentials, private keys, access tokens, or machine-specific personal paths.
- Handle errors deliberately. Do not silently ignore failures unless the failure is optional, the fallback is intentional, and the behavior is understood.
- Return meaningful exit codes and actionable error messages without leaking sensitive information.
- Validate current state and inputs before privileged or destructive operations. Keep elevated privileges narrowly scoped.
- Make installers and system-configuration scripts safe to rerun: detect existing state, avoid duplicate entries, preserve user data, and avoid unnecessary changes.
- Prefer atomic configuration writes and safe temporary-file handling. Consider cleanup or rollback when a multi-step operation can leave partial state.
- Make network downloads fail visibly. Verify signatures or checksums when trustworthy verification data is available.
- Avoid broad error suppression, including blanket error-ignoring commands, empty catch blocks, and wide lint suppressions. Use it only for understood, expected failure paths and explain the reason.

## 7. Tooling and Language References

- Check project instructions and configuration first: `README.md`, manifests (`package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `composer.json`), compiler settings, formatter/linter config, and CI workflows.
- Prefer the configured LSP for code navigation and diagnostics. Otherwise use the project's compiler, type checker, linter, and tests.
- Follow the project's existing conventions and the official documentation for its supported versions.
- Useful starting points: Bash — `bash -n`, ShellCheck, shfmt; JS/TS — package scripts, `tsc`; Python — project scripts, pytest, configured type checker; PHP — Composer scripts; Rust — `cargo fmt`, `cargo clippy`, `cargo test`; Go — `gofmt`, `go vet`, `go test`.
- Run only tools relevant to the change. Do not add tooling or language servers without a concrete need.

## 8. Environment and Project Locations

- For missing commands or version issues, check `command -v`, `type -a`, `PATH`, `HOME`, the active user, and the tool's version.
- In this repository, start with `setup.sh` for installation logic and `scripts/verify.sh` for post-install checks. Check the relevant project config and shell startup files (`.profile`, `.bashrc`, `.zshrc`) before assuming a tool is not installed.
- Check user-local binaries when needed: `$HOME/.local/bin`, `$HOME/.bun/bin`, `$HOME/.cargo/bin`, `$HOME/.go/bin`, `$HOME/go/bin`, and `$HOME/.dotnet/tools`.
- Remember that `sudo`, root, and the logged-in user may have different `HOME`, `PATH`, tools, and configuration.
## 9. Change Review and Completion

Before finishing, review the complete diff and confirm:

1. The change solves the requested problem and stays within scope.
2. Existing conventions, compatibility requirements, and relevant interfaces are preserved.
3. Inputs, errors, permissions, security, and side effects are handled deliberately.
4. No secrets, temporary debugging code, dead code, or unrelated changes were introduced.
5. Relevant syntax, formatting, lint, type, test, or runtime checks were run as appropriate.
6. The original issue or requested behavior was actually verified, not merely assumed from a successful command.

Keep the final change set small and reviewable. Report what changed, which checks were actually run, their results, and any remaining uncertainty or risk. Never claim that a command, test, or behavior was verified when it was not.

## 10. Final Decision Rule

When multiple solutions are technically valid, prefer the one that is easiest to understand, compatible with the project's supported versions, safe to operate and rerun, explicit about errors and side effects, and least complex while fully solving the problem.

These standards guide engineering judgment; they are not a reason to over-engineer simple tasks or to stop investigating a problem that can reasonably be solved.
