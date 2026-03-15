# ArvyaX Mini

An immersive, calm mini app for ambient sounds and journaling, built with Flutter.

## Architecture & State Management
This project follows a clean architecture pattern with feature-based folder organization:
- `data/`: Contains models and repository classes (Ambience, Journal, Session).
- `features/`: The UI and Riverpod providers grouped by feature (`ambience`, `journal`, `player`).
- `shared/`: App-wide widgets and ThemeData setup (Dark Mode and Light Mode).

### State Management: Riverpod
I chose **Riverpod** due to its compile-time safety and scalability. 
- Application state flows from Repositories (data sources: Hive, JSON) -> Providers / StateNotifiers -> UI.
- `sessionProvider`: A `StateNotifierProvider` manages the active sessiontimer and audio state, allowing the `MiniPlayer` to stay in sync anywhere in the app.

### Persistence: Hive
- I opted for **Hive** without codegen to avoid `build_runner` conflicts. TypeAdapters are written manually, ensuring zero-dependency fast builds.
- Journal entries and the Last Active Session State are persisted locally.

## Features Completed
- **Ambience Library**: Grid view with tag filtering and search.
- **Session Player**: Breathing visual animation, `just_audio` loop playback, manual session timer independent of the audio length.
- **Mini Player**: Appears globally when a session is active.
- **Journaling**: Post-session reflection with mood tracking. History screen.
- **Bonus**: Dark mode support via Theme Tokens in `AppTheme`.

## How to Run
1. Ensure you have the Flutter SDK (e.g. 3.27+) installed.
2. Run `flutter pub get`.
3. Run `flutter build apk` to generate the APK, or run on an emulator using `flutter run`.

