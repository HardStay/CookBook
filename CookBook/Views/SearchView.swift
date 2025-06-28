import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject var recipesViewModel: RecipesViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom search bar
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                        
                        TextField("Search for recipes", text: $viewModel.searchQuery)
                            .font(.system(size: 16))
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
                
                ScrollView {
                    LazyVStack(spacing: 0) {
                        // Show loading indicator
                        if viewModel.isLoading {
                            ProgressView()
                                .padding(.top, 50)
                        }
                        // Show search results as list
                        else if !viewModel.searchResults.isEmpty {
                            ForEach(viewModel.searchResults) { recipe in
                                NavigationLink(destination: RecipeDetailsView(recipe: recipe)
                                    .environmentObject(recipesViewModel)) {
                                    RecipeRowView(recipe: recipe)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        // Show error message
                        else if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.secondary)
                                .padding(.top, 50)
                        }
                        // Show empty state when no search query or no results
                        else {
                            VStack(spacing: 16) {
                                Image(systemName: "pot")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                                    .padding(.top, 100)
                                
                                VStack(spacing: 8) {
                                    Text("No results")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                    
                                    Text("No search results. Search\nfor something")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(2)
                                }
                            }
                        }
                    }
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                // Configure navigation bar appearance
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor.systemBackground
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
                appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
                
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
            }
        }
    }
    

}

struct RecipeRowView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.title)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(recipe.cuisine)
                        .font(.system(size: 14))
                        .foregroundColor(.pink)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            Divider()
                .padding(.leading, 20)
        }
        .background(Color(.systemBackground))
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(RecipesViewModel())
    }
}
