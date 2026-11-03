# Coding Style and Engineering Standards

These standards apply to every source file, script, configuration file, and documentation change in this repository. They are mandatory for both human contributors and coding agents.

The goal is code that is easy to understand, reuse, debug, and extend—not abstraction for its own sake.

## 1. Follow Existing Project Conventions

- Inspect the surrounding code before making a change.
- Prefer an established project pattern over introducing a new one.
- Keep formatting, naming, error handling, and file organization consistent within each language.
- Do not introduce a new dependency, framework, abstraction, or convention unless it solves a real problem.
- When existing code conflicts with these standards, follow the local convention for a narrowly scoped change; improve broader inconsistencies only when explicitly requested.

## 2. Compatibility, Versions, and Deprecation

- Identify the project's actual target versions before using language features, standard-library APIs, runtime APIs, package APIs, or external commands.
- Treat version declarations in manifests, lockfiles, runtime configuration, CI workflows, container images, and documented support policy as the source of truth. Do not assume the newest installed version is the project's minimum supported version.
- Use only syntax and APIs supported by the project's declared minimum target version.
- Do not introduce deprecated, obsolete, removed, or end-of-life language features, standard-library functions, runtime APIs, package APIs, command-line flags, or dependencies in new code.
- Prefer the current, documented replacement recommended by the official language, runtime, framework, or package documentation.
- Check official documentation and release notes for the exact target version when compatibility or deprecation status is uncertain. Do not rely on old tutorials, search snippets, or examples written for a different major version.
- Treat compiler, interpreter, linter, type-checker, and language-server deprecation warnings as issues to resolve—not noise to suppress.
- Do not silence deprecation warnings or use compatibility shims merely to avoid updating code. A suppression or shim is acceptable only when required for a documented compatibility boundary, and the reason and removal condition must be documented.
- Do not raise the minimum runtime or dependency version just to use a newer API unless the task explicitly allows the compatibility change. If a newer version is genuinely required, explain the impact and update the relevant version declarations and documentation together.
- When maintaining legacy code, avoid expanding use of deprecated APIs. Replace them when touching the relevant code if the change is safe and within scope; otherwise document the limitation and avoid unrelated migrations.
- Before adopting a dependency or external tool, check whether it is maintained, supported by the target runtime, and free of known deprecation or end-of-life notices relevant to the intended use.
- Do not assume an API is deprecated solely because it looks old. Verify its status from authoritative documentation for the target version.

## 3. Reusability and Functions

- Extract repeated logic into a focused reusable function or helper when doing so reduces duplication and clarifies intent.
- Reuse existing functions, variables, constants, and configuration values. Do not redefine the same behavior or value in multiple places.
- Give each function one clear responsibility. Separate decision-making/business logic from filesystem, network, process, and other I/O operations where practical.
- Keep functions short enough to understand at a glance. Split a function when it has multiple independent responsibilities or deeply nested control flow.
- Make inputs and outputs explicit. Avoid hidden dependencies on mutable global state.
- Prefer passing values as parameters and returning results over relying on globals or modifying caller state implicitly.
- Avoid premature abstraction: do not create a generic framework for a one-off operation without a credible reuse case.
- Do not create wrapper functions that only rename or forward a call unless they provide a meaningful interface, validation, or policy boundary.

## 4. Naming

Names must communicate purpose and meaning. Avoid vague names such as `data`, `value`, `item`, `tmp`, `do_work`, or unexplained abbreviations when a more specific name is practical.

Use the naming convention native to each language and remain consistent:

| Element | Preferred convention |
|---|---|
| Bash functions | `snake_case` |
| Bash variables | `UPPER_SNAKE_CASE` for constants/configuration; `lower_snake_case` for local variables |
| Python functions and variables | `snake_case` |
| Python classes | `PascalCase` |
| JavaScript / TypeScript functions and variables | `camelCase` |
| JavaScript / TypeScript classes and types | `PascalCase` |
| PHP classes and types | `PascalCase`; methods and variables follow the surrounding PSR/project convention |
| Rust functions and variables | `snake_case`; types and traits use `PascalCase`; constants use `SCREAMING_SNAKE_CASE` |
| Go exported identifiers | `PascalCase`; unexported identifiers use `camelCase` |

Additional rules:

- Use verbs for functions that perform actions (for example, `install_dependencies`, `validate_config`).
- Use nouns for values and objects (for example, `package_list`, `ssh_config`).
- Boolean names should read as a question or state, such as `is_enabled`, `has_error`, or `should_restart`.
- Name constants for what they represent, not their current value.
- Avoid abbreviations unless they are widely understood in the project or ecosystem.

## 5. Comments and Documentation

Comments should explain intent, constraints, decisions, and non-obvious behavior—not translate each line of code into English.

- Document every public or reusable function, class, module, and non-trivial interface when its purpose or contract is not obvious.
- For functions, describe purpose, meaningful parameters, return values, side effects, failure behavior, and important preconditions as applicable.
- For classes and types, explain their responsibility and any important invariants or lifecycle expectations.
- Add comments around non-obvious commands, compatibility workarounds, security-sensitive behavior, tricky conditionals, and decisions that future maintainers might otherwise undo.
- Explain *why* a behavior exists when the reason is not apparent from the code.
- Keep comments accurate when code changes. Remove obsolete or misleading comments.
- Do not add noisy comments to obvious assignments, simple expressions, or self-explanatory code.
- Prefer documentation at the declaration or relevant code block rather than a large unrelated explanation elsewhere.
- Use the language's standard documentation format where available (for example, shell function comments, Python docstrings, PHPDoc, JSDoc, and Rust doc comments).

## 6. Readability and Structure

- Prefer explicit, straightforward code over clever, compressed, or overly terse expressions.
- Use guard clauses and early returns to reduce unnecessary nesting.
- Avoid deeply nested conditionals; extract a named helper when it makes the decision easier to understand.
- Keep related logic together and separate unrelated concerns into focused files or modules.
- Avoid giant files and giant functions. Split them when doing so improves navigation or responsibility boundaries.
- Use whitespace and formatting to make logical sections clear.
- Avoid magic numbers and unexplained literal strings. Promote meaningful values to named constants or configuration when appropriate.
- Avoid unnecessary mutable state, duplicate condition checks, and dead code.
- Do not add comments as a substitute for clear naming or structure.

## 7. Configuration and State

- Keep each setting or default defined in one authoritative place whenever practical.
- Reuse existing configuration rather than duplicating values across scripts.
- Distinguish user-configurable values, environment variables, internal defaults, and derived values.
- Validate external input and configuration at the boundary where it enters the program.
- Quote variables correctly in shell scripts and handle paths and strings containing whitespace safely.
- Never hard-code secrets, credentials, private keys, access tokens, or machine-specific personal paths.
- Preserve existing user configuration unless the task explicitly requires changing it.

## 8. Errors, Safety, and Side Effects

- Handle errors deliberately. Do not silently ignore failures unless the failure is explicitly optional and the reason is documented.
- Return meaningful exit codes and actionable error messages.
- Include enough context in errors to identify the failed operation without exposing secrets.
- Validate inputs before performing destructive or privileged operations.
- Make scripts safe to rerun where the task is an installer or system configuration workflow: check current state and avoid duplicate entries or unnecessary changes.
- Prefer atomic writes and safe temporary-file handling for configuration updates.
- Avoid broad permissions, unsafe deletion patterns, and unnecessary root execution.
- Keep privileged operations narrowly scoped.
- Make network downloads fail visibly and verify integrity when a trustworthy checksum or signature is available.
- Do not hide errors with broad `|| true`, empty catch blocks, or equivalent constructs unless there is a documented and justified fallback.

## 9. Language-Specific Guidance

### Bash

- Use `#!/usr/bin/env bash` for Bash scripts and `set -Eeuo pipefail` when compatible with the script's error-handling design.
- Quote variable expansions by default: `"${variable}"`.
- Use `[[ ... ]]` for conditionals and arrays for lists of arguments or paths.
- Use `$(...)` for command substitution; avoid legacy backticks.
- Use `local` for function-scoped variables.
- Use uppercase names for environment/configuration constants and lowercase names for local temporaries.
- Send diagnostics to standard error and reserve standard output for useful command output when practical.
- Use functions for repeated operations and meaningful logical steps; avoid turning every trivial command into a helper.
- Do not parse `ls` output or rely on word-splitting for filenames.
- Check command availability before relying on optional external tools.
- Make cleanup and traps explicit when temporary resources or background processes are created.

### Python

- Follow PEP 8 and use type hints for non-trivial reusable interfaces.
- Use docstrings for public modules, classes, and functions.
- Prefer standard-library functionality unless an additional dependency is justified.

### JavaScript and TypeScript

- Follow the repository's formatter and lint configuration when present.
- Prefer `const`; use `let` only when reassignment is needed.
- Prefer explicit types for exported TypeScript interfaces and public APIs.
- Handle rejected promises and asynchronous errors deliberately.
- Avoid `any` unless there is a documented interoperability reason.

### PHP

- Follow PSR-12 and the repository's Composer configuration where present.
- Use namespaces and types for reusable components.
- Document public APIs with PHPDoc when the contract is not self-evident.

### Rust

- Follow `rustfmt` and Clippy guidance.
- Use the type system and `Result` for explicit error handling.
- Document public APIs and explain non-obvious safety requirements.

### Go

- Follow `gofmt` and standard Go naming conventions.
- Return and handle errors explicitly.
- Keep packages focused and document exported identifiers.

## 10. Changes and Review

Before considering a change complete:

1. Confirm the implementation follows the surrounding project structure and these standards.
2. Check that existing helpers and configuration are reused rather than duplicated.
3. Ensure names and comments explain the intent and contract.
4. Confirm new APIs and syntax are supported by the declared target versions and do not introduce avoidable deprecations.
5. Remove dead code, temporary debugging output, and unrelated changes.
6. Run the narrowest relevant formatter, linter, syntax check, or test when available.
7. Report checks that were actually run; never claim unperformed verification.

## 11. Practical Decision Rule

When choosing between two valid implementations, prefer the one that:

1. Is easier to read and understand.
2. Reuses existing project functionality without adding unnecessary coupling.
3. Has fewer hidden side effects and clearer inputs/outputs.
4. Is compatible with the project's declared minimum supported versions.
5. Is easier to test and maintain.
6. Introduces the least complexity needed to solve the task.

These standards are a quality baseline, not a reason to over-engineer simple code.
