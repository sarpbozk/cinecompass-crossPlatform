# CineCompass

A Flutter application for browsing movies from The Movie Database (TMDb).

## Features

- Browse trending (top-rated) movies
- Search for movies
- View movie details
- Save favorite movies locally
- Secure API key storage

## App Structure

- **Home Screen:** Displays trending movies and includes a search bar to search for movies
- **Favorites Screen:** Shows the user's saved favorite movies
- **Movie Detail Screen:** Displays detailed information about a selected movie

## Architecture

The app uses a clean architecture approach with BLoC pattern:

- **Models:** Data models for the application using Equatable for proper state comparison
- **Services:** API services for fetching movie data with secure API key storage
- **BLoCs:** State management using BLoC (Business Logic Component) pattern
- **Events:** Events that trigger state changes
- **States:** Immutable states representing the UI state
- **Screens:** UI screens
- **Widgets:** Reusable UI components

## Libraries Used

- **http:** For making API requests
- **flutter_bloc:** For state management
- **equatable:** For value comparison in states
- **shared_preferences:** For local storage of favorites
- **cached_network_image:** For efficient image loading and caching
- **flutter_secure_storage:** For secure storage of API keys

## How to Run

1. Ensure you have Flutter installed on your machine
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application
