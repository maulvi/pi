# Global Agent Rules

These rules apply to every coding task. Higher-priority instructions override them.

## 1. Understand First
- Inspect relevant code, config, docs, and package files before changing anything.
- Treat existing code and project conventions as the source of truth.
- Verify uncertain facts; do not guess.

## 2. Keep It Simple
- Make the smallest change that fully solves the task.
- Prefer clear, boring solutions over clever abstractions.
- Do not refactor unrelated code.
- Reuse existing dependencies and tools; add new ones only when justified.
- Follow the project's existing package manager and conventions.

## 3. Design for Low Tech Debt
- Keep functions, modules, and interfaces small and focused.
- Separate business logic from I/O, frameworks, and external services.
- Prefer deterministic code with explicit dependencies over hidden global state.
- Optimize for readability, testability, and changeability before micro-optimizing.
- When touching an area, fix small obvious debt when it reduces future complexity; avoid unrelated rewrites.

## 4. Testing
- Add or update tests with meaningful behavior changes.
- Test behavior, contracts, edge cases, and regressions—not implementation trivia.
- Keep unit tests fast, isolated, deterministic, and free from real network/external services.
- Mock or fake at system boundaries, not deep inside business logic.
- Run the narrowest useful checks first, then broader checks when practical.

## 5. Protect Existing Work
- Check `git status` and relevant diffs before editing.
- Never overwrite, reset, or discard user changes.
- Never force-push.
- Preserve compatibility unless a breaking change is required.

## 6. Performance
- Choose data structures and concurrency models for the workload.
- Prefer algorithmic improvements over micro-optimizations.
- Measure hot paths before optimizing them.
- Do not trade clarity for speed without evidence.

## 7. Safety
- Never expose, commit, or log secrets, tokens, keys, or credentials.
- Treat production changes, migrations, deletions, permission changes, and data operations as destructive.
- Do not perform destructive actions unless explicitly requested or clearly required.

## 8. Language Playbooks
When working in a language, read the matching guide in `languages/<language>/AGENTS.md` when it exists. It contains language-specific design, naming, performance, and testing rules.

## 9. Meta Ads Made Easy — Product Rules
This project is a simplified control plane for Meta advertising, not a clone of Meta Ads Manager.

### Product principle
- Use the "Amati, Tiru, Modifikasi" approach: study proven advertising products, reproduce the useful interaction patterns, then simplify and adapt them to this product.
- Do not copy proprietary branding, text, assets, or implementation. Recreate the underlying UX/product ideas independently.
- Optimize for fast decision-making: users should understand account health, spend, performance, and required actions without navigating a maze of Meta concepts.

### Reference patterns to preserve
- **Madgicx:** unified campaign/ad-set/ad management, configurable KPI tables, performance filtering, bulk actions, automation, actionable analytics, cross-account reporting, and AI-assisted workflows. Use these as patterns for reducing Ads Manager complexity rather than copying its UI. 
- **Smartly:** bulk campaign creation, multi-account workspaces, feed-driven campaign generation, creative templates/variation at scale, automated workflows, and unified reporting. Prefer workflow-oriented interfaces over repetitive entity-by-entity forms.
- **Birch/Revealbot-style automation:** model automation as explicit rules with conditions, metrics, actions, schedules, previews, and audit history. Keep automation deterministic and inspectable.
- **AdEspresso-style simplicity:** make campaign creation/testing approachable; hide low-value Meta complexity behind sensible defaults and progressive disclosure.

### Core UX
- Dashboard first: account spend, results, CPA/ROAS where available, trend, active campaigns, alerts, and actionable anomalies.
- Campaign workspace should support filtering, sorting, search, column selection, date ranges, saved views, and bulk actions.
- Campaigns, ad sets, and ads should be manageable from the same workflow where practical; avoid unnecessary page hopping.
- Use progressive disclosure: expose common controls first and advanced Meta options only when needed.
- Prefer one clear primary action per screen.
- Make destructive or money-moving actions explicit, reviewable, and reversible where Meta permits it.
- Show loading, stale-data, partial-sync, permission, and API-rate-limit states clearly.
- Never imply data is real-time unless the backend actually has fresh data.

### Domain model
- Keep Meta's hierarchy intact at the integration boundary:
  `AdAccount -> Campaign -> AdSet -> Ad -> Creative`.
- Do not leak raw Meta API shapes throughout the application.
- Create a small internal domain model and map it to/from Meta at the integration boundary.
- Keep read models optimized for dashboards/reporting separate from write commands when useful.
- Treat Meta as the source of truth for Meta-owned objects; local storage should hold app state, cached/synced data, configuration, templates, automation rules, audit logs, and sync metadata.

### BFF/API architecture
- Frontend must not call Meta APIs directly.
- Route all Meta operations through a backend/BFF/service layer.
- Keep API contracts task-oriented instead of mirroring every Meta endpoint 1:1.
- Example: prefer `POST /campaigns` with product-level input over exposing separate frontend calls for every Meta object creation step.
- Keep Meta credentials/tokens server-side only.
- Isolate the Meta adapter behind a narrow interface so business logic can be unit-tested without Meta.
- Separate commands (create/update/pause/budget changes) from queries (campaign lists/insights/reporting) where this improves clarity and caching.

### Analytics and reporting
- Make metrics configurable but provide sensible e-commerce defaults.
- Support account/campaign/ad-set/ad levels and useful breakdowns such as date, placement, device, country, age, and gender when available from Meta.
- Make date range and attribution context visible.
- Distinguish Meta-reported metrics from store/revenue metrics; never silently mix sources.
- Cross-channel/store reporting is an extension, not a reason to pollute the core Meta domain model.

### Bulk operations
- Bulk actions are a first-class feature: pause/start, budget changes, naming, tagging, and other supported operations.
- Every bulk mutation must show selected count, intended change, validation result, and execution result.
- Prefer percentage budget changes and explicit absolute values as separate operations.
- Make partial failures visible and retryable; never report a bulk operation as fully successful when some items failed.
- Record an audit entry for money-moving and state-changing actions.

### Automation
- Represent automation as data, not scattered code:
  `trigger -> conditions -> action -> guardrails -> schedule -> execution history`.
- Support dry-run/preview before enabling a rule.
- Require guardrails for budget-changing or mass state-changing rules.
- Keep rule evaluation deterministic and testable.
- Store execution history and reasons for every automated mutation.
- Never hide automated changes from the user.

### AI features
- AI may explain performance, summarize anomalies, generate copy/creative suggestions, and propose actions.
- AI should propose before executing money-moving or destructive actions unless the user has explicitly configured autonomous execution.
- All AI actions must pass through the same validated command layer as normal UI actions.
- Never let an LLM bypass permissions, validation, rate limits, or audit logging.
- Prefer structured tool calls and typed commands over free-form API generation.

### Security and Meta integration
- Use Meta's official OAuth and Marketing API flows; never scrape Ads Manager or automate browser clicks.
- Store access tokens encrypted and minimize their exposure.
- Scope permissions to the minimum required capability.
- Validate account ownership/access before mutations.
- Handle expired/revoked permissions and disconnected accounts explicitly.
- Treat Meta API errors, rate limits, transient failures, and permission failures as normal states that require structured handling.

### Testing requirements for this product
- Unit-test domain logic without network calls.
- Contract-test the Meta adapter against recorded fixtures or controlled fakes.
- Test idempotency for create/update/mutation commands.
- Test partial failures for bulk operations.
- Test permission denial, expired tokens, rate limits, stale data, pagination, and missing metrics.
- Test automation rules with boundary cases around spend, CPA, ROAS, and time windows.
- Test that every money-moving operation produces an audit event.

### Implementation order
1. Meta OAuth + account discovery.
2. Read-only account/campaign/ad-set/ad data and Insights.
3. Dashboard + filtering + configurable metrics.
4. Safe mutations: pause/start/name/budget.
5. Bulk operations + audit log.
6. Campaign creation workflow with sensible defaults.
7. Automation engine with dry-run and guardrails.
8. AI recommendations and structured actions.
9. Cross-channel/store reporting and creative workflows.

## 10. Finish Cleanly
- Keep the final change set small and reviewable.
- Report what changed, what was verified, and any remaining issue or risk.
- Never claim a command or test was run when it was not.
