# Kotlin Agent Guide

## Core
- Prefer immutable data and small cohesive functions/classes.
- Keep domain logic separate from Android/Spring/Ktor, DB, HTTP, and filesystem boundaries.
- Use sealed types to model closed outcomes when useful.
- Prefer composition over inheritance.

## Naming
- camelCase for variables/functions; PascalCase for classes/interfaces/objects; UPPER_SNAKE_CASE for constants.
- Predicates: `isReady`, `hasAccess`, `canRetry`.
- Prefer domain names over generic `data`, `tmp`, `manager`.

## Data & Performance
- Use `List`/Map/Set based on semantics, not habit.
- Prefer normal collections for small/medium data; sequences are useful for genuinely large/lazy pipelines but can add overhead for small inputs.
- Coroutines are for structured concurrency and I/O; use bounded CPU dispatchers for CPU-heavy work.
- Avoid needless allocations, boxing, and repeated collection passes in hot paths.
- Measure before introducing complex performance optimizations.

## Errors
- Use nullable types for absence and sealed/result types when expected outcomes matter.
- Exceptions are for exceptional failures; preserve context when translating them.
- Avoid `!!` except where the invariant is truly proven.

## Testing
- Unit-test pure/domain logic without starting the full application.
- Use fakes at boundaries.
- Test coroutine code deterministically with test dispatchers/tools.
- Use integration tests for DB, HTTP, and framework wiring.

## Avoid
Global mutable state, giant manager classes, unnecessary `!!`, excessive scope-function nesting, abstraction without a concrete need.
