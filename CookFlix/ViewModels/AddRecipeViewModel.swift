import Foundation

class AddRecipeViewModel: ObservableObject {
    @Published var title = ""
    @Published var summary = ""
    @Published var ingredients: [Ingredient] = []
    @Published var instructions: [String] = []
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
        // TODO: Implement save functionality
    }
} 