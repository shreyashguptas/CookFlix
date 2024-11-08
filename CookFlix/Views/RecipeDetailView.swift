import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    // For now, these are hardcoded. Later we can add them to the Recipe model
    let preparationTime = "1 hr"
    let cookingTime = "45 mins"
    let servings = "8"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Recipe Times and Servings
                HStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("Preparation Time: \(preparationTime)")
                            .font(.subheadline)
                        Text("Cooking Time: \(cookingTime)")
                            .font(.subheadline)
                        Text("Servings: \(servings)")
                            .font(.subheadline)
                    }
                }
                .padding(.horizontal)
                
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

// Preview provider for development
struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeDetailView(recipe: Recipe(
                title: "Classic Apple Pie",
                summary: "A delicious homemade apple pie",
                imageName: "pie",
                ingredients: [
                    Ingredient(name: "all-purpose flour", quantity: 2, unit: .cup),
                    Ingredient(name: "unsalted butter", quantity: 0.5, unit: .cup),
                    Ingredient(name: "cold water", quantity: 0.75, unit: .cup)
                ],
                instructions: [
                    "Mix the flour and butter in a bowl until it resembles coarse crumbs.",
                    "Gradually add cold water, mixing until the dough forms.",
                    "Roll out half the dough and fit into a pie plate."
                ]
            ))
        }
    }
} 