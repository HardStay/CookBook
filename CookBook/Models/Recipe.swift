import Foundation

// A struct representing a recipe category
struct Category: Identifiable, Codable {
    var id: String
    var name: String
    var iconName: String // SF Symbol name for the category icon
}

// A struct representing a single recipe
struct Recipe: Identifiable, Codable {
    var id: String
    var title: String
    var imageURL: String
    var category: String // e.g., "Seafood", for filtering
    var cuisine: String // e.g., "British", for display
    var ingredients: [String]
    var instructions: String
    var isFavorite: Bool = false
} 