# CookBook App - Software Documentation

## Table of Contents
- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Architecture & Implementation Details](#architecture--implementation-details)
  - [Project Structure](#project-structure)
  - [Key Components](#key-components)
  - [Third-Party Services](#third-party-services)
- [Testing Results](#testing-results)
- [User Guide](#user-guide)
  - [Installation](#installation)
  - [App Features](#app-features)
  - [How to Use](#how-to-use)
- [Troubleshooting & FAQ](#troubleshooting--faq)

---

## Overview
CookBook is a modern iOS app built with SwiftUI that helps users discover, search, and manage recipes. It features category browsing, favorites, a random recipe picker, search via TheMealDB API, and recipe details with AdMob monetization. Data is stored in Firebase Firestore, and the app is designed for a beautiful, intuitive user experience.

---

## Tech Stack
- **Language:** Swift 5
- **UI Framework:** SwiftUI
- **Backend/Database:** Firebase Firestore
- **Authentication:** (N/A in current version)
- **APIs:** TheMealDB (for search and random recipes)
- **Ads/Monetization:** Google AdMob (Banner & Interstitial)
- **Dependency Management:** CocoaPods
- **Other:** Combine (for reactive programming), Async/Await (for networking)

---

## Architecture & Implementation Details

### Project Structure
```
CookBook/
  ├── CookBookApp.swift           # App entry point
  ├── Models/                     # Data models (Recipe, Category)
  ├── ViewModels/                 # State management (RecipesViewModel, SearchViewModel, DecideViewModel)
  ├── Services/                   # API and Firestore helpers (APIService, DataSeeder)
  ├── Views/                      # SwiftUI screens and components
  ├── Others/                     # GoogleService-Info.plist, etc.
  ├── Assets.xcassets/            # App icons, images
  ├── Pods/                       # CocoaPods dependencies
  ├── Info.plist                  # App configuration
  └── ...
```

### Key Components
- **Models**
  - `Recipe`: Represents a recipe, including title, image, category, cuisine, ingredients, instructions, and favorite status.
  - `Category`: Represents a recipe category with an icon.

- **ViewModels**
  - `RecipesViewModel`: Handles fetching categories and recipes from Firestore, manages favorites, and category selection.
  - `SearchViewModel`: Handles debounced search queries and results from TheMealDB API.
  - `DecideViewModel`: Fetches a random recipe from TheMealDB API.

- **Services**
  - `APIService`: Handles all networking with TheMealDB API, including search, random, and category-based fetches.
  - `DataSeeder`: Seeds Firestore with initial categories and recipes for development/testing.

- **Views**
  - `RecipesView`: Main screen with category selector and recipe grid.
  - `FavoritesView`: Shows user's favorited recipes.
  - `DecideView`: Lets user get a random recipe from the API.
  - `SearchView`: Search bar and results from TheMealDB API.
  - `RecipeDetailsView`: Shows all details for a recipe, with favorite button and interstitial ad.
  - `InterstitialAd`: Handles loading and presenting AdMob interstitial ads.
  - `SplashScreenView`: Animated splash screen on launch.

- **Ad Integration**
  - AdMob SDK is initialized in `AppDelegate`.
  - Banner ads (if used) are shown via a reusable SwiftUI view.
  - Interstitial ads are shown once per recipe details view appearance.

- **Navigation**
  - Uses `TabView` for main navigation.
  - Each tab is a `NavigationView` for stack-based navigation.

### Third-Party Services
- **Firebase Firestore**: Stores categories, recipes, and favorites. Uses real-time listeners for live updates.
- **TheMealDB API**: Provides search and random recipe data.
- **Google AdMob**: Monetization via banner and interstitial ads.

---

## Testing Results

### Manual Testing
- **App Launch:** Splash screen appears, then main UI loads.
- **Category Browsing:** Categories load from Firestore, recipes filter correctly.
- **Recipe Details:** Tapping a recipe shows details, including image, ingredients, and instructions.
- **Favorites:** Tapping the heart toggles favorite status and updates Firestore. Favorites tab shows correct recipes.
- **Decide Feature:** "Decide Now" fetches a random recipe from TheMealDB and navigates to details.
- **Search:** Typing in the search bar fetches and displays results from TheMealDB API with debounce.
- **AdMob Integration:**
  - Interstitial ad shows once per recipe details view appearance (test ad unit).
  - Ad loads and presents correctly, does not repeat until user navigates away and back.
- **Data Seeding:** On first launch, Firestore is seeded with categories and recipes if empty.
- **UI/UX:** Modern, responsive design with custom icons, gradients, and smooth navigation.

### Device/Simulator Testing
- Tested on iOS Simulator (iPhone 14, iOS 16+)
- Tested on real device (iPhone, iOS 16+)
- All features work as expected; network errors handled gracefully.

### Known Issues
- If network is unavailable, API features and Firestore sync will not work (app handles this gracefully).
- AdMob test ads must be replaced with real ad units for production.
- Analytics is disabled by default for privacy.

---

## User Guide

### Installation
1. **Unzip the Source Code:**
   - Download and unzip the provided `CookBook.zip` file to your desired location.
2. **Open a Terminal and Navigate to the Project:**
   ```sh
   cd /path/to/unzipped/CookBook
   ```
3. **Install dependencies:**
   - Make sure you have [CocoaPods](https://cocoapods.org/) installed.
   ```sh
   pod install
   ```
4. **Open the project in Xcode:**
   - Open `CookBook.xcworkspace` (not `.xcodeproj`) in Xcode.
5. **Configure Firebase:**
   - Ensure `GoogleService-Info.plist` is present in the `Others/` directory (it should be included in the zip).
6. **Build and run:**
   - Select a simulator or device and press Run (⌘R).

### App Features
- **Recipes Tab:**
  - Browse recipes by category.
  - Tap a recipe to view details and mark as favorite.
- **Favorites Tab:**
  - View all your favorited recipes.
- **Decide Tab:**
  - Get a random recipe suggestion from TheMealDB API.
- **Search Tab:**
  - Search for recipes using TheMealDB API.
- **Recipe Details:**
  - View full recipe info, ingredients, and instructions.
  - Favorite/unfavorite recipes.
  - Interstitial ad appears once per view.

### How to Use
1. **Browse Recipes:**
   - Select a category to filter recipes.
   - Tap a recipe card to see details.
2. **Favorite Recipes:**
   - Tap the heart icon on a recipe card or details view.
   - View all favorites in the Favorites tab.
3. **Decide Feature:**
   - Go to the Decide tab and tap "Decide Now" for a random recipe.
4. **Search:**
   - Go to the Search tab and type at least 3 characters to search.
   - Tap a result to view details.
5. **Ads:**
   - Interstitial ad will show once each time you open a recipe details view.

---

## Troubleshooting & FAQ

**Q: The app won't build or run.**
- Make sure you opened `CookBook.xcworkspace` and not `.xcodeproj`.
- Run `pod install` if you see missing dependencies.

**Q: AdMob ads are not showing.**
- Make sure you have a working internet connection.
- Test ads use Google's test ad unit. For production, use your own ad unit IDs.

**Q: Firestore data is missing or not updating.**
- Check your Firebase project and `GoogleService-Info.plist`.
- Make sure you are online.

**Q: How do I reset the seeded data?**
- Delete the app from the simulator/device and reinstall to trigger the seeder.

**Q: Analytics is disabled?**
- Yes, for privacy. You can enable it in `AppDelegate` if needed.

---

## Contact & Support
For questions, issues, or contributions, please contact the project maintainer or open an issue in the repository. 