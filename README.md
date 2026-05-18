# SME360

A cross-platform Flutter application built for small and medium-sized enterprises (SMEs) to manage and monitor their business operations — including revenue analytics, inventory, marketing, and AI-powered insights — all secured behind Firebase Authentication.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Screenshots](#screenshots)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Firebase Setup](#firebase-setup)
  - [Running the App](#running-the-app)
- [Authentication](#authentication)
  - [Google Sign-In (SHA-1 Required)](#google-sign-in-sha-1-required)
  - [Apple Sign-In](#apple-sign-in)
  - [Anonymous / Guest Sign-In](#anonymous--guest-sign-in)
- [Architecture](#architecture)
- [Theme & Design System](#theme--design-system)
- [Dependencies](#dependencies)
- [Contributing](#contributing)

---

## Overview

SME360 gives business owners a single, mobile-first dashboard to track KPIs, revenue trends, inventory health, marketing performance, and receive AI-generated business insights — all in real time via Firebase.

---

## Features

| Area | Highlights |
|---|---|
| **Authentication** | Email/password, Google, Apple, Anonymous (guest) sign-in via Firebase Auth |
| **Dashboard** | KPI grid, health score widget, revenue chart, pull-to-refresh |
| **Inventory** | Stock overview and management |
| **Business Intelligence** | Data-driven BI screen |
| **Marketing** | Campaign and marketing overview |
| **AI Insights** | AI-generated business insight cards |
| **Account** | Profile header, settings sections, sign-out |
| **Responsive Layout** | Bottom nav on phones, navigation rail on tablets (≥ 600 px) |
| **Theming** | Material 3, light + dark themes, Plus Jakarta Sans typography |

---

## Screenshots

> _Add screenshots here after building the app._

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.35+ / Dart 3.9+ |
| Backend / Auth | Firebase (Authentication, Firestore) |
| State | `setState` / service singletons |
| Navigation | Named routes (`Map<String, WidgetBuilder>`) |
| Charts | `fl_chart` |
| HTTP | `dio` |
| Local storage | `shared_preferences` |
| Responsive layout | `sizer` |
| Typography | `google_fonts` (Plus Jakarta Sans) |
| Images | `cached_network_image`, `flutter_svg` |

---

## Project Structure

```
lib/
├── core/
│   ├── app_export.dart              # Barrel export (theme, routes, widgets)
│   └── services/
│       └── firebase_auth_service.dart  # Auth singleton (all sign-in methods)
├── main.dart                        # App entry point, Firebase init
├── routes/
│   └── app_routes.dart              # Named route definitions
├── theme/
│   └── app_theme.dart               # Material 3 light/dark theme + design tokens
├── widgets/                         # Shared/reusable widgets
│   ├── app_navigation.dart
│   ├── custom_error_widget.dart
│   ├── custom_icon_widget.dart
│   ├── custom_image_widget.dart
│   ├── empty_state_widget.dart
│   ├── loading_skeleton_widget.dart
│   └── status_badge_widget.dart
└── presentation/
    ├── login_screen/                # Sign-in UI
    ├── dashboard_screen/            # Main tab shell + home dashboard
    ├── inventory_screen/
    ├── business_intelligence_screen/
    ├── marketing_screen/
    ├── ai_insights_screen/
    ├── insights_screen/
    └── account_screen/
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) **3.35+**
- [Dart SDK](https://dart.dev/get-dart) **3.9+**
- [Android Studio](https://developer.android.com/studio) or Xcode (for iOS)
- A [Firebase project](https://console.firebase.google.com)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/MinaEwedaa/SME360.git
cd SME360

# 2. Install Flutter dependencies
flutter pub get
```

### Firebase Setup

This project uses Firebase. The `android/app/google-services.json` file is included in the repo (contains only restricted client configuration — no server secrets).

**If you want to connect your own Firebase project:**

1. Create a new Firebase project at [console.firebase.google.com](https://console.firebase.google.com).
2. Register your Android app with package name `com.example.sme360`.
3. Download `google-services.json` and replace `android/app/google-services.json`.
4. For iOS, download `GoogleService-Info.plist` and add it to `ios/Runner/`.
5. Enable **Email/Password**, **Google**, **Apple**, and **Anonymous** sign-in providers in Firebase console under **Authentication → Sign-in method**.

### Running the App

```bash
# Run on connected device or emulator
flutter run

# Run in release mode
flutter run --release

# Build APK
flutter build apk

# Build iOS (macOS required)
flutter build ios
```

---

## Authentication

All authentication is handled by `lib/core/services/firebase_auth_service.dart` — a singleton that wraps `FirebaseAuth`.

### Google Sign-In (SHA-1 Required)

Google Sign-In on Android requires your app's **SHA-1 fingerprint** to be registered in Firebase console, otherwise `GoogleSignIn` cannot obtain an ID token.

**Step 1 — Get your debug SHA-1 (run once):**

```powershell
# Windows
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

```bash
# macOS / Linux
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Copy the `SHA1:` line from the output.

**Step 2 — Register in Firebase:**

1. Go to **Firebase console** → your project → **Project settings** (gear icon).
2. Scroll to **Your apps** → click your Android app.
3. Click **Add fingerprint**, paste the SHA1 value → **Save**.
4. Download the updated `google-services.json` and replace `android/app/google-services.json`.

> For production builds you'll need to repeat with your **release keystore** SHA-1.

### Apple Sign-In

Apple Sign-In is implemented using the `sign_in_with_apple` package with a secure nonce (required by Firebase).

**Android** — works out of the box via a web OAuth flow.

**iOS** — requires one additional step in Xcode:
1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select the **Runner** target → **Signing & Capabilities**.
3. Click **+ Capability** and add **Sign In with Apple**.

Then add the reversed client ID URL scheme to `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.googleusercontent.apps.367305310719-rghobn79jkk2fbdbl6rp5774fvrohuod</string>
    </array>
  </dict>
</array>
```

### Anonymous / Guest Sign-In

Allows users to explore the app without creating an account. Firebase creates a temporary anonymous account which can later be upgraded to a permanent one.

Make sure **Anonymous** is enabled in **Firebase console → Authentication → Sign-in method**.

---

## Architecture

The app follows a **feature-first, layered** structure:

```
Presentation  →  Services  →  Firebase SDK
(screens/widgets)  (FirebaseAuthService)  (FirebaseAuth, Firestore)
```

- **No external state management library** — uses `setState` and service singletons.
- **Named routes** map screen names to widget builders (`app_routes.dart`).
- **`FirebaseAuthService`** is a singleton accessed directly in widgets — swap it for a provider/bloc wrapper as the app grows.
- **Responsive shell** — `DashboardScreen` detects screen width and switches between `BottomNavigationBar` (mobile) and `NavigationRail` (tablet).

---

## Theme & Design System

Defined in `lib/theme/app_theme.dart` using **Material 3**.

| Token | Value |
|---|---|
| Primary | `#0097A7` (teal/cyan) |
| Primary Dark | `#006978` |
| Secondary | `#1565C0` (blue) |
| Background | `#F0F4F8` |
| Surface | `#FFFFFF` |
| Error | `#D32F2F` |
| Font | Plus Jakarta Sans (via `google_fonts`) |

Both **light** and **dark** color schemes are defined. The app defaults to light mode (`ThemeMode.light`).

---

## Dependencies

| Package | Version | Purpose |
|---|---|---|
| `firebase_core` | `^3.6.0` | Firebase initialization |
| `firebase_auth` | `^5.3.1` | Authentication |
| `cloud_firestore` | `^5.4.4` | NoSQL cloud database |
| `google_sign_in` | `^6.2.1` | Google OAuth |
| `sign_in_with_apple` | `^6.1.0` | Apple Sign-In |
| `crypto` | `^3.0.3` | Nonce hashing for Apple Sign-In |
| `sizer` | `^2.0.15` | Responsive sizing |
| `flutter_svg` | `^2.0.9` | SVG rendering |
| `google_fonts` | `^6.1.0` | Plus Jakarta Sans font |
| `shared_preferences` | `^2.2.2` | Key-value local storage |
| `cached_network_image` | `^3.3.1` | Network image caching |
| `connectivity_plus` | `^6.1.4` | Network connectivity checks |
| `dio` | `^5.4.0` | HTTP client |
| `fluttertoast` | `^8.2.4` | Toast notifications |
| `fl_chart` | `^0.65.0` | Charts and graphs |

---

## Contributing

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/your-feature`.
3. Commit your changes: `git commit -m "add: your feature"`.
4. Push to the branch: `git push origin feature/your-feature`.
5. Open a Pull Request.

---

> Built with Flutter & Firebase · SME360 © 2026
#   S M E 3 6 0  
 