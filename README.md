# Movie Rent App

## Overview

The Movie Rent app is a Flutter-based application that allows users to browse, explore, and rent movies. It integrates Firebase for backend services and utilizes the GetX package for state management, routing, and dependency injection. The app supports features like authentication, movie exploration by genre, detailed movie information, user profiles, and a rental system with payment confirmation.

---

## Project Structure

The project follows a modular architecture with clear separation of concerns to improve maintainability and scalability:

- **lib/**
  - **core/**
    - `bindings/` - Dependency injection bindings
    - `constants/` - App-wide constants
    - `enums/` - Enumerations used across the app
    - `helpers/` - Utility classes and functions
    - `middlewares/` - Route middleware implementations
    - `services/` - Base API and Firebase services
    - `states/` - Common app states (loading, error, success)
    - `theme/` - App theming and styling
    - `widgets/` - Reusable UI components
  - **data/**
    - `models/` - Data models for API and Firebase
    - `repositories/` - Data repositories
    - `responses/` - API response models
    - `services/` - Feature-specific API services
  - **modules/**
    - `auth/` - Authentication feature (bindings, controllers, views, widgets)
    - `genre/` - Genre listing and filtering
    - `home/` - Home screen related components
    - `main_navigation/` - Bottom navigation and routing
    - `movie_detail/` - Detailed movie information
    - `movie_explore/` - Movie exploration screens
    - `movie_list/` - Lists of movies by category
    - `profile/` - User profile management
    - `rent/` - Movie rental process
  - **routes/** - App route definitions and navigation

---

## Key Features

- **Authentication:** User login and registration powered by Firebase Authentication.
- **Movie Browsing:** Browse movies by genre, popularity, and recommendations.
- **Movie Details:** Detailed movie information with images, descriptions, and related movies.
- **Rental System:** Rent movies for a configurable duration with real-time price calculation.
- **Payment Confirmation:** Dialog showing available payment methods with details and copy-to-clipboard functionality before confirming rental.
- **Profile Management:** View and update user profile information.
- **Caching:** Uses cached network images for efficient image loading and performance optimization.
- **State Management:** Utilizes GetX for reactive state updates and dependency injection.
- **Modular Architecture:** Clear module separation improves code readability and testability.

---

## Dependencies

- flutter (SDK)
- get: ^4.7.2               # State management, routing, dependency injection
- firebase_core: ^4.0.0     # Core Firebase initialization
- firebase_auth: ^6.0.0     # Firebase Authentication
- cloud_firestore: ^6.0.0   # Firestore database
- cached_network_image: ^3.4.1  # Efficient image caching and loading
- intl: ^0.20.2             # Currency formatting and localization

---

## Getting Started

1. **Clone the repository:**

    `git clone https://github.com/deswinar/movie-rent.git`

2. **Install dependencies:**

    `flutter pub get`

3. **Add environment variables:**

    - Create a `.env` file in the project root by copying `.env.example`.
    - Set your TMDB Bearer Token in `.env` as follows:

4. **Configure Firebase:**

    Follow the Firebase setup guide to add Firebase to your Flutter project and include the necessary configuration files.

5. **Run the app:**

    `flutter run`

---

## Code Style & Guidelines

- Follows Flutter and Dart best practices.
- Uses GetX for state and route management.
- Modular folder structure to separate features.
- Consistent naming conventions and code documentation.

---

## Future Improvements

- Integration of real payment gateways.
- Support for multiple languages.
- Offline mode and data caching improvements.
- User reviews and rating system for movies.
- Push notifications for rental expiration and offers.

---

## License

This project is licensed under the MIT License.


