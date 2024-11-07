import Foundation

struct Ingredient: Identifiable, Codable {
    let id = UUID()
    let name: String
    let quantity: Double
    let unit: MeasurementUnit
} 