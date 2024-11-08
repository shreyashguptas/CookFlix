import Foundation

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var error: Error?
    private let database = RecipeDatabase.shared
    
    init() {
        Task {
            await loadRecipes()
        }
    }
    
    func loadRecipes() async {
        do {
            print("Starting to load recipes") // Debug
            recipes = try await database.fetchRecipes()
            print("Loaded recipes count: \(recipes.count)") // Debug
            if recipes.isEmpty {
                print("No recipes found in the database") // Debug
            }
        } catch {
            print("Error loading recipes: \(error)") // Debug
            self.error = error
        }
    }
    
    func addRecipe(_ recipe: Recipe) async {
        do {
            try await database.saveRecipe(recipe)
            await loadRecipes()
        } catch {
            print("Error saving recipe: \(error)") // Debug
            self.error = error
        }
    }
} 