import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    
    var body: some View {
        HStack(spacing: 15) {
            Image(recipe.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(recipe.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(recipe.summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 8)
    }
} 