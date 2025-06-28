import Foundation

// A service dedicated to communicating with TheMealDB API
class APIService {
    
    // Fetches a single random recipe from the API
    func fetchRandomRecipe() async throws -> Recipe {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/random.php") else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Decode the top-level response
        let decodedResponse = try JSONDecoder().decode(MealDBResponse.self, from: data)
        
        // Get the first meal dictionary, if it exists
        guard let mealDictionary = decodedResponse.meals?.first else {
            throw APIError.noData
        }
        
        // Map the dictionary to our app's Recipe model
        guard let recipe = mapToRecipe(from: mealDictionary) else {
            throw APIError.decodingError
        }
        
        return recipe
    }
    
    // Searches for recipes by a given query string
    func searchRecipes(query: String) async throws -> [Recipe] {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw APIError.invalidURL
        }
        
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=\(encodedQuery)") else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decodedResponse = try JSONDecoder().decode(MealDBResponse.self, from: data)
        
        // The API returns 'null' instead of an empty array if no results are found
        guard let mealDictionaries = decodedResponse.meals else {
            // Return an empty array for no results, which is valid
            return []
        }
        
        // Map all the dictionaries to our Recipe model
        let recipes = mealDictionaries.compactMap { mapToRecipe(from: $0) }
        return recipes
    }
    
    // Fetches all recipes for a specific category (e.g., "Seafood")
    func fetchRecipes(byCategory categoryName: String) async throws -> [Recipe] {
        // Step 1: Fetch the list of meal summaries for the category.
        guard let listURL = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(categoryName)") else {
            throw APIError.invalidURL
        }
        
        let (listData, _) = try await URLSession.shared.data(from: listURL)
        let summaryResponse = try JSONDecoder().decode(MealDBResponse.self, from: listData)
        
        guard let mealSummaries = summaryResponse.meals else { return [] }
        
        // Step 2: Fetch the full details for each meal in parallel.
        // We use a TaskGroup to run multiple network requests concurrently for speed.
        let recipes: [Recipe] = try await withThrowingTaskGroup(of: Recipe.self) { group in
            var collectedRecipes = [Recipe]()
            
            for summary in mealSummaries {
                guard let mealID = summary["idMeal"] as? String else { continue }
                
                group.addTask {
                    guard let detailURL = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)") else {
                        throw APIError.invalidURL
                    }
                    let (detailData, _) = try await URLSession.shared.data(from: detailURL)
                    let detailResponse = try JSONDecoder().decode(MealDBResponse.self, from: detailData)
                    
                    guard let mealDetail = detailResponse.meals?.first,
                          let recipe = self.mapToRecipe(from: mealDetail) else {
                        throw APIError.decodingError
                    }
                    return recipe
                }
            }
            
            // Collect the results from the concurrent tasks as they complete.
            for try await recipe in group {
                collectedRecipes.append(recipe)
            }
            
            return collectedRecipes
        }
        
        return recipes
    }
    
    // Helper function to map a dictionary from the API to our Recipe model
    private func mapToRecipe(from dictionary: [String: String?]) -> Recipe? {
        guard let id = dictionary["idMeal"] as? String,
              let title = dictionary["strMeal"] as? String else {
            return nil
        }
        
        let imageURL = dictionary["strMealThumb"] as? String ?? ""
        let instructions = dictionary["strInstructions"] as? String ?? ""
        let cuisine = dictionary["strArea"] as? String ?? ""
        
        var ingredients: [String] = []
        for i in 1...20 {
            let ingredientKey = "strIngredient\(i)"
            let measureKey = "strMeasure\(i)"
            
            if let ingredient = dictionary[ingredientKey] as? String, !ingredient.isEmpty {
                let measure = dictionary[measureKey] as? String ?? ""
                ingredients.append("\(measure) \(ingredient)".trimmingCharacters(in: .whitespaces))
            }
        }
        
        // We set isFavorite to false by default for API recipes
        return Recipe(id: id, title: title, imageURL: imageURL, category: dictionary["strCategory"] as? String ?? "", cuisine: cuisine, ingredients: ingredients, instructions: instructions, isFavorite: false)
    }
}

// A struct to decode the top-level JSON response from the API
private struct MealDBResponse: Decodable {
    let meals: [[String: String?]]?
}

// Custom errors for our API service
enum APIError: Error {
    case invalidURL
    case decodingError
    case noData
} 