import Foundation

struct Recipe: Identifiable {
    let id = UUID()
    let title: String
    let summary: String
    let imageName: String
} 