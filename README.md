# 🍳 CookBook - iOS Recipe App

A modern, feature-rich iOS recipe application built with SwiftUI that helps users discover, search, and manage their favorite recipes. CookBook combines local recipe management with external API integration for a comprehensive cooking experience.

![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-4.0-red.svg)
![Firebase](https://img.shields.io/badge/Firebase-10.29.0-yellow.svg)
![CocoaPods](https://img.shields.io/badge/CocoaPods-1.12.0-green.svg)

## 📱 Features

### 🍽️ Recipe Management

- **Browse by Category**: Explore recipes organized by categories (Seafood, Desserts, etc.)
- **Recipe Details**: View comprehensive recipe information including ingredients and step-by-step instructions
- **Favorites System**: Save and manage your favorite recipes with real-time sync
- **Search Functionality**: Search for recipes using TheMealDB API with debounced search

### 🎲 Smart Features

- **Random Recipe Picker**: Can't decide what to cook? Let the app choose for you!
- **Category Filtering**: Filter recipes by cuisine type and category
- **Offline Support**: Browse saved recipes even without internet connection
- **Real-time Sync**: Changes sync instantly across devices via Firebase

### 💰 Monetization

- **AdMob Integration**: Banner and interstitial ads for revenue generation
- **Non-intrusive Ads**: Ads appear naturally without disrupting user experience
- **Configurable Ad Units**: Easy to switch between test and production ads

### 🎨 User Experience

- **Modern UI**: Beautiful SwiftUI interface with custom icons and gradients
- **Smooth Navigation**: Tab-based navigation with stack-based detail views
- **Splash Screen**: Animated launch screen for professional app feel
- **Responsive Design**: Optimized for all iOS devices
- **Dark Mode Support**: Automatic adaptation to system appearance

## 🛠️ Tech Stack

- **Language**: Swift 5
- **UI Framework**: SwiftUI 4.0
- **Backend**: Firebase Firestore
- **Authentication**: Google Sign-In (ready for implementation)
- **External APIs**: TheMealDB API
- **Ads**: Google AdMob SDK
- **Dependency Management**: CocoaPods
- **Architecture**: MVVM with Combine
- **Data Persistence**: Firebase Firestore + Local caching

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Xcode 14.0+** (Latest version recommended)
- **iOS 16.0+** deployment target
- **CocoaPods** (`sudo gem install cocoapods`)
- **Firebase Account** (for backend services)
- **Google AdMob Account** (for monetization)

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/CookBook.git
cd CookBook
```

### 2. Install Dependencies

```bash
pod install
```

### 3. Firebase Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add an iOS app to your Firebase project
3. Download `GoogleService-Info.plist`
4. Place it in the `CookBook/Others/` directory

### 4. AdMob Setup (Optional)

1. Create an AdMob account at [AdMob Console](https://admob.google.com/)
2. Create ad units for banner and interstitial ads
3. Replace test ad unit IDs in the code with your real ad unit IDs

### 5. Open in Xcode

```bash
open CookBook.xcworkspace
```

**Important**: Always open `CookBook.xcworkspace`, not `CookBook.xcodeproj`

### 6. Build and Run

- Select your target device or simulator
- Press `⌘ + R` to build and run the app

## 📱 Usage Guide

### Main Navigation

The app features a tab-based navigation with four main sections:

1. **🍽️ Recipes Tab**

   - Browse recipes by category
   - Tap recipe cards to view details
   - Use category selector to filter recipes

2. **⭐ Favorites Tab**

   - View all your saved favorite recipes
   - Tap to view recipe details
   - Remove from favorites if needed

3. **🎲 Decide Tab**

   - Tap "Decide Now" to get a random recipe suggestion
   - Perfect for when you can't choose what to cook

4. **🔍 Search Tab**
   - Search for recipes using TheMealDB API
   - Type at least 3 characters to start searching
   - View search results with recipe details

### Recipe Management

- **Add to Favorites**: Tap the heart icon on any recipe
- **View Details**: Tap any recipe card to see full information
- **Ingredients & Instructions**: Scroll through detailed cooking steps

## 🏗️ Project Structure

```
CookBook/
├── CookBook/
│   ├── CookBookApp.swift          # App entry point and configuration
│   ├── Models/
│   │   └── Recipe.swift           # Data models (Recipe, Category)
│   ├── ViewModels/
│   │   ├── RecipesViewModel.swift # Main recipe management
│   │   ├── SearchViewModel.swift  # Search functionality
│   │   └── DecideViewModel.swift  # Random recipe picker
│   ├── Services/
│   │   ├── APIService.swift       # TheMealDB API integration
│   │   └── DataSeeder.swift       # Firebase data seeding
│   ├── Views/
│   │   ├── RecipesView.swift      # Main recipes screen
│   │   ├── FavoritesView.swift    # Favorites management
│   │   ├── SearchView.swift       # Search interface
│   │   ├── DecideView.swift       # Random recipe picker
│   │   ├── RecipeDetailsView.swift # Recipe detail screen
│   │   ├── SplashScreenView.swift # Launch screen
│   │   └── InterstitialAd.swift   # Ad integration
│   ├── Assets.xcassets/           # App icons and images
│   └── Others/                    # Configuration files
├── Podfile                        # CocoaPods dependencies
├── .gitignore                     # Git ignore rules
├── build_and_run_ios_sim.sh       # Build script for iOS simulator
└── README.md                      # This file
```

## 🔧 Configuration

### Firebase Configuration

The app uses Firebase Firestore for data storage. Ensure your `GoogleService-Info.plist` is properly configured with:

- Project ID
- Bundle ID matching your Xcode project
- Firestore database rules

### AdMob Configuration

To enable real ads (instead of test ads):

1. Replace test ad unit IDs in `InterstitialAd.swift`
2. Update banner ad unit IDs if using banner ads
3. Test thoroughly before production release

### Build Script

Use the provided build script for quick iOS simulator builds:

```bash
./build_and_run_ios_sim.sh
```

## 🧪 Testing

### Manual Testing Checklist

- [ ] App launches with splash screen
- [ ] Categories load from Firebase
- [ ] Recipe filtering works correctly
- [ ] Favorites system functions properly
- [ ] Search API integration works
- [ ] Random recipe picker functions
- [ ] AdMob integration displays ads
- [ ] Offline functionality works
- [ ] Dark mode adaptation
- [ ] Real-time data sync

### Device Testing

- Tested on iOS Simulator (iPhone 14, iOS 16+)
- Tested on physical devices (iPhone, iOS 16+)
- All features verified working as expected

## 🐛 Troubleshooting

### Common Issues

**Build Errors**

```bash
# If you see missing dependencies
pod install

# If you opened .xcodeproj instead of .xcworkspace
open CookBook.xcworkspace

# Clean build folder if needed
rm -rf build/
```

**Firebase Issues**

- Verify `GoogleService-Info.plist` is in the correct location
- Check Firebase console for proper project setup
- Ensure internet connection for real-time data sync

**AdMob Issues**

- Check internet connection
- Verify ad unit IDs are correct
- Test ads may not show in all regions

**API Issues**

- TheMealDB API requires internet connection
- Search requires minimum 3 characters
- Network errors are handled gracefully

## 📄 License

This project is proprietary software. All rights reserved.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines

- Follow SwiftUI best practices
- Use MVVM architecture pattern
- Add comments for complex logic
- Test on both simulator and device
- Update documentation for new features

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Troubleshooting](#troubleshooting) section
2. Review the project structure and code comments
3. Open an issue in the GitHub repository
4. Contact the project maintainer

## 🙏 Acknowledgments

- **TheMealDB** for providing the recipe API
- **Firebase** for backend services
- **Google AdMob** for monetization platform
- **SwiftUI** community for UI framework
- **CocoaPods** for dependency management

## 📈 Future Enhancements

- [ ] User authentication and profiles
- [ ] Recipe sharing functionality
- [ ] Shopping list generation
- [ ] Nutritional information
- [ ] Recipe ratings and reviews
- [ ] Push notifications
- [ ] Apple Watch companion app

---

**Made with ❤️ using SwiftUI and Firebase**

_Happy Cooking! 🍳_
