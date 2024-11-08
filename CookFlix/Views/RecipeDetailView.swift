import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Recipe Times and Servings
                if recipe.preparationTime != nil || recipe.cookingTime != nil || recipe.servings != nil {
                    HStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            if let prepTime = recipe.preparationTime {
                                Text("Preparation Time: \(prepTime)")
                                    .font(.subheadline)
                            }
                            if let cookTime = recipe.cookingTime {
                                Text("Cooking Time: \(cookTime)")
                                    .font(.subheadline)
                            }
                            if let servings = recipe.servings {
                                Text("Servings: \(servings)")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Ingredients Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Ingredients:")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if let ingredients = recipe.ingredients {
                        ForEach(ingredients) { ingredient in
                            Text("\(ingredient.quantity) \(ingredient.unit.rawValue) \(ingredient.name)")
                                .font(.body)
                        }
                    } else {
                        Text("No ingredients listed")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                // Instructions Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Instructions:")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if let instructions = recipe.instructions {
                        ForEach(Array(instructions.enumerated()), id: \.offset) { index, instruction in
                            HStack(alignment: .top) {
                                Text("\(index + 1).")
                                    .fontWeight(.bold)
                                    .frame(width: 25, alignment: .leading)
                                Text(instruction)
                            }
                            .padding(.vertical, 4)
                        }
                    } else {
                        Text("No instructions listed")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(recipe.title)
    }
}

// Simple preview without mock data
struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeDetailView(recipe: Recipe(
                title: "Preview Recipe",
                summary: "Preview summary",
                imageName: "placeholder"
            ))
        }
    }
} 