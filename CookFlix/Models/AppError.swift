enum AppError: Error {
    case databaseError(String)
    case networkError(String)
    case decodingError(String)
} 