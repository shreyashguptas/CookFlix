import Foundation

struct Ingredient: Identifiable, Codable {
    var id: UUID
    let name: String
    let quantity: Double
    let unit: MeasurementUnit
    
    init(id: UUID = UUID(), name: String, quantity: Double, unit: MeasurementUnit) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unit = unit
    }
} 