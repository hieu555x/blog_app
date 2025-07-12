# � Blog App

> Một ứng dụng blog đầy đủ tính năng được xây dựng bằng Flutter với Clean Architecture

![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.8.1+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)

## 📋 Mục lục

- [✨ Tính năng](#-tính-năng)
- [🏗️ Kiến trúc](#️-kiến-trúc)
- [🛠️ Tech Stack](#️-tech-stack)
- [📦 Cài đặt](#-cài-đặt)
- [⚙️ Cấu hình](#️-cấu-hình)
- [🚀 Chạy ứng dụng](#-chạy-ứng-dụng)
- [📂 Cấu trúc thư mục](#-cấu-trúc-thư-mục)
- [🔧 API Reference](#-api-reference)
- [🤝 Đóng góp](#-đóng-góp)

## ✨ Tính năng

### 🔐 Authentication
- [x] **Đăng ký tài khoản** với email và mật khẩu
- [x] **Đăng nhập** an toàn
- [x] **Đăng xuất** với confirmation
- [x] **Persistent login** - Tự động đăng nhập khi mở app
- [x] **Session management** với Supabase Auth

### 📝 Blog Management
- [x] **Viết blog mới** với rich text editor
- [x] **Upload ảnh** từ gallery hoặc camera
- [x] **Categorize blogs** với tags/topics
- [x] **Xem danh sách blog** với pagination
- [x] **Đọc blog chi tiết** với reading time calculation
- [x] **Xóa blog** (chỉ tác giả)
- [x] **Offline reading** với local cache

### 🎨 UI/UX Features
- [x] **Dark theme** thiết kế hiện đại
- [x] **Responsive design** cho multiple screen sizes
- [x] **Loading states** và error handling
- [x] **Smooth animations** và transitions
- [x] **User-friendly feedback** với snackbars
- [x] **Clean card-based layout**

### 📱 Technical Features
- [x] **Offline-first approach** với Hive local storage
- [x] **Network connectivity check**
- [x] **Image optimization** và caching
- [x] **State management** với BLoC pattern
- [x] **Dependency injection** với GetIt
- [x] **Error handling** với Either pattern

## 🏗️ Kiến trúc

Ứng dụng được xây dựng theo **Clean Architecture pattern** với 3 layers chính:

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
- ✅ **Separation of Concerns** - Mỗi layer có trách nhiệm riêng biệt
- ✅ **Testability** - Dễ dàng unit test từng component
- ✅ **Maintainability** - Code organized và dễ mở rộng
- ✅ **Scalability** - Thêm features mới không ảnh hưởng code cũ
- ✅ **Independence** - Business logic không phụ thuộc vào framework

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

## 📦 Cài đặt

### **Yêu cầu hệ thống:**
- Flutter SDK 3.8.1 hoặc cao hơn
- Dart SDK 3.8.1 hoặc cao hơn
- Android Studio / VS Code
- Git

### **Clone repository:**
```bash
git clone https://github.com/hieu555x/blog_app.git
cd blog_app
```

### **Cài đặt dependencies:**
```bash
flutter pub get
```

### **Kiểm tra Flutter setup:**
```bash
flutter doctor
```

## ⚙️ Cấu hình

### **1. Supabase Setup**

1. Tạo project mới tại [supabase.com](https://supabase.com)

2. Tạo file `lib/core/secrets/app_secrets.dart`:
```dart
class AppSecrets {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnnonKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

### **2. Database Schema**

Chạy SQL script sau trong Supabase SQL Editor:

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

Trigger function để tự động tạo profile khi user đăng ký:

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

## 🚀 Chạy ứng dụng

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

## 📂 Cấu trúc thư mục

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

*Coming soon...*

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

## 🤝 Đóng góp

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

## 📞 Liên hệ

- **Developer**: Hieu555x
- **Email**: hieu555x@gmail.com
- **GitHub**: [@hieu555x](https://github.com/hieu555x)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">
  <p>Made with ❤️ using Flutter</p>
  <p>⭐ Don't forget to star this repo if you found it helpful!</p>
</div>
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
