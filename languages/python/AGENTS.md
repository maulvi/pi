# Python Agent Guide

## Core
- Prefer simple modules and functions over deep class hierarchies.
- Keep business logic separate from I/O, framework code, DB, and HTTP clients.
- Use type hints for public functions and non-obvious data structures.
- Validate data at boundaries; keep internal invariants strong.

## Naming
- snake_case for variables/functions/modules; PascalCase for classes; UPPER_SNAKE_CASE for constants.
- Functions are verbs; booleans read as predicates: `is_ready`, `has_access`.
- Avoid meaningless names like `data`, `obj`, `temp` when a domain name exists.

## Data & Performance
- Use `list` for ordered data, `dict` for keyed lookup, `set` for membership.
- Use generators for large streaming inputs when materializing the whole sequence is unnecessary.
- Avoid repeated linear scans in hot paths; build an index/set when lookup is frequent.
- Asyncio is for I/O concurrency, not CPU speedups.
- Use processes for CPU-bound parallel work; threads are useful for blocking I/O.
- Prefer built-ins and standard-library operations; use native/vectorized libraries for truly data-heavy workloads.
- Profile before optimizing.

## Errors
- Catch exceptions only when you can handle, translate, or add useful context.
- Do not use broad `except Exception` as control flow.
- Preserve the original cause with `raise ... from exc` when wrapping errors.

## Testing
- Prefer pytest-style small, isolated tests.
- Unit-test pure functions heavily; fake external boundaries.
- Avoid real network, time, randomness, and filesystem dependencies in unit tests.
- Parametrize related cases instead of duplicating test functions.

## Avoid
Global mutable state, magical metaprogramming, giant utility modules, premature async, unnecessary abstractions.
