import Foundation
import Supabase

class RecipeDatabase {
    static let shared = RecipeDatabase()
    private let supabase = SupabaseClient.shared
    
    func fetchRecipes() async throws -> [Recipe] {
        let response: [RecipeResponse] = try await supabase.database
            .from("recipes")
            .select("""
                id,
                title,
                summary,
                image_name,
                preparation_time,
                cooking_time,
                servings,
                ingredients (
                    id,
                    name,
                    quantity,
                    unit
                ),
                instructions (
                    id,
                    step_number,
                    instruction
                )
            """)
            .execute()
            .value
        
        return response.map { $0.toRecipe() }
    }
    
    func saveRecipe(_ recipe: Recipe) async throws {
        // First save the recipe
        let recipeId: UUID = try await supabase.database
            .from("recipes")
            .insert(RecipeRequest(from: recipe))
            .execute()
            .value[0].id
        
        // Then save ingredients
        if let ingredients = recipe.ingredients {
            try await supabase.database
                .from("ingredients")
                .insert(ingredients.map { IngredientRequest(ingredient: $0, recipeId: recipeId) })
                .execute()
        }
        
        // Finally save instructions
        if let instructions = recipe.instructions {
            try await supabase.database
                .from("instructions")
                .insert(instructions.enumerated().map { 
                    InstructionRequest(
                        stepNumber: $0.offset + 1,
                        instruction: $0.element,
                        recipeId: recipeId
                    )
                })
                .execute()
        }
    }
}

// Response/Request models
struct RecipeResponse: Codable {
    let id: UUID
    let title: String
    let summary: String
    let imageName: String
    let preparationTime: String?
    let cookingTime: String?
    let servings: String?
    let ingredients: [IngredientResponse]?
    let instructions: [InstructionResponse]?
    
    func toRecipe() -> Recipe {
        Recipe(
            id: id,
            title: title,
            summary: summary,
            imageName: imageName,
            ingredients: ingredients?.map { $0.toIngredient() },
            instructions: instructions?.sorted { $0.stepNumber < $1.stepNumber }.map { $0.instruction },
            preparationTime: preparationTime,
            cookingTime: cookingTime,
            servings: servings
        )
    }
}

// Add similar response/request models for Ingredient and Instruction 

// Response models
struct IngredientResponse: Codable {
    let id: UUID
    let recipeId: UUID
    let name: String
    let quantity: Double
    let unit: String
    
    func toIngredient() -> Ingredient {
        Ingredient(
            id: id,
            name: name,
            quantity: quantity,
            unit: MeasurementUnit(rawValue: unit) ?? .cup
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case recipeId = "recipe_id"
        case name
        case quantity
        case unit
    }
}

struct InstructionResponse: Codable {
    let id: UUID
    let recipeId: UUID
    let stepNumber: Int
    let instruction: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case recipeId = "recipe_id"
        case stepNumber = "step_number"
        case instruction
    }
}

// Request models
struct RecipeRequest: Codable {
    let title: String
    let summary: String
    let imageName: String
    let preparationTime: String?
    let cookingTime: String?
    let servings: String?
    
    init(from recipe: Recipe) {
        self.title = recipe.title
        self.summary = recipe.summary
        self.imageName = recipe.imageName
        self.preparationTime = recipe.preparationTime
        self.cookingTime = recipe.cookingTime
        self.servings = recipe.servings
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case summary
        case imageName = "image_name"
        case preparationTime = "preparation_time"
        case cookingTime = "cooking_time"
        case servings
    }
}

struct IngredientRequest: Codable {
    let recipeId: UUID
    let name: String
    let quantity: Double
    let unit: String
    
    init(ingredient: Ingredient, recipeId: UUID) {
        self.recipeId = recipeId
        self.name = ingredient.name
        self.quantity = ingredient.quantity
        self.unit = ingredient.unit.rawValue
    }
    
    enum CodingKeys: String, CodingKey {
        case recipeId = "recipe_id"
        case name
        case quantity
        case unit
    }
}

struct InstructionRequest: Codable {
    let recipeId: UUID
    let stepNumber: Int
    let instruction: String
    
    enum CodingKeys: String, CodingKey {
        case recipeId = "recipe_id"
        case stepNumber = "step_number"
        case instruction
    }
}