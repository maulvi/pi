# Go Agent Guide

## Core
- Prefer small packages with clear ownership of responsibility.
- Keep business logic independent from transport, DB, and external clients.
- Accept interfaces where the consumer needs substitutability; return concrete types when practical.
- Keep constructors simple. Do not build dependency-injection frameworks.

## Naming
- MixedCaps; exported names are PascalCase, unexported names camelCase.
- Short idiomatic names are fine for tiny scopes: `i`, `n`, `ctx`; use descriptive names for business logic.
- Interfaces should describe behavior, often with a `-er` suffix: `Reader`, `Store`.

## Data & Performance
- Slices for sequences; maps for lookup.
- Preallocate slices/maps when expected size is known and meaningful.
- Avoid allocations and interface conversions in measured hot paths.
- Goroutines are cheap but not free; bound concurrency and always define how they stop.
- Channels are for coordination/streaming; do not force channels where a mutex or simple function call is clearer.
- For network services, use context cancellation and timeouts.
- Profile with pprof before optimizing.

## Errors
- Return errors explicitly.
- Wrap with context using `%w`; callers should be able to inspect the cause.
- Avoid panic for normal error handling.

## Testing
- Table-driven tests for related cases.
- Use interfaces/fakes at external boundaries.
- Prefer fast unit tests; use integration tests only where they add real confidence.
- Use the race detector for concurrent code.

## Avoid
Over-abstraction, premature goroutines, unbounded worker creation, ignored errors, package-level mutable state.
