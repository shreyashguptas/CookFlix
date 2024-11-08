import Foundation

class AddRecipeViewModel: ObservableObject {
    @Published var title = ""
    @Published var summary = ""
    @Published var ingredients: [Ingredient] = []
    @Published var instructions: [String] = []
    @Published var preparationTime = ""
    @Published var cookingTime = ""
    @Published var servings = ""
    
    @Published var newIngredientName = ""
    @Published var newIngredientQuantity = ""
    @Published var newIngredientUnit = MeasurementUnit.cup
    @Published var newInstruction = ""
    
    func addIngredient() {
        if let quantity = Double(newIngredientQuantity), !newIngredientName.isEmpty {
            ingredients.append(Ingredient(name: newIngredientName,
                                       quantity: quantity,
                                       unit: newIngredientUnit))
            newIngredientName = ""
            newIngredientQuantity = ""
        }
    }
    
    func addInstruction() {
        if !newInstruction.isEmpty {
            instructions.append(newInstruction)
            newInstruction = ""
        }
    }
    
    func saveRecipe() {
        let recipe = Recipe(
            title: title,
            summary: summary,
            imageName: "placeholder", // You'll need to handle image saving
            ingredients: ingredients,
            instructions: instructions,
            preparationTime: preparationTime,
            cookingTime: cookingTime,
            servings: servings
        )
        // TODO: Save the recipe to your data store
    }
} 