import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(recipe.title)
                .font(.headline)
            
            if !recipe.summary.isEmpty {
                Text(recipe.summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            if let prepTime = recipe.preparationTime {
                Text("Prep: \(prepTime)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

// Simple preview
struct RecipeRowView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeRowView(recipe: Recipe(
            title: "Preview Recipe",
            summary: "Preview summary",
            imageName: "placeholder"
        ))
        .previewLayout(.sizeThatFits)
    }
} 