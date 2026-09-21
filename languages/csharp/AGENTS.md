# C# Agent Guide

## Core
- Prefer small cohesive types and explicit dependencies.
- Keep domain logic separate from ASP.NET, EF Core, HTTP, filesystem, and queues.
- Prefer composition over inheritance.
- Use nullable reference types and make nullability explicit.

## Naming
- PascalCase for public types/methods/properties; camelCase for locals/parameters.
- Interfaces start with `I`; private fields commonly `_camelCase` when project style uses it.
- Predicates: `IsReady`, `HasAccess`, `CanRetry`.

## Data & Performance
- `List<T>` for ordered data; `Dictionary<TKey,TValue>`/HashSet for lookup.
- LINQ is ideal for readable transformations; avoid long chained LINQ in hot paths or code that hides expensive enumeration.
- Use `Span<T>`/memory APIs only where profiling shows allocation/copy pressure.
- Use async for I/O; use bounded parallelism for CPU work.
- Avoid unnecessary allocations and repeated enumeration in hot paths.

## Errors
- Throw exceptions for exceptional failures; use result types/nullable values for expected domain outcomes when appropriate.
- Never swallow exceptions.
- Preserve causes and add context at system boundaries.

## Testing
- Prefer fast unit tests around domain logic.
- Mock/fake HTTP, DB, clock, and external services at boundaries.
- Use integration tests for EF Core/database and framework wiring.
- Keep async tests deterministic; never depend on arbitrary delays.

## Avoid
Service-locator patterns, giant controllers, excessive interfaces, unnecessary `ValueTask`, speculative performance tuning.
