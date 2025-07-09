# 📝 Blog App - Flutter

A modern and elegant blog application built with Flutter, featuring user authentication and blog creation capabilities.

## ✨ Features

- 🔐 **User Authentication**

  - Sign Up with email and password
  - Login functionality
  - Secure user sessions with Supabase

- 📱 **Blog Management**

  - Create new blog posts
  - Add images to blog posts
  - Select blog categories/topics
  - Rich text editing

- 🎨 **Modern UI/UX**
  - Dark theme design
  - Gradient color schemes
  - Smooth animations
  - Responsive design

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                   # Core utilities and shared components
│   ├── common/            # Common widgets (Loader, etc.)
│   ├── error/             # Error handling (Failure, Exception)
│   ├── theme/             # App theming (Colors, Styles)
│   ├── usecase/           # Base UseCase interface
│   └── utils/             # Utility functions
│
├── features/              # Feature modules
│   ├── auth/              # Authentication feature
│   │   ├── data/          # Data layer (Repository impl, Data sources)
│   │   ├── domain/        # Domain layer (Entities, Repository interfaces, Use cases)
│   │   └── presentation/  # Presentation layer (BLoC, Pages, Widgets)
│   │
│   └── blog/              # Blog feature
│       ├── data/          # Data layer
│       ├── domain/        # Domain layer
│       └── presentation/  # Presentation layer
│
└── init_dependencies.dart # Dependency injection setup
```

## 🛠️ Tech Stack

- **Framework**: Flutter 3.8.1+
- **State Management**: BLoC (flutter_bloc)
- **Backend**: Supabase
- **Dependency Injection**: GetIt
- **Functional Programming**: fpdart
- **Image Picker**: image_picker
- **UI Components**: dotted_border

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  fpdart: ^1.1.1
  supabase_flutter: ^2.9.0
  flutter_bloc: ^9.1.1
  get_it: ^8.0.3
  dotted_border: ^3.1.0
  image_picker: ^1.0.7
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Supabase account

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-username/blog_app.git
   cd blog_app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Setup Supabase**

   - Create a new project on [Supabase](https://supabase.com)
   - Update `lib/core/secrets/app_secrets.dart` with your Supabase credentials:

   ```dart
   class AppSecrets {
     static const supabaseUrl = "YOUR_SUPABASE_URL";
     static const supabaseAnnonKey = "YOUR_SUPABASE_ANON_KEY";
   }
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Screenshots

### Authentication Screens

| Login                           | Sign Up                            |
| ------------------------------- | ---------------------------------- |
| ![Login](screenshots/login.png) | ![Sign Up](screenshots/signup.png) |

### Blog Features

| Add New Blog                          | Blog List                               |
| ------------------------------------- | --------------------------------------- |
| ![Add Blog](screenshots/add_blog.png) | ![Blog List](screenshots/blog_list.png) |

## 🎨 Design System

### Color Palette

- **Background**: `#181820`
- **Gradient 1**: `#BB3FDD`
- **Gradient 2**: `#FB6DA9`
- **Gradient 3**: `#FF9F7C`
- **Border**: `#193343`

### Typography

- **Headers**: Bold, large font sizes
- **Body**: Regular weight, readable sizes
- **Hints**: Subtle, lighter colors

## 🧪 Testing

Run tests with:

```bash
flutter test
```

## 📂 Project Structure Details

### Clean Architecture Layers

1. **Domain Layer** (`domain/`)

   - **Entities**: Core business objects (User, Blog)
   - **Repositories**: Abstract interfaces for data operations
   - **Use Cases**: Business logic implementations

2. **Data Layer** (`data/`)

   - **Models**: Data transfer objects extending entities
   - **Repositories**: Concrete implementations of domain repositories
   - **Data Sources**: API and local data handling

3. **Presentation Layer** (`presentation/`)
   - **BLoC**: State management for UI
   - **Pages**: Screen widgets
   - **Widgets**: Reusable UI components

## 🔄 State Management

This app uses **BLoC (Business Logic Component)** pattern for state management:

- **Events**: User actions (AuthLogin, AuthSignUp, etc.)
- **States**: UI states (AuthLoading, AuthSuccess, AuthFailure)
- **BLoC**: Business logic processors

## 🌐 API Integration

### Supabase Integration

- **Authentication**: Email/password authentication
- **Database**: PostgreSQL database for blog storage
- **Real-time**: Live updates for blog posts
- **Storage**: Image uploads and storage

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) - UI framework
- [Supabase](https://supabase.com/) - Backend services
- [BLoC Library](https://bloclibrary.dev/) - State management
- [Material Design](https://material.io/) - Design system

## 📞 Contact

Your Name - [@your_twitter](https://twitter.com/your_twitter) - email@example.com

Project Link: [https://github.com/your-username/blog_app](https://github.com/your-username/blog_app)

---

⭐ **Star this repository if you found it helpful!**
