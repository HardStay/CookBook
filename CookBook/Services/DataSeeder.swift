import Foundation
import FirebaseFirestore

// This class is a utility for seeding the Firestore database with initial data.
// It's intended for development purposes to avoid manual data entry.
class DataSeeder {

    private static let db = Firestore.firestore()

    // Checks if the database is empty and seeds it if necessary.
    // This prevents duplicating data on every app launch.
    static func seedDatabaseIfNeeded() async {
        let categoriesCollection = db.collection("categories")

        do {
            let snapshot = try await categoriesCollection.getDocuments()
            guard snapshot.isEmpty else {
                print("Database already contains data. Skipping seed.")
                return
            }
            
            print("Database appears to be empty. Seeding data from API...")
            seedCategories()
            await seedRecipesFromAPI()
            
        } catch {
            print("Error checking for categories: \(error)")
        }
    }

    private static func seedCategories() {
        // These categories are known to work well with TheMealDB API
        let categories: [Category] = [
            Category(id: "C1", name: "Seafood", iconName: "fish.fill"),
            Category(id: "C2", name: "Chicken", iconName: "bird.fill"),
            Category(id: "C3", name: "Dessert", iconName: "birthday.cake.fill"),
            Category(id: "C4", name: "Vegetarian", iconName: "leaf.fill"),
            Category(id: "C5", name: "Pasta", iconName: "line.3.horizontal.decrease.circle.fill")
        ]

        for category in categories {
            do {
                try db.collection("categories").document(category.id).setData(from: category)
            } catch let error {
                print("Error writing category \(category.id) to Firestore: \(error)")
            }
        }
        print("✅ Successfully seeded categories.")
    }

    private static func seedRecipesFromAPI() async {
        let apiService = APIService()
        let categoriesToSeed = ["Seafood", "Chicken", "Dessert", "Vegetarian", "Pasta"]

        print("Fetching recipes from API for seeding...")
        for categoryName in categoriesToSeed {
            do {
                let recipes = try await apiService.fetchRecipes(byCategory: categoryName)
                print("Fetched \(recipes.count) recipes for category '\(categoryName)'.")
                
                for recipe in recipes {
                    // Manually assign the category name since the API response might not be perfect
                    var recipeToSave = recipe
                    recipeToSave.category = categoryName
                    
                    try db.collection("recipes").document(recipe.id).setData(from: recipeToSave)
                }
                print("✅ Successfully seeded recipes for '\(categoryName)'.")
            } catch {
                print("❌ Failed to fetch or seed recipes for category '\(categoryName)': \(error)")
            }
        }
        print("✅ Finished seeding all recipes from API.")
    }
} 