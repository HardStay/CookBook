import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var searchResults = [Recipe]()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = APIService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Use Combine to debounce search queries
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { !$0.isEmpty && $0.count > 2 } // Only search for queries longer than 2 characters
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }

    func performSearch(query: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let recipes = try await apiService.searchRecipes(query: query)
                self.searchResults = recipes
                if recipes.isEmpty {
                    self.errorMessage = "No recipes found for '\(query)'"
                }
            } catch {
                self.errorMessage = "Failed to search for recipes. Please try again."
                print("Error searching recipes: \(error)")
            }
            isLoading = false
        }
    }
} 