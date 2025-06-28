import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: RecipesViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0) {
                    let favoriteRecipes = viewModel.recipes.filter { $0.isFavorite }
                    
                    if favoriteRecipes.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "star.slash")
                                .font(.system(size: 50))
                                .foregroundColor(.secondary)
                            
                            Text("No Favorites Yet")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("You can favorite a recipe from its details page.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 100)
                        .padding(.horizontal, 40)
                    } else {
                        ForEach(favoriteRecipes) { recipe in
                            NavigationLink(destination: RecipeDetailsView(recipe: recipe)) {
                                HStack(spacing: 16) {
                                    // Recipe image
                                    AsyncImage(url: URL(string: recipe.imageURL)) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        case .failure:
                                            Rectangle()
                                                .fill(Color(.systemGray5))
                                                .overlay(
                                                    Image(systemName: "photo")
                                                        .foregroundColor(.secondary)
                                                )
                                        case .empty:
                                            Rectangle()
                                                .fill(Color(.systemGray5))
                                                .overlay(ProgressView())
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    
                                    // Recipe info
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(recipe.title)
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                            .multilineTextAlignment(.leading)
                                        
                                        Text(recipe.cuisine)
                                            .font(.subheadline)
                                            .foregroundColor(.pink)
                                            .fontWeight(.medium)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    // Chevron
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Color(.systemBackground))
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Divider between items
                            if recipe.id != favoriteRecipes.last?.id {
                                Divider()
                                    .padding(.leading, 116) // Align with text content
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(RecipesViewModel())
    }
}
