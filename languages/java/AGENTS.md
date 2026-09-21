# Java Agent Guide

## Core
- Prefer small cohesive classes and explicit dependencies.
- Keep domain logic separate from I/O, frameworks, persistence, and messaging.
- Prefer composition over inheritance.
- Use records for simple immutable data carriers when the target Java version supports them.

## Naming
- camelCase for variables/methods; PascalCase for types; UPPER_SNAKE_CASE for constants.
- Methods use verbs; predicates use `is*`, `has*`, `can*`.
- Name collections by content: `users`, `userById`.

## Data & Performance
- `ArrayList` for general ordered collections; `HashMap`/HashSet for keyed lookup/membership.
- Prefer primitive types in measured hot paths to avoid boxing.
- Avoid unnecessary temporary collections and serialization.
- Streams are good for readable transformations; a loop is often simpler for stateful logic or hot code.
- Use virtual threads for high-concurrency blocking I/O when appropriate; use bounded pools/parallelism for CPU work.
- Measure with profiling/benchmark tooling before optimizing.

## Errors
- Use exceptions for exceptional failures, not routine branching.
- Preserve root causes and add context at service boundaries.
- Do not catch and ignore exceptions.

## Testing
- Unit-test domain logic without Spring/app containers when possible.
- Mock/fake external boundaries, not every method call.
- Keep tests deterministic and isolated.
- Integration tests should cover persistence, HTTP, messaging, and wiring that unit tests intentionally exclude.

## Avoid
Giant service classes, deep inheritance trees, static global state, excessive mocking, premature framework abstractions.
