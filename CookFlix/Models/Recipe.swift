import Foundation

struct Recipe: Identifiable, Codable {
    var id: UUID
    let title: String
    let summary: String
    let imageName: String
    var ingredients: [Ingredient]?
    var instructions: [String]?
    var preparationTime: String?
    var cookingTime: String?
    var servings: String?
    
    init(id: UUID = UUID(), title: String, summary: String, imageName: String, ingredients: [Ingredient]? = nil, instructions: [String]? = nil, preparationTime: String? = nil, cookingTime: String? = nil, servings: String? = nil) {
        self.id = id
        self.title = title
        self.summary = summary
        self.imageName = imageName
        self.ingredients = ingredients
        self.instructions = instructions
        self.preparationTime = preparationTime
        self.cookingTime = cookingTime
        self.servings = servings
    }
} 