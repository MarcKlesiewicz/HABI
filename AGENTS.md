# AGENTS.md

## Project

- Habi is a Flutter app using Material 3, GoRouter, Riverpod, Firebase Auth, and Cloud Firestore.
- Keep work scoped to the requested feature or fix. Preserve user changes already present in the working tree.
- Prefer the existing feature-first layout under `lib/features/`, shared UI under `lib/shared/`, app configuration under `lib/config/`, and Firebase setup under `lib/core/firebase/`.
- The main entry point is `lib/main.dart`; app routing lives in `lib/config/routes/routes.dart`; app theme and design tokens live in `lib/config/theme/`.

## Interaction

- Assume the user is comfortable with programming concepts but may want Dart-specific details explained.
- When introducing Dart features such as null safety, `Future`, `Stream`, records, or pattern matching, explain the choice briefly if it is not obvious from the surrounding code.
- Ask for clarification only when the intended functionality, platform, or data behavior is genuinely ambiguous.

## Flutter and Dart

- Follow Effective Dart and the configured `package:flutter_lints/flutter.yaml` rules in `analysis_options.yaml`.
- Use concise, modern, null-safe Dart. Prefer clear declarative code over clever or obscure code.
- Use meaningful names: `PascalCase` for classes, `camelCase` for members/functions/variables, and `snake_case` for files.
- Prefer immutable data, `final` locals, `const` constructors, and sound null safety. Avoid `!` unless the value is guaranteed by nearby control flow or framework contract.
- Use exhaustive `switch` statements or expressions where they improve clarity.
- Use pattern matching and records when they make code simpler; prefer a named class when the value has domain meaning or is passed broadly.
- Use arrow syntax for simple one-line functions.
- Keep functions focused. Split work when a function is trying to handle unrelated responsibilities.
- Keep widget `build` methods free of side effects. Do data loading, writes, timers, controllers, and subscriptions through lifecycle methods, Riverpod providers, repositories, or explicit callbacks.
- Check `mounted` before using a `BuildContext` after an `await` in a `State` object. Prefer provider-driven async state when it fits the feature.
- Avoid broad `dynamic`, long-lived `Map<String, dynamic>` values, and nullable values that can be normalized at a repository or parsing boundary.
- Use comments to explain why code is written a certain way. Do not add comments that restate obvious names or simple assignments.
- Add dartdoc comments to public APIs when they are reusable or non-obvious; avoid noisy documentation for private one-off widgets.
- Do not leave trailing comments on code lines; put useful comments above the code they explain.
- Anticipate errors in async, parsing, Firebase, and routing code. Prefer explicit fallbacks or visible error states over silent failure.
- Keep line length reasonable and let `dart format` decide wrapping; avoid hand-wrapped code that fights the formatter.

## Architecture

- Favor composition over inheritance for widgets and logic.
- Keep UI, state coordination, domain behavior, and data access separate.
- Use feature folders with `presentation`, `application`, and `data` subfolders when a feature grows enough to need them.
- Keep shared utilities and widgets in `lib/shared/` only when they are reused across features.
- Define related classes in the same library file when that keeps the feature easier to navigate; split large libraries once they become difficult to scan.
- Design reusable APIs from the caller's perspective. Prefer explicit constructor parameters and typed results over hidden global behavior.
- Apply SOLID principles pragmatically: keep responsibilities clear, dependencies explicit, and abstractions justified by real reuse or testability.
- Prefer dependency injection through constructors or Riverpod providers over hidden service lookup.
- Keep domain logic testable outside widgets. Date calculations, recurrence rules, filtering, sorting, and Firestore mapping should not be embedded in UI callbacks.
- For reusable APIs, document assumptions, valid inputs, error behavior, and examples when they are not obvious.

## Widgets and Layout

- Compose complex UIs from smaller widgets. Prefer small private `Widget` classes over private helper methods that return large widget trees.
- Use `ListView.builder`, `GridView.builder`, or slivers for long or dynamic lists.
- Use `LayoutBuilder`, `MediaQuery`, and this app's responsive context helpers for layout decisions.
- Use `Expanded`, `Flexible`, and `Wrap` deliberately to avoid row/column overflow. Do not combine `Expanded` and `Flexible` for the same child.
- Use `SingleChildScrollView` for fixed content that may exceed the viewport; use builder-based scrollables for unbounded or large collections.
- Use `FittedBox` sparingly for single elements that must scale inside a constrained parent.
- Use `OverlayPortal` or Flutter overlay primitives for dropdowns/tooltips/popovers that must appear above other content.
- Prefer `Padding`, `SizedBox`, `DecoratedBox`, `ColoredBox`, `Align`, or `ConstrainedBox` over a generic `Container` when those widgets express the intent more clearly.
- Avoid expensive computation, JSON parsing, sorting large collections, and network/database calls in `build`. Move expensive work into providers, repositories, memoized values, or isolates via `compute()` when needed.
- Dispose controllers, focus nodes, animation controllers, stream subscriptions, and other owned resources.
- Prefer Flutter's built-in adaptive layout primitives before creating custom layout systems.
- Keep scroll views predictable: avoid nesting multiple primary scrollables unless the interaction is deliberate and tested.

## UI and Theming

- Match the existing Material 3 theme in `lib/config/theme/`. Do not replace it with generic `ColorScheme.fromSeed` guidance unless the task explicitly asks for a theme redesign.
- Prefer this app's BuildContext extensions from `theme_extensions.dart`: `context.colorScheme`, `context.textTheme`, `context.gapSM`, `context.paddingMD`, `context.radiusLG`, and responsive helpers such as `context.isMobile`.
- Use `AppConstants` directly when a design value is not exposed through a context extension.
- Do not introduce a second spacing, radius, breakpoint, typography, or color-token system.
- Avoid hardcoded colors, text styles, spacing, and radii in widgets unless the value is truly one-off and justified. Extend the existing theme, constants, or context extensions instead.
- Use the app's semantic/custom colors where they already exist, such as `context.colorScheme.success`, `warning`, and `info`.
- Keep Material components theme-aware. Prefer configured `FilledButton`, `OutlinedButton`, `TextButton`, `IconButton`, `Card`, `Chip`, `SegmentedButton`, form fields, and dialogs before custom component styling.
- Use `WidgetStateProperty.resolveWith` for component styles that vary by pressed, hovered, focused, selected, or disabled states.
- Keep screens responsive for web and mobile. Check for text overflow, cramped buttons, layout shifts, and unusable dynamic text scaling.
- Maintain accessible contrast, generally at least WCAG 2.1 AA for normal text.
- Use icons when they improve scanning or navigation, but keep labels clear for important actions.
- Reuse existing shared widgets such as shell/navigation and glass/container components before adding new visual primitives.
- Preserve the app's current warm Material 3 visual language. Do not add unrelated palettes, glow-heavy effects, generic seed themes, or decorative texture/noise unless specifically requested.
- Use typography hierarchy intentionally: page titles, section headings, labels, body text, and helper text should come from `context.textTheme` and fit the density of the surrounding UI.
- Keep body text readable with comfortable line height and avoid long all-caps text.
- Prefer component themes in `AppTheme` for repeated styling changes instead of per-widget overrides.
- If introducing custom theme tokens, use the existing theme extension pattern or app constants and keep light/dark behavior in mind.
- Test both narrow mobile widths and wider web layouts for any changed screen.

## State, Data, and Firebase

- Use Riverpod providers for app state, async state, dependency access, and shared feature state. This overrides generic Flutter guidance that prefers built-in state management or `ChangeNotifier`.
- Local ephemeral UI state may stay local with `StatefulWidget`, controllers, or value notifiers when it does not affect app behavior outside the widget.
- Do not replace Riverpod with `setState`, service locators, singletons, `provider`, `ChangeNotifier`, or ad hoc globals for shared state.
- Represent loading, empty, error, and success states deliberately. Do not swallow repository errors silently unless there is a clear fallback UX.
- Keep Firebase and Firestore access behind repositories or services. Widgets should not directly own Firestore serialization.
- Keep Firestore serialization defensive: validate enum names, timestamps, nullable fields, and fallback values at the repository boundary.
- Preserve the local fallback behavior where repositories support running without Firebase.
- Do not change Firebase project configuration, generated `firebase_options.dart`, Firestore rules, indexes, or deployment settings unless the task explicitly asks for it.
- Use `Future`/`async`/`await` for one-shot async work and `Stream` for ongoing updates. Prefer Riverpod wrappers for exposing either to the UI.
- Use `try`/`catch` where a failure is expected and meaningful to handle. Include the stack trace when logging unexpected errors.
- Keep provider dependencies acyclic and easy to override in tests.
- Avoid storing derived state when it can be computed clearly from source state.
- Keep serialization names stable once data is stored in Firestore. Add migration or fallback logic when changing stored shapes.
- Treat timestamps, time zones, recurrence rules, and nullable date fields carefully; use fixed clocks in tests for date-sensitive logic.

## Routing and Navigation

- Use GoRouter for app pages, declarative navigation, deep links, and web-friendly routes.
- Add app routes in `lib/config/routes/routes.dart` and keep route path constants in `AppRoutePath`.
- Screens reached from the shell should continue to render inside `ShellLayout`.
- Use `Navigator` only for short-lived flows that do not need deep links, such as dialogs or temporary modal screens.
- If auth redirects are added, implement them through GoRouter and Riverpod-aware app state instead of scattering checks in pages.

## Assets and Images

- Add local assets under the existing `lib/assets/images/` or `lib/assets/svg/` folders.
- The asset folders are already declared in `pubspec.yaml`; update `pubspec.yaml` only when adding a new asset path.
- Use `Image.asset` for local bitmap assets and `flutter_svg` for SVGs when appropriate.
- If network images are introduced, include loading and error states. Do not add an image caching package unless the feature clearly needs it.
- Use meaningful, licensed, relevant images. Avoid decorative assets that do not support the task or user workflow.
- Keep asset filenames descriptive and lowercase with separators.
- Size and fit images deliberately so they do not distort, crop important content, or cause layout jumps while loading.

## Dependencies and Code Generation

- Prefer existing dependencies. Ask before adding new runtime packages unless the task clearly requires one.
- If dependencies change, update `pubspec.yaml` through Flutter/Dart tooling and keep `pubspec.lock` in sync.
- When suggesting or adding a dependency, explain the benefit and why existing dependencies are insufficient.
- Do not add generated code, build runners, `json_serializable`, `freezed`, state-management alternatives, app-wide design systems, or routing frameworks without an explicit reason.
- If code generation is later introduced, document the generation command and run it after changing generated inputs.
- Use `flutter pub add <package>` or `flutter pub add dev:<package>` for dependency changes when tooling is available.
- Remove dependencies with `dart pub remove <package>` or the Flutter equivalent rather than editing only one file.
- Avoid dependency overrides unless the task explicitly requires a temporary compatibility fix.

## Logging and Diagnostics

- Avoid `print` for app diagnostics. Prefer `dart:developer` logging or an existing project logging abstraction if one is added.
- Log enough context to debug failures, but do not log secrets, Firebase credentials, personal data, or auth tokens.

## Testing

- Prefer widget tests for user-visible UI behavior and unit tests for pure scheduling, parsing, repository mapping, and provider logic.
- Follow Arrange-Act-Assert or Given-When-Then structure.
- Keep tests deterministic: avoid real Firebase/network calls, wall-clock dependence, and animation timing flakiness. Inject fakes or fixed dates where needed.
- Prefer fakes or stubs over mocks. Add mocking/codegen packages only when simpler fakes are not enough.
- When fixing a bug, add or update a focused regression test when the code is structured to support it.
- Use `package:flutter_test` for widget tests and Flutter-aware unit tests. Add `integration_test` only when an end-to-end flow requires it.
- Cover loading, empty, error, and success states for provider-backed UI when those states are user-visible.
- Prefer testing behavior and rendered output over implementation details.
- For accessibility-sensitive UI, include semantic labels in widget tests when practical.

## Documentation

- Keep documentation close to where it helps: README for setup, dartdoc for public APIs, and concise inline comments for non-obvious implementation choices.
- Start dartdoc with a short summary sentence. Add details only when they help callers use the API correctly.
- Document parameters, return values, thrown exceptions, side effects, and examples for reusable public APIs when relevant.
- Do not document both a getter and setter for the same property unless their behavior differs.
- Use Markdown sparingly in docs and avoid HTML.

## Accessibility

- Keep touch targets large enough for mobile use and actions reachable for web/keyboard users where practical.
- Use readable text hierarchy and avoid all-caps long-form text.
- Add semantic labels for icon-only controls, custom interactive widgets, and images that convey information.
- Ensure UI remains usable with larger system text sizes.
- Prefer real buttons and Material controls for interactive elements so focus, hover, pressed, disabled, and semantics behavior come for free.
- Ensure color is not the only indicator of status or selection when text/icon alternatives are reasonable.

## Verification

- For Dart changes, run `dart format <changed dart files>` before finishing.
- Run `flutter analyze` after Dart changes.
- Run `flutter test` when behavior, repositories, scheduling logic, routing, providers, or state management changes.
- For visual changes, also run the app or provide clear notes if local verification was not possible.
