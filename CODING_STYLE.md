# Coding Style and Engineering Standards

These standards apply to every source file, script, configuration file, and documentation change in this repository. They guide both human contributors and coding agents.

The goal is code that is understandable, safe, reusable where useful, compatible with supported versions, and straightforward to maintain. These rules are a repository baseline; they do not replace the official documentation or idioms of each language and tool.

## 1. Requirement Levels

The words below indicate the strength of a rule:

- **MUST / MUST NOT**: required unless a documented technical constraint makes compliance impossible.
- **SHOULD / SHOULD NOT**: the default approach; deviate only for a clear, documented reason.
- **MAY**: optional guidance to use when it provides value.

Do not turn a recommendation into a rigid rule when the language, project, or runtime requires a different approach. When rules conflict, use this priority:

1. Higher-priority instructions and explicit task requirements.
2. The project's declared compatibility and security requirements.
3. Existing local conventions and configuration.
4. This repository-wide guidance.
5. General stylistic preference.

## 2. Follow Existing Project Conventions

- Inspect the relevant surrounding code and configuration before changing them.
- Prefer established project patterns over introducing new ones.
- Follow formatter, linter, type-checker, and tool configuration already present in the repository.
- Do not introduce a dependency, framework, abstraction, or convention unless it solves a concrete problem.
- Keep changes scoped. Do not reformat or refactor unrelated code unless requested or necessary for correctness.
- When existing code conflicts with this guide, preserve local conventions for a narrow change. Improve broader inconsistencies only when they are in scope.
- Do not claim a check passed unless it was actually run; report unavailable checks honestly.

## 3. Compatibility, Versions, and Deprecation

- Identify the supported target versions before using language syntax, standard-library APIs, runtime APIs, package APIs, external commands, or configuration options.
- Treat manifests, lockfiles, runtime declarations, CI workflows, container images, and explicit support documentation as evidence of the supported versions. Do not assume the newest installed version is the minimum supported version.
- Use only features supported by the project's declared minimum versions.
- Do not introduce deprecated, obsolete, removed, unsupported, or end-of-life features, APIs, flags, or dependencies into new code.
- Prefer the replacement recommended by the official language, runtime, framework, or package documentation.
- When status or compatibility is uncertain, check the official documentation and release notes for the relevant version. Do not rely solely on old tutorials, search snippets, or examples for another major version.
- Treat relevant compiler, interpreter, linter, type-checker, and language-server deprecation diagnostics as issues to investigate and resolve. A warning may be tool-version-specific, so verify it against the project's target version before changing code.
- Do not suppress diagnostics simply to make checks quiet. A narrow suppression or compatibility shim MAY be used when a documented compatibility boundary requires it; explain why it is needed and, where possible, when it can be removed.
- Do not raise the minimum runtime or dependency version merely to use a newer API unless the task permits that compatibility change. If the change is necessary, update version declarations and user-facing documentation together.
- When maintaining legacy code, avoid expanding deprecated usage. Replace it when safe and in scope; otherwise document the constraint and avoid unrelated migrations.
- Before adopting a dependency or external tool, consider whether it is maintained, supported by the target runtime, and free of relevant end-of-life or deprecation notices.
- Do not label an API deprecated merely because it appears old. Confirm its status in authoritative documentation for the applicable version.

## 4. Reusability and Functions

- Reuse existing functions, helpers, constants, and configuration values rather than duplicating behavior.
- Extract repeated logic into a focused helper when doing so reduces duplication or clarifies intent.
- Give each function or method a clear responsibility. Separate decision-making from filesystem, network, process, and other I/O operations when that separation improves clarity or testability.
- Keep inputs, outputs, and side effects explicit. Prefer parameters and return values over hidden mutable global state.
- Keep functions reasonably small, but do not split straightforward code into trivial helpers without a meaningful benefit.
- Avoid premature abstraction, generic frameworks for one-off tasks, and wrapper functions that only rename or forward calls.
- Do not optimize based on guesswork. Prefer clear algorithms and measure before performance-specific changes.

## 5. Naming

Names MUST communicate purpose. Avoid vague names and unexplained abbreviations when a more precise name is practical.

Follow the language's established conventions and the conventions already used in the relevant part of the repository. The following are defaults, not universal language requirements:

| Element | Preferred default |
|---|---|
| Bash functions | `snake_case` |
| Bash variables | `UPPER_SNAKE_CASE` for constants/configuration; `lower_snake_case` for local variables |
| Python functions and variables | `snake_case` |
| Python classes | `PascalCase` |
| JavaScript / TypeScript functions and variables | `camelCase` |
| JavaScript / TypeScript classes and types | `PascalCase` |
| PHP | Follow the project's PSR and framework conventions |
| Rust functions and variables | `snake_case`; types and traits `PascalCase`; constants `SCREAMING_SNAKE_CASE` |
| Go | Follow the official Go naming conventions; exported identifiers use initial capitals |

Additional guidance:

- Use verbs for actions (for example, `validate_config`) and nouns for values (for example, `ssh_config`).
- Boolean names SHOULD communicate a state or condition, such as `is_enabled`, `has_error`, or `should_restart`.
- Name constants for what they represent, not merely their current value.
- Prefer established ecosystem terminology over locally invented abbreviations.

## 6. Comments and Documentation

Comments explain intent, constraints, contracts, and non-obvious behavior; they should not narrate every line.

- Document public or reusable functions, classes, modules, and interfaces when their purpose or contract is not self-evident.
- For non-trivial functions, describe relevant parameters, return values, side effects, failure behavior, and preconditions.
- Document important invariants, lifecycle expectations, security-sensitive behavior, compatibility workarounds, and surprising decisions.
- Explain why a behavior exists when future maintainers might otherwise remove or change it incorrectly.
- Keep comments accurate as code changes; remove obsolete or misleading comments.
- Avoid noisy comments for obvious assignments and simple expressions.
- Use the language's conventional documentation format where appropriate (for example, Python docstrings, PHPDoc, JSDoc, Rust doc comments, and Go doc comments).

## 7. Readability and Structure

- Prefer explicit, idiomatic code over clever, compressed, or unnecessarily terse expressions.
- Use guard clauses and early returns when they reduce nesting and clarify the main path.
- Avoid deeply nested conditionals; extract a named helper when it makes the decision easier to understand.
- Keep related logic together and separate unrelated responsibilities into focused files or modules.
- Split large files or functions when doing so improves navigation, cohesion, or testability—not to satisfy an arbitrary size limit.
- Use whitespace and formatting to make logical sections clear.
- Avoid unexplained magic numbers, duplicated conditions, dead code, and unnecessary mutable state.
- Prefer language-native constructs and standard library features when they are clear, supported, and suitable.
- Do not use comments as a substitute for clear names or structure.

## 8. Configuration, Input, and Secrets

- Keep each setting or default in one authoritative place where practical.
- Distinguish user-configurable values, environment variables, internal defaults, and derived values.
- Validate untrusted input and external configuration at the boundary where they enter the program.
- Preserve existing user configuration unless the task explicitly requires changing it.
- Never hard-code secrets, credentials, private keys, access tokens, or machine-specific personal paths.
- Do not log secrets or include them in error messages.
- For shell scripts, quote expansions by default and handle paths and arguments containing whitespace safely.
- Treat data from the network, environment, command-line arguments, files, and external processes as untrusted until validated.

## 9. Errors, Safety, and Side Effects

- Handle errors deliberately. Do not silently ignore failures unless the failure is optional and the fallback is intentional and documented.
- Return meaningful exit codes and actionable error messages.
- Include enough context to identify a failed operation without exposing secrets.
- Validate inputs and current state before destructive or privileged operations.
- Keep privileged operations narrowly scoped and avoid unnecessary root execution.
- Make installers and system-configuration scripts safe to rerun: detect existing state, avoid duplicate entries, and avoid unnecessary changes.
- Prefer atomic writes and safe temporary-file handling for configuration updates.
- Avoid broad permissions, unsafe deletion patterns, and commands whose effects are wider than required.
- Make network downloads fail visibly. Verify signatures or checksums when trustworthy verification data is available.
- Avoid broad error suppression (such as `|| true`, empty catch blocks, or blanket lint suppressions). Use it only for an expected, understood failure path and explain that reason.
- Consider rollback or cleanup behavior when a sequence can leave the system in a partially configured state.

## 10. Bash Standards

Bash is a primary implementation language in this repository. Follow Bash semantics deliberately; do not assume that Bash scripts are automatically POSIX `sh` scripts.

### 10.1 Dialect and formatting

- Bash scripts MUST use an accurate Bash shebang, normally `#!/usr/bin/env bash`.
- Do not use Bash-only syntax in a script declared or executed as POSIX `sh`.
- Use the repository's formatter configuration when present. For Bash, use `shfmt` when it is installed or configured for the project; do not invent formatting flags that conflict with existing files.
- Run ShellCheck with the correct shell dialect. ShellCheck supports selected shell dialects; it is not a general checker for every shell (for example, it does not analyze Zsh as Zsh).
- Keep heredoc delimiters correct and take care when indenting heredocs. Use `<<-` only when tab-stripping semantics are intended; it strips tabs, not spaces.

### 10.2 Variables, arguments, and commands

- Quote variable expansions by default: `"${variable}"`. Use unquoted expansion or globbing only when word splitting or pathname expansion is intentional.
- Use arrays for lists of arguments. Do not build a command as a string and then rely on word splitting to execute it.
- Use `"$@"` to forward positional arguments without losing argument boundaries.
- Use `[[ ... ]]` for Bash conditionals and `$(...)` for command substitution.
- Use `local` for function-scoped variables.
- Do not parse `ls` output or use fragile whitespace-delimited parsing for filenames.
- Check for optional commands before relying on them; distinguish a missing optional tool from a required dependency.
- Avoid `eval`. If it is genuinely required to initialize a trusted tool's generated shell environment, explain the source and trust boundary. Never pass untrusted input to `eval`.
- Source only files whose origin and contents are trusted. Do not treat downloaded or user-controlled text as executable shell code.

### 10.3 Exit status and error handling

- `set -e`, `set -u`, and `set -o pipefail` MAY be used when their behavior is understood and compatible with the script's control flow. They are not substitutes for explicit checks.
- In particular, do not assume `set -e` catches every failure: its behavior depends on context, including conditionals, lists, functions, and command substitutions.
- Handle expected non-zero statuses explicitly (for example, a search with no matches) rather than allowing strict-mode behavior to obscure the intended outcome.
- Check important command results and validate outputs before using them.
- Use traps for cleanup when temporary resources or background processes are created. Keep trap behavior predictable and avoid unintentionally replacing existing traps.
- Send diagnostics to standard error and reserve standard output for useful command output when practical.

### 10.4 Privilege, downloads, and filesystem changes

- Prefer invoking only the individual privileged command through `sudo` instead of running an entire installer as root when user-level work is also required.
- Do not assume `$HOME`, `$PATH`, or the invoking user is unchanged after privilege transitions; resolve and validate user context deliberately.
- Use `mktemp` for temporary files and clean them up on success and failure.
- Avoid downloading a script and immediately executing it as root unless the upstream installation method requires it and the source is trusted. Prefer verified releases or package-manager installation when available.
- Write configuration changes atomically where practical, preserve existing content, and make repeated execution safe.
- Use arrays when constructing commands with optional flags or paths; do not use `eval` to assemble command lines.

### 10.5 Bash validation tools

Use these checks when available and relevant:

- `bash -n` for Bash syntax validation.
- `shellcheck` for static analysis, with the script's actual shell dialect.
- `shfmt` for consistent formatting when the repository adopts it.

Do not blindly suppress ShellCheck diagnostics. If a suppression is necessary, make it narrow and explain why. A clean ShellCheck run does not prove that a script is correct, secure, portable, or safe to execute.

## 11. Language-Specific Guidance

These are concise repository defaults, not complete replacements for each language's official style guide. Existing project configuration takes precedence where appropriate.

### Python

- Follow PEP 8 and the project's configured formatter and linter.
- Use type hints for non-trivial reusable interfaces and public APIs.
- Use docstrings for public modules, classes, and functions when their contract is not obvious.
- Prefer standard-library functionality unless an additional dependency is justified.
- Use the project's configured type checker; do not assume type hints alone guarantee runtime validation.

### JavaScript and TypeScript

- Follow the repository's formatter, linter, TypeScript configuration, and package-manager conventions.
- Prefer `const`; use `let` when reassignment is needed.
- Give exported TypeScript APIs explicit, useful types. Avoid `any` unless interoperability requires it and the boundary is documented.
- Handle rejected promises and asynchronous errors deliberately.
- Respect the project's module system and supported runtime/browser versions.

### PHP

- Follow the PHP version declared by the project and the project's Composer configuration.
- Use PSR-12 as a baseline when no framework-specific convention overrides it.
- Use namespaces and type declarations for reusable components where compatible with the supported PHP version.
- Use PHPDoc when it adds information not expressed by native types or when required by the project's tooling.
- Follow framework and package conventions instead of imposing a conflicting generic pattern.

### Rust

- Follow `rustfmt`, compiler diagnostics, and relevant Clippy guidance.
- Use `Result` and appropriate error types for recoverable failures; avoid panics for ordinary error handling in reusable code.
- Document public APIs and explain non-obvious safety requirements, especially around `unsafe`.
- Respect the edition and minimum Rust version declared by the project.

### Go

- Follow `gofmt`, the official Go Code Review Comments, and standard Go naming conventions.
- Return and handle errors explicitly; add context when it helps diagnose failures.
- Keep packages focused and document exported identifiers.
- Use project-supported Go versions and relevant standard tooling such as `go vet` where appropriate.

### Other languages

When adding another language, identify its official style guide, supported version, formatter, linter, and type-checking or static-analysis tools before defining repository-specific rules. Do not extrapolate conventions from another language.

## 12. Tooling and Automated Enforcement

- Prefer tools already configured by the project; avoid adding overlapping tools without a clear benefit.
- Configure tools to match the project's actual supported language/runtime versions and shell dialects.
- Use formatters for mechanical formatting and linters/static analyzers for detectable correctness and quality issues.
- Use type checkers and tests for properties that formatting and linting cannot establish.
- Run focused checks for changed files first. Run broader checks when the change affects shared behavior or when CI requires them.
- CI SHOULD run the repository's agreed automated checks so that standards are applied consistently. Do not claim a rule is enforced automatically unless a tool or CI job actually enforces it.
- A passing formatter, linter, static analyzer, or test suite is evidence, not proof, of correctness or security. Human review remains necessary.

## 13. Changes and Review

Before considering a change complete:

1. Confirm the implementation follows relevant local conventions and this guide.
2. Reuse existing helpers and configuration rather than duplicating behavior.
3. Check names, interfaces, comments, and side effects for clarity.
4. Confirm syntax and APIs are supported by declared target versions.
5. Check for avoidable deprecated APIs, unsupported commands, and obsolete dependencies.
6. Review privileged operations, external input, downloads, secrets, and destructive side effects.
7. Remove dead code, temporary debugging output, and unrelated changes.
8. Run the narrowest relevant formatter, linter, syntax check, type checker, or test available.
9. Report exactly which checks were run and any remaining uncertainty.

## 14. Practical Decision Rule

When multiple implementations are correct, prefer the one that:

1. Is easiest to read and understand.
2. Uses existing project functionality without unnecessary coupling.
3. Has explicit inputs, outputs, errors, and side effects.
4. Is compatible with the project's declared minimum supported versions.
5. Is safe to rerun and straightforward to test where applicable.
6. Adds the least complexity needed to solve the actual problem.

These standards are a quality baseline, not a reason to over-engineer simple code.
