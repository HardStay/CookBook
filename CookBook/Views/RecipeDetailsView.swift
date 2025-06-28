import SwiftUI

struct RecipeDetailsView: View {
    let recipe: Recipe
    @EnvironmentObject var viewModel: RecipesViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var scrollOffset: CGFloat = 0
    @StateObject private var interstitialAd = InterstitialAd()
    @State private var hasShownAd = false
    @State private var shouldShowAdWhenLoaded = false
    
    // A computed property to get the real-time favorite status from the view model.
    private var isFavorite: Bool {
        viewModel.recipes.first { $0.id == recipe.id }?.isFavorite ?? false
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Custom back button overlay
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .padding(.leading, 20)
                    .padding(.top, 50)
                    
                    Spacer()
                }
                Spacer()
            }
            .zIndex(1)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Full-width image at the top
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
                    
                    // Content with rounded top corners overlaying the image
                    VStack(alignment: .leading, spacing: 16) {
                        // Title and cuisine
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
                        .padding(.top, 24)
                        
                        // Ingredients section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Ingredients")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(recipe.ingredients, id: \.self) { ingredient in
                                    Text(ingredient)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        
                        // Instructions section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Instructions")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            Text(recipe.instructions)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineSpacing(4)
                        }
                        
                        Spacer(minLength: 100) // Extra space at bottom for floating button
                    }
                    .padding(.horizontal, 20)
                    .background(Color(.systemBackground))
                    .cornerRadius(16, corners: [.topLeft, .topRight])
                    .offset(y: -16) // Overlap the image slightly
                    .shadow(color: Color.black.opacity(min(0.1 + scrollOffset / 1000, 0.3)), radius: 8, x: 0, y: -2)
                }
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).minY)
                    }
                )
            }
            .coordinateSpace(name: "scroll")
            .onAppear {
                if interstitialAd.isAdLoaded && !hasShownAd {
                    if let rootVC = getRootViewController() {
                        interstitialAd.showAd(from: rootVC)
                        hasShownAd = true
                    }
                } else {
                    shouldShowAdWhenLoaded = true
                }
            }
            .onChange(of: interstitialAd.isAdLoaded) { loaded in
                if loaded, shouldShowAdWhenLoaded, !hasShownAd {
                    if let rootVC = getRootViewController() {
                        interstitialAd.showAd(from: rootVC)
                        hasShownAd = true
                        shouldShowAdWhenLoaded = false
                    }
                }
            }
            
            // Floating heart button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.toggleFavorite(for: recipe)
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(isFavorite ? .red : .gray)
                            .frame(width: 56, height: 56)
                            .background(Color(.systemBackground))
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 2)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 34) // Account for safe area
                }
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .top)
    }
    
    // Helper to get the root view controller
    private func getRootViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = scene.windows.first?.rootViewController else {
            return nil
        }
        return root
    }
}

// Preference key for tracking scroll offset
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct RecipeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRecipe = Recipe(
            id: "S1",
            title: "Baked salmon with fennel & tomatoes",
            imageURL: "",
            category: "Seafood",
            cuisine: "British",
            ingredients: [
                "2 medium Fennel",
                "2 tbs chopped Parsley",
                "Juice of 1 Lemon",
                "175g Cherry Tomatoes",
                "1 tbs Olive Oil",
                "350g Salmon",
                "to serve Black Olives"
            ],
            instructions: "Heat oven to 180C/fan 160C/gas 4. Trim the fronds from the fennel and set aside. Cut the fennel bulbs in half, then cut each half into 3 wedges. Cook in boiling salted water for 10 mins, then drain well. Chop the fennel fronds roughly, then mix with the parsley and lemon zest. Spread the drained fennel over a shallow ovenproof dish, then add the tomatoes. Drizzle with olive oil, then bake for 10 mins. Nestle the salmon among the veg, sprinkle with lemon juice, then bake 15 mins more until the fish is just cooked. Scatter over the parsley and serve.",
            isFavorite: true
        )
        
        NavigationView {
            RecipeDetailsView(recipe: sampleRecipe)
                .environmentObject(RecipesViewModel())
        }
    }
}

// Extension for corner radius on specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
