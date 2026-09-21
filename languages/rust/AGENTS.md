# Rust Agent Guide

## Core
- Prefer ownership and borrowing over cloning.
- Keep domain logic separate from I/O, networking, persistence, and framework glue.
- Use enums and types to make invalid states hard to represent.
- Prefer composition and small modules over trait-heavy designs.

## Naming
- snake_case for variables/functions/modules; PascalCase for types/traits/enums; UPPER_SNAKE_CASE for constants.
- Predicates: `is_*`, `has_*`, `can_*`.
- Use domain names; avoid generic `data`, `thing`, `ctx2`.

## Data & Performance
- `Vec` for contiguous ordered data; slices for borrowed views; `HashMap`/HashSet for lookup.
- Prefer borrowing and iterating over references; clone only when ownership requires it.
- `String`/collections are usually fine; optimize allocation count only after measurement.
- Async runtimes are for I/O concurrency; use Rayon or scoped threads for CPU-bound parallel work.
- Preallocate with `with_capacity` when size is known and this is a real hot path.
- Benchmark release builds, not debug builds.

## Errors
- Use `Result` for recoverable failures and `Option` for absence.
- Add context at boundaries; avoid `unwrap()`/panic in production paths unless the invariant is truly impossible to violate.

## Testing
- Unit-test pure logic close to the module.
- Integration-test public behavior and system boundaries.
- Prefer deterministic tests; no real network unless explicitly an integration test.
- Use property tests when invariants have many input combinations.

## Avoid
Unnecessary clones, shared mutable state, premature unsafe code, giant traits, abstraction for abstraction's sake.
