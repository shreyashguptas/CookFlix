import Foundation
import Supabase
import PostgREST

class RecipeDatabase {
    static let shared = RecipeDatabase()
    private let supabase = SupabaseManager.shared
    
    func fetchRecipes() async throws -> [Recipe] {
        print("Fetching recipes...") // Debug log
        
        let response: PostgrestResponse<[RecipeResponse]> = try await supabase.client
            .from("recipes")
            .select("""
                id,
                title,
                summary,
                image_name,
                preparation_time,
                cooking_time,
                servings,
                ingredients:ingredients(
                    id,
                    name,
                    quantity,
                    unit,
                    recipe_id
                ),
                instructions:instructions(
                    id,
                    step_number,
                    instruction,
                    recipe_id
                )
            """)
            .order("created_at", ascending: false)
            .execute()
        
        print("Raw response: \(String(describing: response))") // Debug raw response
        print("Fetched \(response.value.count) recipes") // Debug count
        
        let recipes = response.value.map { $0.toRecipe() }
        print("Mapped recipes: \(recipes)") // Debug mapped data
        return recipes
    }
    
    func saveRecipe(_ recipe: Recipe) async throws {
        print("Saving recipe: \(recipe.title)") // Debug log
        
        // First save the recipe
        let response: PostgrestResponse<[RecipeResponse]> = try await supabase.client
            .from("recipes")
            .insert(RecipeRequest(from: recipe))
            .select() // Add select() to get the inserted record
            .single() // Ensure we get a single record
            .execute()
        
        guard let recipeId = response.value.first?.id else {
            throw AppError.databaseError("Failed to get recipe ID")
        }
        
        print("Saved recipe with ID: \(recipeId)") // Debug log
        
        // Then save ingredients
        if let ingredients = recipe.ingredients, !ingredients.isEmpty {
            print("Saving \(ingredients.count) ingredients") // Debug log
            let _: PostgrestResponse<[IngredientResponse]> = try await supabase.client
                .from("ingredients")
                .insert(ingredients.map { IngredientRequest(ingredient: $0, recipeId: recipeId) })
                .execute()
        }
        
        // Finally save instructions
        if let instructions = recipe.instructions, !instructions.isEmpty {
            print("Saving \(instructions.count) instructions") // Debug log
            let _: PostgrestResponse<[InstructionResponse]> = try await supabase.client
                .from("instructions")
                .insert(instructions.enumerated().map { 
                    InstructionRequest(
                        recipeId: recipeId,
                        stepNumber: $0.offset + 1,
                        instruction: $0.element
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
    let image_name: String
    let preparation_time: String?
    let cooking_time: String?
    let servings: String?
    let ingredients: [IngredientResponse]?
    let instructions: [InstructionResponse]?
    let created_at: Date?
    
    func toRecipe() -> Recipe {
        print("Converting response to Recipe: \(self)") // Debug conversion
        return Recipe(
            id: id,
            title: title,
            summary: summary,
            imageName: image_name,
            ingredients: ingredients?.map { $0.toIngredient() },
            instructions: instructions?.sorted { $0.step_number < $1.step_number }.map { $0.instruction },
            preparationTime: preparation_time,
            cookingTime: cooking_time,
            servings: servings
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case summary
        case image_name
        case preparation_time
        case cooking_time
        case servings
        case ingredients
        case instructions
        case created_at
    }
}

// Add similar response/request models for Ingredient and Instruction 

// Response models
struct IngredientResponse: Codable {
    let id: UUID
    let recipe_id: UUID
    let name: String
    let quantity: Double
    let unit: String
    
    func toIngredient() -> Ingredient {
        Ingredient(
            id: id,
            name: name,
            quantity: quantity,
            unit: MeasurementUnit(rawValue: unit) ?? .piece
        )
    }
}

struct InstructionResponse: Codable {
    let id: UUID
    let recipe_id: UUID
    let step_number: Int
    let instruction: String
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
    
    init(recipeId: UUID, stepNumber: Int, instruction: String) {
        self.recipeId = recipeId
        self.stepNumber = stepNumber
        self.instruction = instruction
    }
    
    enum CodingKeys: String, CodingKey {
        case recipeId = "recipe_id"
        case stepNumber = "step_number"
        case instruction
    }
}