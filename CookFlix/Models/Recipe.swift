import Foundation

struct Recipe: Identifiable, Codable {
    let id = UUID()
    let title: String
    let summary: String
    let imageName: String
    var ingredients: [Ingredient]?
    var instructions: [String]?
} 