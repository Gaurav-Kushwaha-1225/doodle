# Doodle Tracker

## Overview
A Habit Tracking Mobile App built with Flutter that helps users track their habits by dynamically adding them with a maximum limit of 5 habits. The app provides functionalities for users to create and manage habits with login using phone number authentication.

## Features
- **User Authentication**: Secure login and registration system using Firebase Phone Number Authentication
- **Habit Management**: Create, edit, mark done, and delete your habits (max 5 habits)
- **7 Day Streak**: Keep tracking habits and maintain your weekly streak
- **Progress Tracking**: Visual representation of habit completion rates

## Technologies Used
- **Frontend**: Flutter, Dart
- **Backend**: Firebase (Authentication, Firestore)
- **State Management**: BLoC with Clean Architecture
- **UI Components**: Material Design 3

## Architecture
The app follows a clean architecture pattern with clear separation of concerns:

1. **Presentation Layer**: 
   - UI components, screens, and widgets
   - Material Design 3 components
   - Responsive layouts

2. **Business Logic Layer**: 
   - Providers for state management
   - Habit tracking logic
   - Streak calculation

3. **Data Layer**: 
   - Firebase repositories
   - Local storage handlers
   - Data synchronization

4. **Domain Layer**: 
   - Habit models
   - User models
   - Business rules

## Installation

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Firebase account

### Steps
1. Clone the repository:
2. Navigate to the project directory:
3. Install dependencies:
4. Configure Firebase:
   - Create a new Firebase project
   - Add Android and iOS apps to your Firebase project
   - Download and add the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to your project
   - Enable Phone Authentication and Firestore services

5. Run the app:

## Project Structure
```
lib/
  ├── main.dart
  ├── utils/
  │   ├── constants.dart
  │   ├── theme.dart
  ├── features/ (for every screen)
  |   ├── data/
  |   │   ├── models/
  |   │   ├── repo_impl/
  |   │   └── sources/
  |   ├── domain/
  |   │   ├── repo/
  |   │   ├── entities/
  |   │   └── usecases/
  |   ├── presentation/
  |   │   ├── bloc/
  |   │   ├── screens/
  |   │   └── widgets/
  └── config/
      └── routes.dart
```

## API Documentation
The app interacts with the following Firebase APIs:

1. **Firebase Phone Auth API**: For user authentication
2. **Firebase Firestore API**: For storing and retrieving habit data
3. **Firebase Analytics API**: For tracking app usage and user engagement

## Database Schema
The app uses Firestore with the following collections:

1. **Users**:
   ```
   {
     uid: String,
     phoneNumber: String,
   }
   ```

2. **Habits**:
   ```
   {
     id: String,
     userId: String,
     name: String,
     updatedAt: Timestamp,
   }
   ```

## Screenshots


## APK Download


## AI Tools Usage

### AI Tools Used
- **ChatGPT**: Helped with debugging
- **Claude**: Utilized for code review, documentation, and firebase, chatgpt

### Problems Solved with AI
1. **Firebase Integration**:
   - Setting up Phone Authentication flow
   - Structuring Firestore database schema
2. Generating template from clean architecture blog.

### Helpful Prompts
1. Firebase auth using mobile no - Give the process and all functionalities for a Flutter app use https://dev.to/princetomarappdev/clean-code-architecture-and-bloc-in-flutter-a-comprehensive-guide-for-beginners-and-experts-33k8 link for code structure that uses clean code architecture and BLoC
2. Dont use the dependecy injection use bloc provider and bloc repository provider multi ones in main.dart
3. Give me firebase commands for setting up project and checking current account

## License
This project is licensed under the MIT License - see the LICENSE file for details.