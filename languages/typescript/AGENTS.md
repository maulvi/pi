# TypeScript Agent Guide

## Core
- Prefer strict TypeScript. Model invalid states out of the type system when practical.
- Keep domain logic framework-agnostic; isolate HTTP, DB, filesystem, SDKs, and process access.
- Prefer small pure functions and explicit inputs/outputs.
- Use `unknown` at untrusted boundaries; validate before narrowing. Avoid `any`.

## Naming
- Variables/functions: camelCase; types/interfaces/classes: PascalCase; constants: UPPER_SNAKE_CASE only for true constants.
- Functions use verbs; booleans read as predicates: `isReady`, `hasAccess`, `canRetry`.
- Name by domain meaning, not implementation: `retryCount`, not `tmp2`.

## Data & Performance
- Use `Map`/ `Set` for keyed lookup/membership; arrays for ordered sequences.
- Prefer one-pass transforms and avoid repeated `find`/filter chains in hot paths.
- For independent I/O, prefer `Promise.all`; limit concurrency when the remote system has capacity limits.
- CPU-heavy work should leave the event loop: worker threads, child processes, or a dedicated service.
- Avoid unnecessary object/array copies and JSON serialization in hot paths; measure before optimizing.
- Do not use micro-optimizations that make normal code harder to read.

## Errors
- Throw errors for exceptional failures; return typed results for expected domain outcomes when that is the project convention.
- Add context when crossing a boundary. Do not swallow errors.

## Testing
- Test pure logic directly with table-driven cases.
- Mock/fake external boundaries, not internal functions.
- Test async code deterministically; avoid real sleeps and network calls.
- Test edge cases and public behavior, not private implementation details.

## Prefer
`const`, discriminated unions, small modules, exhaustive switches, explicit return types on public APIs, async/await.

## Avoid
`any`, hidden globals, giant service classes, deep inheritance, callback pyramids, premature abstractions.
