# 📋 Task Management & To-Do List App

A modern, beautifully designed task management application built with Flutter. This app helps users organize their daily tasks, track progress, and boost productivity with an intuitive and stylish interface.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

## ✨ Features

- **Task Management** - Create, edit, and delete tasks with ease
- **Project Organization** - Group tasks into projects (Office, Personal, Daily Study, etc.)
- **Progress Tracking** - Visual progress indicators for each project
- **Calendar View** - View and manage tasks by date
- **Task Status** - Track tasks as To-Do, In Progress, or Done
- **Beautiful UI** - Modern, clean design with smooth animations
- **Dark Mode** - Full support for light and dark themes
- **Cross-Platform** - Runs on iOS, Android, Web, and Desktop

## 📱 Screenshots

| Home | Today's Tasks | Add Project |
|:----:|:-------------:|:-----------:|
| Coming Soon | Coming Soon | Coming Soon |

## 🎨 Design System

This app implements a comprehensive design system based on the [Figma design](https://www.figma.com/design/U7sk8wkrbitinE9yzX77KX/Task-management---to-do-list-app--Community-).

### Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| 🟣 Primary | `#5F33E1` | Main brand color, buttons, accents |
| ⚫ Black | `#24252C` | Dark backgrounds, primary text |
| ⚪ White | `#FAFAFA` | Light backgrounds |
| 🔵 Secondary | `#6E6A7C` | Secondary text, icons |
| 🟡 Accent | `#F6E31A` | Highlights, badges |
| 🟠 Orange | `#FF7D53` | To-Do status |
| 🟢 Green | `#0ECC5A` | Done status |

### Typography

- **Font Family**: Manrope
- **Weights**: Regular (400), Medium (500), SemiBold (600), Bold (700)

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── core/
│   ├── theme/               # Design system
│   │   ├── app_colors.dart  # Color definitions
│   │   ├── app_typography.dart # Text styles
│   │   ├── app_spacing.dart # Spacing & sizing
│   │   ├── app_shadows.dart # Shadow definitions
│   │   ├── app_theme.dart   # ThemeData configuration
│   │   └── theme.dart       # Barrel export
│   ├── constants/           # App-wide constants
│   ├── utils/               # Helper functions
│   └── router/              # Navigation setup
├── feature/                 # Feature modules
│   └── [feature_name]/
│       ├── data/            # Data layer
│       ├── domain/          # Business logic
│       └── presentation/    # UI layer
└── shared/
    └── widgets/             # Reusable widgets
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/task_todo_app.git
   cd task_todo_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 🛠️ Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: TBD (BLoC/Riverpod recommended)
- **Navigation**: TBD (go_router recommended)
- **Local Storage**: TBD (Hive/SQLite recommended)
- **Architecture**: Clean Architecture with Feature-first structure

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  # Add your dependencies here
```

## 🎯 Roadmap

- [x] Setup project structure
- [x] Implement design system (colors, typography, spacing)
- [x] Configure light and dark themes
- [ ] Create reusable UI components
- [ ] Implement home screen
- [ ] Implement task list screen
- [ ] Add task creation/editing
- [ ] Implement project management
- [ ] Add calendar integration
- [ ] Implement local data persistence
- [ ] Add notifications
- [ ] Write tests

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Design inspiration from [Suspended Suspended](https://www.figma.com/@SuspendedTeam) on Figma
- [Flutter](https://flutter.dev/) for the amazing framework
- All contributors who help improve this project

---

<p align="center">
  Made with ❤️ using Flutter
</p>
