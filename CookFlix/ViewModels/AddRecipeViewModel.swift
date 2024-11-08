import Foundation

@MainActor
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
    
    private var recipeListViewModel: RecipeListViewModel
    
    var isValid: Bool {
        !title.isEmpty && !summary.isEmpty
    }
    
    init(recipeListViewModel: RecipeListViewModel) {
        self.recipeListViewModel = recipeListViewModel
    }
    
    func addIngredient() {
        if let quantity = Double(newIngredientQuantity), !newIngredientName.isEmpty {
            ingredients.append(Ingredient(name: newIngredientName,
                                       quantity: quantity,
                                       unit: newIngredientUnit))
            newIngredientName = ""
            newIngredientQuantity = ""
        }
    }
    
    func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }
    
    func addInstruction() {
        if !newInstruction.isEmpty {
            instructions.append(newInstruction)
            newInstruction = ""
        }
    }
    
    func deleteInstruction(at offsets: IndexSet) {
        instructions.remove(atOffsets: offsets)
    }
    
    func saveRecipe() async {
        let recipe = Recipe(
            title: title,
            summary: summary,
            imageName: "placeholder",
            ingredients: ingredients,
            instructions: instructions,
            preparationTime: preparationTime,
            cookingTime: cookingTime,
            servings: servings
        )
        
        await recipeListViewModel.addRecipe(recipe)
    }
} 