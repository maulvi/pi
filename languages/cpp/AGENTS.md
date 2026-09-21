# C++ Agent Guide

## Core
- Prefer RAII, value semantics, and clear ownership.
- Keep business logic separate from OS, networking, DB, and UI code.
- Prefer standard library types before custom containers.
- Make ownership explicit; raw owning pointers are not acceptable.

## Naming
- Follow the project's established style first. If none exists: snake_case for functions/variables, PascalCase for types.
- Predicates read as `is_*`, `has_*`, `can_*`.
- Names should describe domain intent, not memory/layout details.

## Data & Performance
- Prefer `std::vector` for contiguous data, `std::string_view`/span for non-owning views, and `std::unordered_map`/set for lookup.
- Reserve capacity when growth is predictable in a hot path.
- Prefer moves/references over unnecessary copies, but do not contort APIs merely to avoid a cheap copy.
- Use algorithmic improvements before low-level tuning.
- Use threads/tasks for CPU parallelism and async/event-driven APIs for I/O where appropriate.
- Benchmark with optimizations enabled.

## Errors
- Use exceptions or status/result types according to the project's established convention; never mix styles randomly.
- RAII must leave resources valid on failure.
- Never use exceptions as normal loop/control flow.

## Testing
- Unit-test pure logic and small components.
- Use fakes/test doubles at external boundaries.
- Run sanitizers/static analysis for memory/concurrency-sensitive code when available.
- Add regression tests for every fixed memory/logic bug.

## Avoid
Owning raw pointers, macros for ordinary logic, global mutable state, premature template metaprogramming, unsafe lifetime tricks.
