enum AppError: LocalizedError {
    case databaseError(String)
    case authenticationError(String)
    case networkError(String)
    
    var errorDescription: String? {
        switch self {
        case .databaseError(let message):
            return "Database Error: \(message)"
        case .authenticationError(let message):
            return "Authentication Error: \(message)"
        case .networkError(let message):
            return "Network Error: \(message)"
        }
    }
} 