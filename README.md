# EmuBot Flutter - AI Assistant App

A modern Flutter application with Firebase integration, featuring authentication, beautiful UI, and proper app architecture.

## ✨ Features

### 🔐 Authentication System
- **Email/Password Authentication** - Secure sign-up and sign-in
- **Google Sign-In** - Quick authentication with Google
- **Password Reset** - Email-based password recovery
- **Email Verification** - Account verification system
- **Profile Management** - Update display name and avatar

### 🎨 Modern UI/UX
- **Splash Screen** - Beautiful animated loading screen
- **Glassmorphism Design** - Modern glass-effect navigation bar
- **Responsive Layout** - Works on all screen sizes
- **Dark/Light Theme** - System-based theme switching with manual override
- **Animated Transitions** - Smooth page transitions and micro-interactions
- **Material Design 3** - Latest Material Design components

### 📱 App Structure
- **Floating Navigation Bar** - Glassmorphic bottom navigation
- **App Drawer** - Side navigation with user profile
- **User Avatar** - Dynamic user avatars with initials fallback
- **Home Dashboard** - Personalized welcome screen with quick actions
- **Theme Store** - BLoC-based theme management with persistence

### 🏗️ Architecture
- **Clean Architecture** - Separation of concerns with layers
- **BLoC State Management** - Reactive state management
- **Repository Pattern** - Data abstraction layer
- **Firebase Integration** - Full Firebase services setup
- **Error Handling** - Comprehensive error handling and logging

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1+)
- Firebase Project with Web support
- Chrome browser for web development

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd emubot_flutter
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Firebase Setup**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Enable Authentication (Email/Password and Google)
   - Enable Firestore Database
   - Enable Firebase Storage
   - Configure web app and download `firebase_options.dart`

4. **Run the app**
```bash
flutter run -d chrome
```

## 📁 Project Structure

```
lib/
├── core/                           # Core functionality
│   ├── config/                     # App configuration
│   ├── layout/                     # App layout widgets
│   │   └── widgets/               # Layout components
│   ├── navigation/                 # Navigation setup
│   ├── services/                  # Firebase and other services
│   ├── theme/                     # Theme configuration
│   │   └── bloc/                  # Theme state management
│   └── utils/                     # Utilities and helpers
├── features/                      # Feature modules
│   ├── auth/                      # Authentication feature
│   │   ├── bloc/                  # Auth state management
│   │   ├── models/                # Auth data models
│   │   ├── pages/                 # Auth screens
│   │   ├── repositories/          # Auth data layer
│   │   └── widgets/               # Auth UI components
│   ├── dashboard/                 # Dashboard feature
│   │   └── pages/                 # Dashboard screens
│   └── splash/                    # Splash screen
│       └── pages/                 # Splash screens
├── firebase_options.dart          # Firebase configuration
└── main.dart                      # App entry point
```

## 🔧 Firebase Configuration

### Services Enabled:
- **Authentication** - Email/Password, Google Sign-In
- **Firestore** - Document database with offline support
- **Storage** - File storage for user uploads
- **Analytics** - User behavior tracking
- **Cloud Functions** - Serverless functions (configured)
- **Realtime Database** - Real-time data sync
- **Cloud Messaging** - Push notifications (with service worker)

### Security Rules:
The app includes secure Firestore and Storage rules configured for user data protection.

## 🎯 Key Features Implemented

### 1. Authentication Flow
- Splash screen with Firebase initialization
- Login/Signup pages with form validation
- Google Sign-In integration
- Password reset functionality
- Email verification
- Automatic navigation based on auth state

### 2. App Layout
- Custom app bar with user avatar
- Sliding drawer with user information
- Glassmorphic floating navigation bar
- Theme switcher with persistence
- Responsive design for all screen sizes

### 3. State Management
- BLoC pattern for auth state
- Cubit for theme management
- Stream-based auth state listening
- Persistent theme storage

### 4. UI/UX Features
- Animated splash screen
- Smooth page transitions
- Loading states and error handling
- Responsive design patterns
- Modern Material Design 3

## 🔒 Security Features
- Secure authentication with Firebase Auth
- Input validation and sanitization
- Error message handling
- Automatic token management
- Secure Firestore rules

## 🌐 Web Support
- Progressive Web App (PWA) ready
- Service worker for Firebase Messaging
- Responsive web design
- Chrome DevTools integration

## 🧪 Testing
The app is built with testability in mind:
- Repository pattern for easy mocking
- BLoC for isolated state testing
- Widget tests for UI components
- Integration tests for user flows

## 📱 Supported Platforms
- ✅ Web (Chrome, Firefox, Safari)
- ✅ Android (with additional setup)
- ✅ iOS (with additional setup)
- ✅ macOS (with additional setup)
- ✅ Windows (with additional setup)

## 🚀 Deployment
Ready for deployment to:
- Firebase Hosting (Web)
- Google Play Store (Android)
- Apple App Store (iOS)
- Microsoft Store (Windows)

## ✅ Fixed Issues

### Firebase Service Worker Issue
- ✅ Created proper `firebase-messaging-sw.js` with correct MIME type
- ✅ Updated `index.html` with Firebase configuration
- ✅ Fixed messaging configuration for web platform
- ✅ Added proper error handling for FCM token retrieval

### Authentication System
- ✅ Complete authentication flow with login/signup
- ✅ Email/password and Google Sign-In integration
- ✅ Profile management and user avatar system
- ✅ Proper navigation after authentication

### App Architecture
- ✅ Clean architecture with BLoC state management
- ✅ Responsive layout with floating navigation
- ✅ Theme management with persistence
- ✅ Beautiful UI with glassmorphism effects

## 🔮 Future Enhancements
- Chat functionality with AI
- Push notifications
- Offline mode
- Multi-language support
- Advanced user settings
- Chat history and favorites
- File upload and sharing

## 🤝 Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support
For support and questions:
- Create an issue in the GitHub repository
- Check the Firebase documentation
- Review Flutter documentation

---

**EmuBot Flutter** - Your AI Assistant, beautifully crafted with Flutter and Firebase! 🤖✨
