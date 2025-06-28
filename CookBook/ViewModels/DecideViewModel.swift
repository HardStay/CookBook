import Foundation

@MainActor // Ensure UI updates are on the main thread
class DecideViewModel: ObservableObject {
    @Published var randomRecipe: Recipe?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiService = APIService()

    func fetchRandomRecipe() {
        isLoading = true
        errorMessage = nil
        randomRecipe = nil
        
        Task {
            do {
                let recipe = try await apiService.fetchRandomRecipe()
                self.randomRecipe = recipe
            } catch {
                self.errorMessage = "Failed to fetch a recipe. Please try again."
                print("Error fetching random recipe: \(error)")
            }
            isLoading = false
        }
    }
}
