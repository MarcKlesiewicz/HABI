# AGENTS.md

## Project Profile

- Habi is a Flutter application using Material 3, Riverpod, GoRouter, Firebase Auth, and Cloud Firestore.
- Keep work scoped to the requested feature or fix. Preserve existing user changes and avoid unrelated refactors.
- Organize growing features under `lib/features/`, shared UI under `lib/shared/`, app configuration under `lib/config/`, and Firebase integration under `lib/core/firebase/`.
- The entry point is `lib/main.dart`. Routing lives in `lib/config/routes/routes.dart`; theme configuration and design tokens live in `lib/config/theme/`.
- Use the existing context extensions from `theme_extensions.dart` and `AppConstants`; do not introduce a parallel token system.
- Use Riverpod for shared state, async state, and dependency injection. Keep purely local presentation state inside its widget.
- Use GoRouter for pages, deep links, and shell navigation. Keep shell destinations inside `ShellLayout`, and route paths in `AppRoutePath`.
- Keep Firebase and Firestore access behind services or repositories. Widgets must not own Firestore serialization.
- Parse stored data defensively and preserve serialization names. Keep existing local fallbacks where Firebase-backed repositories support running without Firebase.
- Do not change Firebase project configuration, `firebase_options.dart`, Firestore rules, indexes, or deployment settings unless explicitly requested.

The remaining guidance is the reusable Flutter baseline. When copying this file to another project, replace this profile with that project's actual stack, paths, and constraints rather than carrying Habi choices forward implicitly.

## Working Principles

- Inspect the relevant code and nearby tests before implementing. Reuse established patterns when they fit; do not create a parallel architecture for a problem the project already solves.
- Prefer the simplest implementation that satisfies the current requirement. Add abstractions only when they own a concrete responsibility, improve a real testing boundary, or support demonstrated reuse.
- Favor readable, explicit code over cleverness, speculative flexibility, or framework ceremony.
- Make the smallest coherent change. If unrelated technical debt appears, report it separately rather than expanding scope.
- Ask for clarification only when a choice would materially change behavior, platform support, stored data, or architecture. Otherwise make a reasonable, stated assumption and proceed.
- Before finishing, review the diff for accidental changes, dead code, temporary diagnostics, needless complexity, and missed edge cases.

When several approaches are reasonable, prefer them in this order:

1. Existing project convention.
2. A simple Flutter or Dart solution.
3. A small project-specific abstraction.
4. An external dependency.
5. A larger architectural abstraction.

## Flutter and Dart

- Follow Effective Dart and the repository's analyzer and lint configuration.
- Write modern, concise, null-safe Dart. Prefer strong types, immutable data, `final` locals, and `const` constructors where they improve clarity or reduce rebuild work.
- Use `PascalCase` for types, `camelCase` for members and variables, and `snake_case` for files.
- Avoid broad `dynamic`, long-lived untyped maps, and forced null assertions when the boundary can be modeled safely.
- Use records and pattern matching when they make local data flow clearer; use a named type when a value has domain meaning or travels across boundaries.
- Keep functions focused and side effects explicit. Do not perform network calls, database writes, parsing, sorting large collections, or state mutations from widget `build` methods.
- Check `mounted` before using a `State` object's `BuildContext` after an `await`.
- Dispose owned controllers, focus nodes, animation controllers, subscriptions, and similar resources.
- Use comments to explain non-obvious reasons or constraints, not to restate the code. Add dartdoc to reusable or non-obvious public APIs without documenting private one-off details.
- Prefer explicit fallbacks or visible error states over silent failure in async, parsing, routing, and integration code.

## Architecture and State

- Favor feature-oriented organization and composition over inheritance.
- Keep rendering, state coordination, domain behavior, and external data access distinct, but do not create empty layers preemptively.
- Extract widgets when doing so improves readability, reuse, testing, or rebuild boundaries—not merely to reduce line count.
- Keep domain logic testable outside widgets. Date calculations, recurrence, filtering, sorting, validation, and data mapping should live in focused Dart code.
- Design reusable APIs from the caller's perspective. Prefer explicit constructor parameters, typed results, and visible dependencies over global service lookup.

Use the state-management approach declared by the project profile consistently. Do not introduce a second app-wide state or dependency-injection system for a local problem.

For Riverpod projects:

- Use `Provider` for services and derived stateless dependencies, `NotifierProvider` for mutable synchronous feature state, `AsyncNotifierProvider` for command-oriented async state, and `FutureProvider` for primarily read-only async data.
- Let widgets render provider state and forward user actions. Let notifiers coordinate application actions and async transitions.
- Prefer provider overrides and simple fakes in tests over interfaces created only to satisfy a mocking framework.
- Avoid global providers for short-lived concerns such as focus, text editing, animation, or a selection that has no meaning outside one widget.

Start with the shortest clear dependency path, commonly `Widget -> Notifier -> Service`. Introduce a repository only when it owns meaningful behavior such as caching, offline support, synchronization, multiple data sources, domain mapping, or a project-required integration boundary. A repository that only forwards calls adds no value.

## Widgets, UI, and Accessibility

- Use the project's established theme, design tokens, and shared components. Do not introduce a second color, typography, spacing, radius, or breakpoint system.
- Prefer configured Material components and built-in adaptive layout primitives before custom controls or layout systems.
- Use `LayoutBuilder`, `MediaQuery`, responsive helpers, `Expanded`, `Flexible`, and `Wrap` deliberately. Check narrow mobile and wide layouts, larger text scales, dynamic content, and keyboard use where applicable.
- Use builder-based lists or slivers for long or dynamic collections. Avoid nested primary scrollables unless the interaction is intentional and tested.
- Keep touch targets usable, contrast accessible, focus behavior visible, and important actions clearly labeled.
- Add semantic labels to icon-only controls, custom interactions, and informative images. Do not rely on color alone to communicate state.
- Prefer real Material controls so hover, focus, pressed, disabled, and semantic behavior come from the framework.
- For network images, provide loading and error states and constrain size and fit to avoid distortion or layout shifts.

## Data, Integrations, and Routing

- Keep external systems behind a focused service or repository boundary. Normalize nullable, loosely typed, or unstable data at that boundary rather than throughout the UI.
- Represent loading, empty, error, and success states deliberately when users can observe them.
- Use `Future` for one-shot work and `Stream` for ongoing updates; expose shared async state through the project's selected state-management system.
- Treat timestamps, time zones, recurrence, enum names, and stored nullable fields defensively. Use fixed clocks in date-sensitive tests.
- Keep serialization names stable once persisted. When a stored shape changes, include compatibility handling or an explicit migration.
- Do not log secrets, credentials, tokens, or personal data. Prefer `dart:developer` or the project's logging abstraction over `print`.
- Use the routing solution declared in the project profile for pages and deep links. Use `Navigator` only for short-lived flows that do not need addressable routes, such as dialogs or temporary modal steps.

Firebase is not a baseline requirement. When a project uses it, keep Firebase access out of widgets, validate Firestore data at the boundary, and treat project configuration, rules, indexes, and generated options as protected infrastructure unless the task explicitly includes them.

## Dependencies and Generated Code

- Prefer Flutter, Dart, and existing project dependencies before adding a package.
- Add a dependency only when its maintenance cost is justified by functionality the project does not already have. Prefer mature, actively maintained packages and explain the choice.
- Use Flutter or Dart package commands so manifests and lockfiles remain synchronized. Avoid dependency overrides except as an explicit, temporary compatibility measure.
- Do not introduce code generation, a new state system, routing framework, dependency-injection framework, or app-wide design system without a concrete need.
- Modify source definitions rather than generated files, then run the project's generator and include the synchronized output when generated files are tracked.
- Follow an existing generated or non-generated Riverpod style consistently within a feature; do not mix styles arbitrarily.

## Testing and Verification

- Test behavior rather than implementation details, using the smallest useful level: unit tests for isolated logic, widget tests for rendered behavior and interactions, and integration tests for critical cross-layer flows.
- Keep tests deterministic. Replace real networks, Firebase, wall-clock time, and unstable animation timing with fakes, provider overrides, or fixed inputs.
- Prefer fakes or stubs over mocks. Add mocking or generation packages only when simpler test doubles are insufficient.
- When fixing a bug, add or strengthen a focused regression test when the code has a practical test seam.
- Cover user-visible loading, empty, error, and success states where they are part of the feature contract.
- Test semantics for accessibility-sensitive controls when practical.
- Do not add tests merely to increase coverage numbers; every test should protect meaningful behavior.

For Dart changes, run `dart format` on changed Dart files and run `flutter analyze`. Run relevant `flutter test` targets whenever behavior, state, data mapping, routing, providers, or repositories change. Use narrower checks when the complete suite would be disproportionate, but state what was and was not run.

For visual changes, inspect the affected UI at narrow and wide sizes. Check overflow, dynamic text, focus and hover states, loading and failure states, and consistency with the existing theme. If runtime verification is unavailable, say so clearly and perform a code-level layout review.

Documentation-only changes do not require Flutter analysis or tests; review their rendered structure, accuracy, links, and diff instead.

## Completion

Before considering work complete:

1. Format changed files with the project's tools.
2. Run the relevant analyzer, tests, generators, and visual checks.
3. Review the final diff and remove temporary code.
4. Confirm that unrelated files and user changes were preserved.

Report concisely:

- What changed.
- Important decisions or assumptions.
- Checks performed and their results.
- Remaining risks or follow-up work.
