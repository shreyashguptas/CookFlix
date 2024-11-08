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
    
    func addInstruction() {
        if !newInstruction.isEmpty {
            instructions.append(newInstruction)
            newInstruction = ""
        }
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