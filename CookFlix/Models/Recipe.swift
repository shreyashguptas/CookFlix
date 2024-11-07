import Foundation

struct Recipe: Identifiable, Codable {
    var id: UUID
    let title: String
    let summary: String
    let imageName: String
    var ingredients: [Ingredient]?
    var instructions: [String]?
    
    init(id: UUID = UUID(), title: String, summary: String, imageName: String, ingredients: [Ingredient]? = nil, instructions: [String]? = nil) {
        self.id = id
        self.title = title
        self.summary = summary
        self.imageName = imageName
        self.ingredients = ingredients
        self.instructions = instructions
    }
} 