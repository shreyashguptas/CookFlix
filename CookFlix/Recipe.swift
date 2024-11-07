import Foundation

struct Recipe: Identifiable {
    let id = UUID()
    let title: String
    let summary: String
    let imageName: String
    var ingredients: [Ingredient] = []
    var instructions: [String] = []
}

struct Ingredient: Identifiable {
    let id = UUID()
    let name: String
    let quantity: Double
    let unit: MeasurementUnit
}

enum MeasurementUnit: String, CaseIterable {
    case cup = "Cup"
    case tablespoon = "Tablespoon"
    case teaspoon = "Teaspoon"
    case pound = "Pound"
    case ounce = "Ounce"
    case gram = "Gram"
    // Add more units as needed
} 