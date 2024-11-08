import Foundation

class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = [
        Recipe(title: "Margherita Pizza", 
               summary: "A classic Italian pizza with tomatoes, mozzarella, and fresh basil.",
               imageName: "pizza"),
        Recipe(title: "Berry Smoothie Bowl", 
               summary: "A refreshing blend of berries topped with fresh fruits and nuts.",
               imageName: "smoothie"),
        Recipe(title: "Creamy Mushroom Soup", 
               summary: "A rich and creamy soup with sautéed mushrooms and herbs.",
               imageName: "soup")
    ]
    
    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
    }
} 