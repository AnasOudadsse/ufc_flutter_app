# UFC Flutter App: Codebase Documentation

This document provides a detailed overview of every file in the `lib/` directory of your Flutter project, explaining its purpose, main functionalities, and how it interacts with other files. This is intended to help new developers (or your future self) quickly understand the structure and logic of the app.

---

## main.dart

**Purpose:**  
Entry point of the Flutter app. Sets up the root widget and theme.

**Key Functionality:**
- Runs the app using `runApp`.
- The root widget is `MmaApp`, which sets up the `MaterialApp` with a red theme.
- The home page is set to `GenderSelectionScreen`.

**Interactions:**  
- Imports and displays the main navigation page (`GenderSelectionScreen`).

---

## models/

### favorite_fighter.dart

**Purpose:**  
Defines the data structure for a favorite fighter saved locally.

**Key Functionality:**
- Fields: `id`, `name`, `imgUrl`, `placeOfBirth`.
- Provides `toMap` and `fromMap` for database serialization.

**Interactions:**  
- Used by `FavoritesDb` for local storage.
- Created from `FighterDetail` data in the details screen.

---

### fighter_detail.dart

**Purpose:**  
Represents detailed information about a single fighter.

**Key Functionality:**
- Fields: name, nickname, category, status, wins, losses, draws, age, height, weight, reach, legReach, octagonDebut, placeOfBirth, trainsAt, fightingStyle, imgUrl.
- Factory constructor for parsing from JSON.

**Interactions:**  
- Populated by `ApiService.getFighterDetail`.
- Used in `FighterDetailScreen` to display fighter details and map.

---

### fighter_summary.dart

**Purpose:**  
Minimal info for a fighter in a ranking list.

**Key Functionality:**
- Fields: `id`, `name`.
- Factory constructor for parsing from JSON.

**Interactions:**  
- Used in `Ranking` to represent fighters in a division or ranking.

---

### champion.dart

**Purpose:**  
Represents the champion of a category.

**Key Functionality:**
- Fields: `id`, `championName`.
- Factory constructor for parsing from JSON.

**Interactions:**  
- Used in `Ranking` to show the current champion for a division.

---

### ranking.dart

**Purpose:**  
Represents one MMA ranking category (e.g., "Flyweight", "Men's Pound-for-Pound Top Rank").

**Key Functionality:**
- Fields: `id`, `categoryName`, `champion`, `fighters`.
- Factory constructor for parsing from JSON.

**Interactions:**  
- Used throughout the app to display divisions, rankings, and lists of fighters.

---

## services/

### api_service.dart

**Purpose:**  
Handles all API requests to the Octagon API.

**Key Functionality:**
- `getRankings()`: Fetches all ranking categories.
- `getDivision(divisionId)`: Fetches details for a single division.
- `getFighterDetail(fighterId)`: Fetches detailed info for a single fighter.

**Interactions:**  
- Used by all screens that need to fetch data from the remote API (rankings, divisions, fighter details).

---

### favorites_db.dart

**Purpose:**  
Handles local storage of favorite fighters using SQLite.

**Key Functionality:**
- Singleton pattern for database access.
- Methods: `addFavorite`, `removeFavorite`, `getFavorites`, `isFavorite`.
- Handles database schema and migration (adds `placeOfBirth` column in version 2).

**Interactions:**  
- Used by `FighterDetailScreen` to add/remove/check favorites.
- Used by `FavoritesPage` to list all favorite fighters.

---

## pages/

### gender_selection_screen.dart

**Purpose:**  
Main navigation page with a bottom tab bar for the app's four main sections.

**Key Functionality:**
- BottomNavigationBar with four tabs: Men's Divisions, Women's Divisions, Ranking, Favorites.
- Displays the corresponding page for each tab.

**Interactions:**  
- Navigates to `WeightClassesScreen`, `RankingScreen`, and `FavoritesPage`.

---

### ranking_screen.dart

**Purpose:**  
Displays pound-for-pound rankings for both men and women.

**Key Functionality:**
- Uses a `TabBar` to switch between men's and women's rankings.
- Fetches rankings from the API and displays them in a list.
- Tapping a fighter navigates to their detail screen.

**Interactions:**  
- Uses `ApiService` to fetch rankings.
- Navigates to `FighterDetailScreen` on tap.

---

### weight_classes_screen.dart

**Purpose:**  
Displays a list of weight-class divisions for the selected gender.

**Key Functionality:**
- Fetches all divisions from the API and filters by gender.
- Displays a list of divisions; tapping one navigates to the list of fighters in that division.

**Interactions:**  
- Uses `ApiService` to fetch rankings.
- Navigates to `FighterListScreen` for the selected division.

---

### fighter_list_screen.dart

**Purpose:**  
Displays the list of fighters in a selected division.

**Key Functionality:**
- Fetches division details from the API.
- Displays a list of fighters; tapping one navigates to their detail screen.

**Interactions:**  
- Uses `ApiService` to fetch division data.
- Navigates to `FighterDetailScreen` for the selected fighter.

---

### fighter_detail_screen.dart

**Purpose:**  
Displays detailed information about a single fighter, including a map of their birthplace and favorite functionality.

**Key Functionality:**
- Fetches fighter details from the API.
- Shows fighter stats, image, and birthplace on a map (using OpenStreetMap).
- Allows user to add/remove the fighter as a favorite (with heart icon and status text).
- Uses geocoding to display birthplace on a map.

**Interactions:**  
- Uses `ApiService` to fetch fighter details.
- Uses `FavoritesDb` to manage favorite status.
- Uses `FavoriteFighter` model to store favorite data.

---

### favorites_page.dart

**Purpose:**  
Displays the list of favorite fighters and a map of their birthplaces.

**Key Functionality:**
- Fetches all favorite fighters from local storage.
- Shows a button to toggle a map with markers for each favorite's birthplace (using geocoding).
- Displays geocoding results and errors for debugging.
- Lists all favorite fighters with their images and names.

**Interactions:**  
- Uses `FavoritesDb` to fetch favorite fighters.
- Uses `FavoriteFighter` model for data.
- Uses OpenStreetMap and geocoding for the map.

---

## How the Files Interact

- **main.dart** launches the app and shows `GenderSelectionScreen`.
- **GenderSelectionScreen** provides navigation to all main sections via tabs.
- **ApiService** is the central point for all remote data fetching, used by all screens that need API data.
- **FavoritesDb** is the central point for all local favorite storage, used by the detail and favorites screens.
- **Model files** (`*.dart` in models/) define the data structures used throughout the app.
- **Pages** (`pages/`) are the main UI screens, each responsible for a specific part of the user experience.
- **Navigation** is handled via Flutter's `Navigator` and the bottom tab bar.

---

## Example Data Flow

1. **User selects a division:**  
   - `WeightClassesScreen` → `FighterListScreen` (shows fighters in that division)
2. **User taps a fighter:**  
   - `FighterListScreen` → `FighterDetailScreen` (shows details, can favorite)
3. **User favorites a fighter:**  
   - `FighterDetailScreen` uses `FavoritesDb` to save locally.
4. **User views favorites:**  
   - `FavoritesPage` shows all favorites and their birthplaces on a map.

--- 