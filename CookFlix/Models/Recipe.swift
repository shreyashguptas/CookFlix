import Foundation

struct Recipe: Identifiable, Codable {
    let id: UUID
    let title: String
    let summary: String
    let imageName: String
    let ingredients: [Ingredient]?
    let instructions: [String]?
    let preparationTime: String?
    let cookingTime: String?
    let servings: String?
    let userId: UUID?
    let createdAt: Date?
    
    init(
        id: UUID = UUID(),
        title: String,
        summary: String,
        imageName: String,
        ingredients: [Ingredient]? = nil,
        instructions: [String]? = nil,
        preparationTime: String? = nil,
        cookingTime: String? = nil,
        servings: String? = nil,
        userId: UUID? = nil,
        createdAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.imageName = imageName
        self.ingredients = ingredients
        self.instructions = instructions
        self.preparationTime = preparationTime
        self.cookingTime = cookingTime
        self.servings = servings
        self.userId = userId
        self.createdAt = createdAt
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case summary
        case imageName = "image_name"
        case ingredients
        case instructions
        case preparationTime = "preparation_time"
        case cookingTime = "cooking_time"
        case servings
        case userId = "user_id"
        case createdAt = "created_at"
    }
} 