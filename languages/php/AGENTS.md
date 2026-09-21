# PHP Agent Guide

## Core
- Prefer strict types and explicit domain objects over loose array-driven code for important logic.
- Keep business logic separate from Laravel/Symfony/framework, DB, HTTP, filesystem, and queue code.
- Validate external input at boundaries.
- Reuse the project's framework conventions instead of inventing a second architecture.

## Naming
- camelCase for variables/methods; PascalCase for classes/interfaces/enums; UPPER_SNAKE_CASE for constants.
- Methods use verbs; predicates read as `is*`, `has*`, `can*`.
- Name arrays by content, not type: `users`, not `userArray`.

## Data & Performance
- PHP arrays are flexible but memory-heavy hash tables; do not use them as universal data structures.
- Prefer generators when streaming genuinely large result sets.
- Avoid N+1 database queries; query shape and indexes usually matter more than PHP micro-optimizations.
- Reuse persistent connections/caches according to the framework/runtime.
- Profile before tuning; production performance is often dominated by DB, network, or serialization.

## Errors
- Use exceptions consistently with the project's framework.
- Do not return mixed sentinel values for one operation.
- Catch only when recovering, translating, or adding context.

## Testing
- PHPUnit/Pest-style tests should isolate domain logic from framework infrastructure where possible.
- Fake HTTP, queues, clocks, and external services.
- Use database tests for query behavior and persistence rules that unit tests cannot prove.
- Avoid tests that depend on execution order or real external services.

## Avoid
Fat controllers, hidden static state, business logic inside templates, N+1 queries, copy-pasted validation.
