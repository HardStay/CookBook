import SwiftUI

struct DecideView: View {
    @StateObject private var viewModel = DecideViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Spacer()

                // Recipe card or placeholder
                if let recipe = viewModel.randomRecipe {
                    NavigationLink(destination: RecipeDetailsView(recipe: recipe)) {
                        VStack(spacing: 0) {
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
                                                .font(.largeTitle)
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
                            .frame(height: 300)
                            .clipped()
                            
                            // Recipe info
                            VStack(alignment: .leading, spacing: 8) {
                                Text(recipe.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.leading)
                                
                                Text(recipe.cuisine)
                                    .font(.subheadline)
                                    .foregroundColor(.pink)
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .background(Color(.systemBackground))
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 20)
                } else {
                    // Placeholder content when no recipe is selected
                    VStack(spacing: 16) {
                        if !viewModel.isLoading {
                            Text("Feeling indecisive?")
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                            Text("Let us pick a recipe for you!")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 40)
                }

                Spacer()

                // Loading indicator or Error message
                if viewModel.isLoading {
                    ProgressView("Finding a recipe...")
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Decide Now Button
                Button(action: {
                    viewModel.fetchRandomRecipe()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "xmark")
                            .font(.headline)
                        Text("Decide Now")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .navigationTitle("Decide")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct DecideView_Previews: PreviewProvider {
    static var previews: some View {
        DecideView()
            .environmentObject(RecipesViewModel())
    }
}
