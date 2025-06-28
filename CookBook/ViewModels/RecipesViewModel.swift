import Foundation
import Combine
import FirebaseFirestore

class RecipesViewModel: ObservableObject {
    @Published var categories = [Category]()
    @Published var recipes = [Recipe]()
    @Published var selectedCategory: String = ""

    private let db = Firestore.firestore()

    init() {
        fetchCategories()
        fetchRecipes()
    }

    func fetchCategories() {
        db.collection("categories").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents in 'categories' collection")
                return
            }

            self.categories = documents.compactMap { queryDocumentSnapshot -> Category? in
                return try? queryDocumentSnapshot.data(as: Category.self)
            }
            
            // Automatically select the first category
            if let firstCategory = self.categories.first {
                self.selectedCategory = firstCategory.name
            }
        }
    }

    func fetchRecipes() {
        db.collection("recipes").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents in 'recipes' collection")
                return
            }

            self.recipes = documents.compactMap { queryDocumentSnapshot -> Recipe? in
                return try? queryDocumentSnapshot.data(as: Recipe.self)
            }
        }
    }

    func selectCategory(_ categoryName: String) {
        selectedCategory = categoryName
    }

    func toggleFavorite(for recipe: Recipe) {
        let recipeRef = db.collection("recipes").document(recipe.id)

        // Check our local array for the most up-to-date favorite status.
        // This is important for recipes coming from the API, which default to `isFavorite: false`.
        let isCurrentlyFavorite = recipes.first { $0.id == recipe.id }?.isFavorite ?? recipe.isFavorite

        // Create a copy of the recipe to save, and toggle its favorite status.
        var recipeToSave = recipe
        recipeToSave.isFavorite = !isCurrentlyFavorite

        do {
            // Use `setData(from:merge:)` to create the document if it's new (from the API)
            // or overwrite/update it if it already exists. This is the key to saving API recipes.
            try recipeRef.setData(from: recipeToSave, merge: true)
            print("Document successfully saved for recipe: \(recipe.id)")
        } catch {
            print("Error saving recipe \(recipe.id) to Firestore: \(error)")
        }
    }
} 