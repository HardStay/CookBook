//
//  CookBookApp.swift
//  CookBook
//
//  Created by 13 on 09/06/25.
//

import SwiftUI
import FirebaseCore
import GoogleMobileAds
import FirebaseAnalytics


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    Analytics.setAnalyticsCollectionEnabled(false)
    
    // Run the data seeder asynchronously
    Task {
        await DataSeeder.seedDatabaseIfNeeded()
    }

    // Initialize the Google Mobile Ads SDK
    GADMobileAds.sharedInstance().start(completionHandler: nil)
    
    // Configure tab bar appearance
    configureTabBarAppearance()

    return true
  }
  
  private func configureTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor.systemBackground // White background
    
    // Configure normal state (unselected)
    appearance.stackedLayoutAppearance.normal.iconColor = UIColor.systemGray
    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
      .foregroundColor: UIColor.systemGray
    ]
    
    // Configure selected state
    appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemBlue
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
      .foregroundColor: UIColor.systemBlue
    ]
    
    UITabBar.appearance().standardAppearance = appearance
    if #available(iOS 15.0, *) {
      UITabBar.appearance().scrollEdgeAppearance = appearance
    }
  }
}

@main
struct CookBookApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  // Create a single instance of the ViewModel and pass it to the views
  @StateObject private var recipesViewModel = RecipesViewModel()
  @State private var showSplash = true

  var body: some Scene {
    WindowGroup {
      ZStack {
        if showSplash {
          SplashScreenView(isActive: $showSplash)
        } else {
          TabView {
            // Recipes Tab
            NavigationView {
              RecipesView()
            }
            .tabItem {
              Label("Recipes", systemImage: "fork.knife")
            }

            // Favorites Tab
            FavoritesView()
              .tabItem {
                Label("Favorites", systemImage: "star")
              }
            
            // Decide Tab
            DecideView()
              .tabItem {
                Label("Decide", systemImage: "shuffle")
              }
            
            // Search Tab
            SearchView()
              .tabItem {
                Label("Search", systemImage: "magnifyingglass")
              }
          }
          .environmentObject(recipesViewModel) // Provide the ViewModel to all tabs
        }
      }
    }
  }
}
