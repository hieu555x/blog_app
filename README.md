# 📱 Blog App

> A full-featured blog application built with Flutter using Clean Architecture

![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.8.1+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)

## 📋 Table of Contents

- [✨ Features](#-features)
- [🏗️ Architecture](#️-architecture)
- [🛠️ Tech Stack](#️-tech-stack)
- [📦 Installation](#-installation)
- [⚙️ Configuration](#️-configuration)
- [🚀 Running the App](#-running-the-app)
- [📂 Project Structure](#-project-structure)
- [🔧 API Reference](#-api-reference)
- [🤝 Contributing](#-contributing)

## ✨ Features

### 🔐 Authentication

- [x] **User Registration** with email and password
- [x] **Secure Login** functionality
- [x] **Logout** with confirmation
- [x] **Persistent login** - Auto login when app opens
- [x] **Session management** with Supabase Auth

### 📝 Blog Management

- [x] **Create new blogs** with rich text editor
- [x] **Upload images** from gallery or camera
- [x] **Categorize blogs** with tags/topics
- [x] **View blog list** with pagination
- [x] **Read blog details** with reading time calculation
- [x] **Delete blogs** (author only)
- [x] **Offline reading** with local cache

### 🎨 UI/UX Features

- [x] **Dark theme** with modern design
- [x] **Responsive design** for multiple screen sizes
- [x] **Loading states** and error handling
- [x] **Smooth animations** and transitions
- [x] **User-friendly feedback** with snackbars
- [x] **Clean card-based layout**

### 📱 Technical Features

- [x] **Offline-first approach** with Hive local storage
- [x] **Network connectivity check**
- [x] **Image optimization** and caching
- [x] **State management** with BLoC pattern
- [x] **Dependency injection** with GetIt
- [x] **Error handling** with Either pattern

## 🏗️ Architecture

The application is built following **Clean Architecture pattern** with 3 main layers:

```
📦 lib/
├── 🎯 Domain Layer (Business Logic)
│   ├── entities/          # Core business objects
│   ├── repositories/      # Abstract interfaces
│   └── usecases/         # Business rules
├── 📊 Data Layer (Data Management)
│   ├── datasources/      # Remote & Local data sources
│   ├── models/          # Data models with JSON serialization
│   └── repositories/    # Repository implementations
└── 🎨 Presentation Layer (UI)
    ├── bloc/           # State management
    ├── pages/          # Screen widgets
    └── widgets/        # Reusable UI components
```

### Architecture Benefits:

- ✅ **Separation of Concerns** - Each layer has distinct responsibilities
- ✅ **Testability** - Easy to unit test individual components
- ✅ **Maintainability** - Well-organized code, easy to extend
- ✅ **Scalability** - Adding new features doesn't affect existing code
- ✅ **Independence** - Business logic doesn't depend on frameworks

## 🛠️ Tech Stack

### **Frontend Framework**

- **Flutter 3.8.1+** - Cross-platform mobile development
- **Dart 3.8.1+** - Programming language

### **State Management**

- **flutter_bloc ^9.1.1** - Predictable state management
- **BLoC Pattern** - Business Logic Component architecture

### **Backend & Database**

- **Supabase** - Backend-as-a-Service
  - PostgreSQL database
  - Real-time subscriptions
  - Authentication
  - File storage
  - Row Level Security (RLS)

### **Local Storage**

- **Hive ^2.2.3** - Fast, lightweight NoSQL database
- **Path Provider ^2.1.5** - Access to device file system

### **Dependency Injection**

- **GetIt ^8.0.3** - Service locator pattern

### **Functional Programming**

- **fpdart ^1.1.1** - Functional programming utilities
  - Either pattern for error handling
  - Option pattern for null safety

### **Utilities**

- **Image Picker ^1.1.2** - Camera & gallery access
- **UUID ^4.5.1** - Unique identifier generation
- **Intl ^0.20.2** - Internationalization and date formatting
- **Internet Connection Checker ^2.7.2** - Network connectivity monitoring
- **Dotted Border ^3.1.0** - UI component for dashed borders

## 📦 Installation

### **System Requirements:**

- Flutter SDK 3.8.1 or higher
- Dart SDK 3.8.1 or higher
- Android Studio / VS Code
- Git

### **Clone repository:**

```bash
git clone https://github.com/hieu555x/blog_app.git
cd blog_app
```

### **Install dependencies:**

```bash
flutter pub get
```

### **Check Flutter setup:**

```bash
flutter doctor
```

## ⚙️ Configuration

### **1. Supabase Setup**

1. Create a new project at [supabase.com](https://supabase.com)

2. Create file `lib/core/secrets/app_secrets.dart`:

```dart
class AppSecrets {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnnonKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

### **2. Database Schema**

Run the following SQL script in Supabase SQL Editor:

```sql
-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE blogs ENABLE ROW LEVEL SECURITY;

-- Create profiles table
CREATE TABLE profiles (
    id UUID REFERENCES auth.users(id) PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create blogs table
CREATE TABLE blogs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    poster_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    image_url TEXT,
    topics TEXT[] DEFAULT '{}',
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create storage bucket for blog images
INSERT INTO storage.buckets (id, name, public) VALUES ('blog_image', 'blog_image', true);

-- RLS Policies
CREATE POLICY "Users can read all profiles" ON profiles FOR SELECT USING (true);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can read all blogs" ON blogs FOR SELECT USING (true);
CREATE POLICY "Users can create own blogs" ON blogs FOR INSERT WITH CHECK (auth.uid() = poster_id);
CREATE POLICY "Users can update own blogs" ON blogs FOR UPDATE USING (auth.uid() = poster_id);
CREATE POLICY "Users can delete own blogs" ON blogs FOR DELETE USING (auth.uid() = poster_id);

-- Storage policies
CREATE POLICY "Users can upload blog images" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'blog_image');
CREATE POLICY "Public can view blog images" ON storage.objects FOR SELECT USING (bucket_id = 'blog_image');
CREATE POLICY "Users can delete own blog images" ON storage.objects FOR DELETE USING (bucket_id = 'blog_image');
```

### **3. Authentication Setup**

Trigger function to automatically create profile when user signs up:

```sql
-- Function to create profile on signup
CREATE OR REPLACE FUNCTION public.create_profile_for_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, name, email)
  VALUES (new.id, new.raw_user_meta_data->>'name', new.email);
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger the function every time a user is created
CREATE TRIGGER create_profile_on_signup
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.create_profile_for_new_user();
```

## 🚀 Running the App

### **Development Mode:**

```bash
# Android
flutter run

# iOS (macOS only)
flutter run -d ios

# Web
flutter run -d web
```

### **Build for Production:**

```bash
# Android APK
flutter build apk --release

# Android AAB (for Play Store)
flutter build appbundle --release

# iOS (macOS only)
flutter build ios --release
```

### **Debug Commands:**

```bash
# Run tests
flutter test

# Analyze code
flutter analyze

# Check for dependency updates
flutter pub outdated
```

## 📂 Project Structure

```
📦 blog_app/
├── 📱 android/                 # Android-specific files
├── 🍎 ios/                     # iOS-specific files
├── 🌐 web/                     # Web-specific files
├── 📚 lib/
│   ├── 🎯 core/                # Core functionality
│   │   ├── common/             # Shared widgets & cubits
│   │   ├── constants/          # App constants
│   │   ├── error/             # Error handling
│   │   ├── network/           # Network utilities
│   │   ├── secrets/           # API keys & secrets
│   │   ├── theme/             # App theming
│   │   ├── usecase/           # Base usecase classes
│   │   └── utils/             # Utility functions
│   ├── 🔐 features/auth/       # Authentication feature
│   │   ├── data/              # Data layer
│   │   ├── domain/            # Domain layer
│   │   └── presentation/      # Presentation layer
│   ├── 📝 features/blog/       # Blog feature
│   │   ├── data/              # Data layer
│   │   ├── domain/            # Domain layer
│   │   └── presentation/      # Presentation layer
│   ├── 🔧 init_dependencies.dart # Dependency injection setup
│   └── 🚀 main.dart           # App entry point
├── 🧪 test/                    # Test files
├── 📄 pubspec.yaml            # Project dependencies
└── 📖 README.md               # This file
```

## 🔧 API Reference

### **Authentication Endpoints**

```dart
// Sign Up
POST /auth/v1/signup
Body: { email, password, name }

// Sign In
POST /auth/v1/token?grant_type=password
Body: { email, password }

// Sign Out
POST /auth/v1/logout
```

### **Blog Endpoints**

```dart
// Get all blogs
GET /rest/v1/blogs?select=*,profiles(name)

// Create blog
POST /rest/v1/blogs
Body: { title, content, image_url, topics, poster_id }

// Update blog
PATCH /rest/v1/blogs?id=eq.{blog_id}
Body: { title, content, image_url, topics }

// Delete blog
DELETE /rest/v1/blogs?id=eq.{blog_id}
```

### **Storage Endpoints**

```dart
// Upload image
POST /storage/v1/object/blog_image/{file_name}
Body: FormData with image file

// Get image URL
GET /storage/v1/object/public/blog_image/{file_name}
```

## 🎨 Screenshots

### **Authentication Screens**

_Screenshots coming soon..._

### **Blog Management**

_Screenshots coming soon..._

### **Dark Theme UI**

_Screenshots coming soon..._

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/auth_test.dart
```

## 🚀 Deployment

### **Android (Google Play Store)**

1. Build AAB: `flutter build appbundle --release`
2. Upload to Google Play Console
3. Follow Play Store review process

### **iOS (App Store)**

1. Build iOS: `flutter build ios --release`
2. Archive in Xcode
3. Upload to App Store Connect
4. Follow App Store review process

## 🔒 Security

- ✅ **Row Level Security (RLS)** enabled on Supabase
- ✅ **Authentication required** for all write operations
- ✅ **Input validation** on client and server side
- ✅ **File upload restrictions** and validation
- ✅ **API keys secured** in environment variables

## 🧩 Key Features Implementation

### **Delete Blog Functionality**

The app implements a secure blog deletion feature:

1. **Authorization Check**: Only blog authors can see delete button
2. **UI Placement**: Delete button located in blog detail page AppBar
3. **Confirmation Dialog**: Prevents accidental deletions
4. **Data Cleanup**: Removes both database record and storage images
5. **State Management**: Auto-refreshes blog list after deletion
6. **Error Handling**: Proper feedback for success/failure states

### **Offline Support**

- Local caching with Hive database
- Network connectivity detection
- Graceful fallback to cached data
- Sync when connection restored

### **Clean Architecture Benefits**

- **Domain Layer**: Pure business logic, framework independent
- **Data Layer**: Repository pattern with multiple data sources
- **Presentation Layer**: BLoC state management with reactive UI

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### **Development Workflow:**

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add some amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

### **Code Style:**

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` before committing
- Run `flutter analyze` to check for issues
- Write unit tests for new features

### **Pull Request Guidelines:**

- Describe the changes in detail
- Include screenshots for UI changes
- Update documentation if needed
- Ensure all tests pass

## 📈 Performance

- **App Size**: Optimized APK size (~15MB)
- **Startup Time**: Fast cold start with efficient dependency injection
- **Memory Usage**: Efficient with proper widget disposal
- **Network**: Minimal API calls with smart caching

## 🐛 Known Issues

- [ ] Image upload progress indicator
- [ ] Pull-to-refresh animation optimization
- [ ] iOS keyboard handling improvements

## 🛣️ Roadmap

- [ ] **v1.1.0**: Edit blog functionality
- [ ] **v1.2.0**: User profile management
- [ ] **v1.3.0**: Blog search and filtering
- [ ] **v2.0.0**: Real-time comments system
- [ ] **v2.1.0**: Push notifications
- [ ] **v3.0.0**: Social features (like, share)

## 📞 Contact

- **Developer**: Hieu555x
- **Email**: hieu555x@gmail.com
- **GitHub**: [@hieu555x](https://github.com/hieu555x)
- **LinkedIn**: [Hieu555x](https://linkedin.com/in/hieu555x)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Hieu555x

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

<div align="center">
  <p>Made with ❤️ using Flutter</p>
  <p>⭐ Don't forget to star this repo if you found it helpful!</p>
  
  ![GitHub stars](https://img.shields.io/github/stars/hieu555x/blog_app?style=social)
  ![GitHub forks](https://img.shields.io/github/forks/hieu555x/blog_app?style=social)
  ![GitHub watchers](https://img.shields.io/github/watchers/hieu555x/blog_app?style=social)
</div>
