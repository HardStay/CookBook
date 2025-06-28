import SwiftUI

struct SplashScreenView: View {
    @Binding var isActive: Bool
    @State private var opacity: Double = 1.0
    @State private var scale: CGFloat = 0.8
    
    var body: some View {
        ZStack {
            // Kitchen utensils pattern background
            KitchenUtensilsBackground()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // App icon with orange gradient background
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                
                Spacer()
            }
            .onAppear {
                withAnimation(.easeIn(duration: 0.8)) {
                    self.scale = 1.1
                }
                withAnimation(.easeOut(duration: 0.8).delay(0.8)) {
                    self.scale = 1.0
                }
                // Fade out after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        self.opacity = 0.0
                    }
                }
                // Dismiss splash after animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                    self.isActive = false
                }
            }
        }
    }
}

struct KitchenUtensilsBackground: View {
    var body: some View {
        ZStack {
            // Light cream/beige background
            Color(red: 0.98, green: 0.97, blue: 0.94)
            
            // Kitchen utensils pattern
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 6), spacing: 0) {
                ForEach(0..<120, id: \.self) { index in
                    KitchenUtensilIcon(index: index)
                        .frame(width: 80, height: 80)
                }
            }
            .opacity(0.15)
        }
    }
}

struct KitchenUtensilIcon: View {
    let index: Int
    
    private var iconName: String {
        let icons = [
            "fork.knife", "cup.and.saucer", "wineglass", "takeoutbag.and.cup.and.straw",
            "birthday.cake", "carrot", "leaf", "fish", "drop", "flame"
        ]
        return icons[index % icons.count]
    }
    
    private var rotation: Double {
        Double.random(in: -15...15)
    }
    
    var body: some View {
        Image(systemName: iconName)
            .font(.system(size: 24, weight: .light))
            .foregroundColor(Color.orange.opacity(0.3))
            .rotationEffect(.degrees(rotation))
    }
}

// Custom utensil shapes for more authentic look
struct CustomKitchenPattern: View {
    var body: some View {
        Canvas { context, size in
            let width = size.width
            let height = size.height
            
            // Draw custom kitchen utensils pattern
            context.stroke(
                Path { path in
                    // Fork outline
                    path.move(to: CGPoint(x: 50, y: 50))
                    path.addLine(to: CGPoint(x: 50, y: 150))
                    path.move(to: CGPoint(x: 40, y: 50))
                    path.addLine(to: CGPoint(x: 40, y: 80))
                    path.move(to: CGPoint(x: 60, y: 50))
                    path.addLine(to: CGPoint(x: 60, y: 80))
                    
                    // Spoon outline
                    path.move(to: CGPoint(x: 120, y: 50))
                    path.addEllipse(in: CGRect(x: 110, y: 40, width: 20, height: 30))
                    path.move(to: CGPoint(x: 120, y: 70))
                    path.addLine(to: CGPoint(x: 120, y: 150))
                    
                    // Knife outline
                    path.move(to: CGPoint(x: 200, y: 150))
                    path.addLine(to: CGPoint(x: 200, y: 60))
                    path.addLine(to: CGPoint(x: 190, y: 50))
                    path.addLine(to: CGPoint(x: 200, y: 50))
                },
                with: .color(.orange.opacity(0.2)),
                style: StrokeStyle(lineWidth: 2, lineCap: .round)
            )
        }
        .clipped()
    }
}

// Preview
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView(isActive: .constant(true))
    }
}
