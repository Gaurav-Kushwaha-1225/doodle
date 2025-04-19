# Doodle Tracker

## Overview
A Habbit Tracking Mobile App, built with Flutter that helps users track their habbits by dynamically adding them with a maximum limit of 5 habbits. The app provides functionalities for users to create and manage habbits with login using phone no.

## Features
- **User Authentication**: Secure login and registration system using Firebase Authentication using Phone No.
- **Habbit Management**: Create, mark done, and delete your habbits
- **7 Day Streak**: Kepp tracking habbits and maintain your streak

## Technologies Used
- **Frontend**: Flutter, Dart
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **State Management**: Provider/Bloc Pattern
- **Local Storage**: SQLite/Hive for offline data
- **Maps Integration**: Google Maps API
- **UI Components**: Material Design

## Architecture
The app follows a clean architecture pattern with clear separation of concerns:

1. **Presentation Layer**: UI components, widgets, and screens
2. **Business Logic Layer**: Providers/BLoCs for state management
3. **Data Layer**: Repositories for data handling
4. **Domain Layer**: Models and use cases

## Installation

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Firebase account

### Steps
1. Clone the repository:
   ```
   git clone https://github.com/yourusername/travel-tracking-app.git
   ```

2. Navigate to the project directory:
   ```
   cd travel-tracking-app
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Configure Firebase:
   - Create a new Firebase project
   - Add Android and iOS apps to your Firebase project
   - Download and add the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to your project
   - Enable Authentication, Firestore, and Storage services

5. Run the app:
   ```
   flutter run
   ```

## Project Structure
```
lib/
  ├── main.dart
  ├── core/
  │   ├── constants/
  │   ├── errors/
  │   ├── utils/
  │   └── widgets/
  ├── data/
  │   ├── models/
  │   ├── repositories/
  │   └── sources/
  ├── domain/
  │   ├── entities/
  │   └── usecases/
  ├── presentation/
  │   ├── providers/
  │   ├── screens/
  │   └── widgets/
  └── services/
      ├── auth_service.dart
      ├── database_service.dart
      └── storage_service.dart
```

## API Documentation
The app interacts with the following APIs:

1. **Firebase Authentication API**: For user management
2. **Firebase Firestore API**: For storing and retrieving trip data
3. **Firebase Storage API**: For storing images
4. **Google Maps API**: For location services and map display

## Database Schema
The app uses Firestore with the following collections:

1. **Users**:
   ```
   {
     uid: String,
     email: String,
     displayName: String,
     photoURL: String,
     createdAt: Timestamp
   }
   ```

2. **Trips**:
   ```
   {
     id: String,
     userId: String,
     title: String,
     destination: String,
     startDate: Timestamp,
     endDate: Timestamp,
     budget: Double,
     description: String,
     coverImage: String,
     createdAt: Timestamp,
     updatedAt: Timestamp
   }
   ```

3. **Expenses**:
   ```
   {
     id: String,
     tripId: String,
     amount: Double,
     category: String,
     date: Timestamp,
     description: String,
     currency: String,
     attachment: String
   }
   ```

4. **Itineraries**:
   ```
   {
     id: String,
     tripId: String,
     day: Integer,
     date: Timestamp,
     activities: Array<Activity>
   }
   ```

5. **Photos**:
   ```
   {
     id: String,
     tripId: String,
     url: String,
     caption: String,
     location: GeoPoint,
     takenAt: Timestamp,
     uploadedAt: Timestamp
   }
   ```

## Code Examples

### Authentication Service
```dart
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }
  
  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
```

### Trip Repository
```dart
class TripRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'trips';
  
  // Add a new trip
  Future<void> addTrip(TripModel trip) async {
    try {
      await _firestore.collection(_collection).add(trip.toJson());
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
  
  // Get all trips for a user
  Stream<List<TripModel>> getUserTrips(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TripModel.fromJson(doc.data(), doc.id))
            .toList());
  }
  
  // Update trip details
  Future<void> updateTrip(String tripId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc(tripId).update(data);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
```

## Testing
The app includes various types of tests to ensure reliability:

### Unit Tests
Test individual functions and methods for correctness.

### Widget Tests
Test UI components in isolation.

### Integration Tests
Test interactions between different parts of the app.

To run the tests:
```
flutter test
```

## Screenshots

[This section is intentionally left empty for you to add screenshots]

## APK Download

[This section is intentionally left empty for you to add APK information]

## Future Enhancements
- **Social Features**: Share trips with friends and family
- **Weather Integration**: Show weather forecasts for destinations
- **Currency Conversion**: Real-time currency conversion for expenses
- **Public Transportation**: Integration with public transportation APIs
- **Language Translation**: Built-in translation for international travel
- **Travel Recommendations**: AI-powered recommendations based on user preferences
- **Augmented Reality**: AR features for exploring destinations

## Contributors
- [Your Name]
- [Team Member 1]
- [Team Member 2]

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements
- Flutter and Dart teams for the amazing framework