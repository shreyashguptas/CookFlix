import Foundation

class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    private let database = RecipeDatabase.shared
    
    init() {
        Task {
            await loadRecipes()
        }
    }
    
    @MainActor
    func loadRecipes() async {
        do {
            recipes = try await database.fetchRecipes()
        } catch {
            print("Error loading recipes: \(error)")
        }
    }
    
    func addRecipe(_ recipe: Recipe) {
        Task {
            do {
                try await database.saveRecipe(recipe)
                await loadRecipes()
            } catch {
                print("Error saving recipe: \(error)")
            }
        }
    }
} 