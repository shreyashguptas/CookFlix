import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        Text("Detail view for \(recipe.title)")
            .navigationTitle(recipe.title)
    }
} 