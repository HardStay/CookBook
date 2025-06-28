//
//  ContentView.swift
//  CookBook
//
//  Created by 13 on 09/06/25.
//

import SwiftUI

struct RecipesView: View {
    // Listen to the shared ViewModel from the environment
    @EnvironmentObject var viewModel: RecipesViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Categories")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                // Horizontal scroll for categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.categories) { category in
                            Button(action: {
                                viewModel.selectCategory(category.name)
                            }) {
                                HStack {
                                    Image(systemName: category.iconName)
                                    Text(category.name)
                                }
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(viewModel.selectedCategory == category.name ? Color.orange : Color(.secondarySystemBackground))
                                .foregroundColor(viewModel.selectedCategory == category.name ? .white : .primary)
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)

                Text("All Recipes")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                // Grid for recipes
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible())], spacing: 16) {
                    ForEach(filteredRecipes) { recipe in
                        NavigationLink(destination: RecipeDetailsView(recipe: recipe)) {
                            RecipeCard(recipe: recipe)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Recipes")
    }

    // Computed property to filter recipes based on the selected category
    private var filteredRecipes: [Recipe] {
        if viewModel.selectedCategory.isEmpty {
            return viewModel.recipes
        } else {
            return viewModel.recipes.filter { $0.category == viewModel.selectedCategory }
        }
    }
}

// A view for a single recipe card
struct RecipeCard: View {
    let recipe: Recipe
    @EnvironmentObject var viewModel: RecipesViewModel

    // A computed property to get the real-time favorite status from the view model.
    // This ensures the UI is always in sync with the source of truth in Firestore.
    private var isFavorite: Bool {
        viewModel.recipes.first { $0.id == recipe.id }?.isFavorite ?? false
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                // This container ensures the image is properly framed and clipped, fixing overflow.
                Rectangle()
                    .fill(Color(.secondarySystemBackground))
                    .frame(height: 150)
                    .overlay(
                        AsyncImage(url: URL(string: recipe.imageURL)) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable().scaledToFill()
                            case .failure:
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundColor(.secondary)
                            case .empty:
                                ProgressView()
                            @unknown default:
                                EmptyView()
                            }
                        }
                    )
                .clipped()

                Button(action: {
                    viewModel.toggleFavorite(for: recipe)
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.title3)
                        .padding(8)
                        .background(Color.black.opacity(0.3))
                        .foregroundColor(isFavorite ? .red : .white)
                        .clipShape(Circle())
                }
                .padding(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.cuisine)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)

                Text(recipe.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .frame(minHeight: 40, alignment: .top)
            }
            .padding([.horizontal, .bottom])
            .padding(.top, 8)
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipesView()
                .environmentObject(RecipesViewModel())
        }
    }
}
