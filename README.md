# EmuBot Android App

A modern Android application built with Kotlin featuring a beautiful glassmorphism authentication interface and advanced development practices.

## 🎨 Features

### Authentication System
- **Modern Glassmorphism UI** - Semi-transparent cards with elegant animations
- **Welcome Screen** - Engaging entry point with smooth transitions  
- **Login Interface** - Clean, validated login form with real-time feedback
- **Signup Interface** - Comprehensive registration with password confirmation
- **Smooth Animations** - Fluid transitions and interactive feedback throughout

### Visual Design
- **Glass Effects** - Semi-transparent backgrounds with subtle borders
- **Gradient Backgrounds** - Beautiful color transitions (Purple/Blue, Pink/Red)
- **Material Design 3** - Latest Material Components with custom theming
- **Responsive Layout** - Optimized for different screen sizes and orientations

## 🚀 Quick Start

### Prerequisites
- Java 17 (OpenJDK) - Installed via Scoop
- Android SDK - Located at `C:\Users\athar\AppData\Local\Android\Sdk`

### Environment Setup
1. Run the setup script to configure environment variables:
   ```batch
   setup_env.bat
   ```

### Building the Project
```bash
# Debug build (recommended for development)
gradlew assembleDebug

# Full build (requires internet connection)
gradlew build

# Clean build
gradlew clean

# Run tests
gradlew test

# See all available tasks
gradlew tasks
```

## 📱 App Flow

1. **Welcome Screen** - Entry point with "Login" and "Create Account" options
2. **Login/Signup** - Modern authentication forms with validation
3. **Main App** - Navigate to main application features

## 🏗️ Project Structure

```
app/
├── src/main/
│   ├── java/com/example/emubot/
│   │   ├── auth/              # Authentication activities
│   │   │   ├── WelcomeActivity.kt
│   │   │   ├── LoginActivity.kt
│   │   │   └── SignupActivity.kt
│   │   └── MainActivity.kt     # Main app interface
│   ├── res/
│   │   ├── drawable/          # Glass effects & gradients
│   │   ├── layout/            # Modern UI layouts
│   │   ├── values/            # Colors, themes, styles
│   │   └── anim/              # Transition animations
│   └── AndroidManifest.xml
```

### Package Details
- **Package**: `com.example.emubot`
- **Min SDK**: Android 7.0 (API 24)
- **Target SDK**: Android 14 (API 36)

## 🎨 UI System

### Glass Morphism Theme
- **Primary**: #6C63FF (Vibrant Purple)
- **Secondary**: #FF6B9D (Elegant Pink) 
- **Accent**: #4ECDC4 (Soft Teal)
- **Glass Effects**: Semi-transparent overlays with borders

### Modern Features
- View Binding enabled for type-safe view access
- Navigation Component for seamless screen transitions
- AndroidX libraries for modern Android development
- Material Design components with custom glass styling
- Lifecycle-aware components (ViewModel, LiveData)

### Animations
- **Entrance**: Staggered fade-in animations
- **Interactions**: Scale feedback on button presses
- **Validation**: Shake animations for form errors  
- **Success**: Pulse animations for completion states

## 🛠️ Development

The project is configured with:
- **Kotlin** as the primary language
- **Android Gradle Plugin** 8.13.0
- **Gradle** 8.13
- **Java 11** compatibility (source/target)
- **Additional Libraries**: Lottie animations, Blur effects

### Dependencies
```kotlin
// Core Android
implementation(libs.androidx.core.ktx)
implementation(libs.androidx.appcompat)
implementation(libs.material)

// UI & Navigation  
implementation(libs.androidx.constraintlayout)
implementation(libs.androidx.navigation.fragment.ktx)
implementation(libs.androidx.navigation.ui.ktx)

// Animations & Effects
implementation(libs.lottie)
implementation(libs.blurry)

// Architecture
implementation(libs.androidx.lifecycle.livedata.ktx)
implementation(libs.androidx.lifecycle.viewmodel.ktx)
```

## 📚 Documentation

- **[UI Guide](UI_GUIDE.md)** - Comprehensive glassmorphism UI documentation
- **[Setup Guide](setup_env.bat)** - Environment configuration script

## 🎯 Key Features

### Real-time Validation
- Email format validation with visual feedback
- Password strength requirements with instant checking
- Confirmation password matching with error states
- Animated error states with shake feedback

### Smooth User Experience  
- Transparent status bars for immersive experience
- Keyboard-aware layout adjustments
- Loading states with progress indicators
- Success animations on form completion

### Modern Architecture
- Activity-based navigation with proper lifecycle management
- View binding for type-safe UI interactions
- Material Design theming with custom glass components
- Responsive design adapting to different screen sizes

## 🔧 Troubleshooting

- **Network Issues**: Try building debug only: `gradlew assembleDebug`
- **SDK Problems**: Ensure Android SDK is properly installed and ANDROID_HOME is set
- **Java Issues**: Verify Java 17 installation and JAVA_HOME configuration
- **Build Errors**: Clean project first: `gradlew clean assembleDebug`

## 🎨 Customization

The glassmorphism theme can be customized by modifying:
- **Colors**: Edit `values/colors.xml` for theme colors
- **Gradients**: Modify drawable resources for background effects  
- **Animations**: Adjust timing in activity files
- **Glass Effects**: Change transparency levels in drawable files

## 🚀 Future Enhancements

- **Biometric Authentication**: Fingerprint and face recognition
- **Advanced Animations**: Complex Lottie-based transitions
- **Dark Theme**: Complete dark mode implementation
- **Custom Themes**: User-selectable color palettes
- **Performance**: Optimized rendering and memory usage

---

**EmuBot** - Where modern design meets functional excellence! 🎯✨