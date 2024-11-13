# Smart Tasks

A modern Flutter task management application built with Clean Architecture principles, featuring AI-powered task descriptions and an intuitive user interface.

## 🏗 Architecture

This project implements Clean Architecture with three main layers:

### Domain Layer

- Contains business logic and entities
- Defines repository interfaces
- Pure Dart code with no external dependencies

### Data Layer

- Implements repository interfaces
- Handles data persistence using SQLite
- Manages external data sources and API interactions

### Presenter Layer

- Implements UI using Flutter
- Uses BLoC pattern for state management
- Contains reusable widgets and screens

## ✨ Features

- Create, read, update, and delete tasks
- Filter tasks by status (pending/completed)
- AI-powered task descriptions
- Local data persistence using SQLite
- Interactive tutorial for new users
- Modern Material Design UI with custom color scheme
- Clean Architecture implementation
- BLoC pattern for state management
- Animated UI transitions
- Snackbar notifications for user feedback

## 🎨 UI Theme

The app uses a modern color palette:

- Primary Color: Dark Blue (#1A237E)
- Secondary Color: Light Blue (#3949AB)
- Accent Color: Vibrant Blue (#3D5AFE)
- Background: Light Blue-tinted (#F8F9FF)
- Success/Completed: Vibrant Green (#00C853)
- Pending: Vibrant Orange (#FF6D00)

## 🛠 Tech Stack

- Flutter SDK ^3.5.x or +
- State Management:
  - flutter_bloc: ^8.1.6
  - equatable: ^2.0.5
- Routing & DI:
  - flutter_modular: ^6.3.4
- Database:
  - sqflite: ^2.4.1
- Networking:
  - http: ^1.2.0
- UI Components:
  - tutorial_coach_mark: ^1.2.11
- Utilities:
  - fpdart: ^1.1.0
  - intl: ^0.19.0
  - shared_preferences: ^2.2.2

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ^3.5.x or +
- Dart SDK ^3.5.x or +
- Android Studio / VS Code
- Android SDK / Xcode (for iOS development)

### Installation

1. Clone the repository:

```bash
git clone https://github.com/AndreyDAraya/smart_tasks.git
```

2. Navigate to the project directory:

```bash
cd smart_tasks
```

3. Install dependencies:

```bash
flutter pub get
```

4. Set up environment variables:

   - Copy .env.example to .env
   - Update the values as needed

5. Run the app:

```bash
flutter run
```

### Building APK

To generate a signed APK:

1. Follow the instructions in android_signing.md to set up signing
2. Run the build script:

```bash
chmod +x build_apk.sh
./build_apk.sh
```

The APK will be generated in build/app/outputs/flutter-apk/

## 📱 App Structure

```
lib/
  ├── core/           # Core functionality and shared code
  │   └── failure/    # Error handling
  └── src/
      └── task/       # Task feature module
          ├── data/           # Data layer
          │   └── internal/
          │       ├── datasource/
          │       ├── models/
          │       └── repositories/
          ├── domain/         # Domain layer
          │   ├── entities/
          │   └── repository/
          └── presenter/      # Presentation layer
              ├── bloc/
              └── page/
```

## 🧪 Testing

The project includes comprehensive tests:

```bash
# Run unit tests
flutter test
```

Test coverage includes:

- Database operations
- Repository implementations
- BLoC state management
- Entity and model mapping
- AI description generation

## 🔧 Development

The project follows Clean Architecture principles:

1. **Dependency Rule**: Dependencies point inward, with the domain layer at the center
2. **Separation of Concerns**: Each layer has specific responsibilities
3. **Dependency Injection**: Using flutter_modular for DI
4. **State Management**: Using BLoC pattern with flutter_bloc

## 📝 Code Style

- Following official Dart style guide
- Using flutter_lints for code analysis
- Clean Architecture principles
- BLoC pattern implementation

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

# smart_tasks
