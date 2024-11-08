import Foundation
import Supabase

@MainActor
class AuthManager: ObservableObject {
    static let shared = AuthManager()
    @Published var isAuthenticated = false
    private let supabase = SupabaseManager.shared
    
    init() {
        Task {
            await checkAuthStatus()
        }
    }
    
    func checkAuthStatus() async {
        do {
            let session = try await supabase.client.auth.session
            isAuthenticated = session.user.id.uuidString.isEmpty == false
        } catch {
            print("Error checking auth status: \(error)")
            isAuthenticated = false
        }
    }
    
    func signIn(email: String, password: String) async throws {
        do {
            let response = try await supabase.client.auth.signIn(
                email: email,
                password: password
            )
            
            if response.user.id.uuidString.isEmpty == false {
                isAuthenticated = true
            } else {
                throw AuthenticationError.invalidCredentials
            }
            
        } catch let error {
            // Handle specific error messages from Supabase
            let errorMessage = error.localizedDescription.lowercased()
            if errorMessage.contains("invalid") {
                throw AuthenticationError.invalidCredentials
            } else if errorMessage.contains("not found") {
                throw AuthenticationError.userNotFound
            } else {
                throw AuthenticationError.unknown(error.localizedDescription)
            }
        }
    }
    
    func signUp(email: String, password: String) async throws {
        do {
            let response = try await supabase.client.auth.signUp(
                email: email,
                password: password
            )
            
            if response.user.id.uuidString.isEmpty == false {
                isAuthenticated = true
            } else {
                throw AuthenticationError.unknown("Failed to create account")
            }
            
        } catch let error {
            // Handle specific error messages from Supabase
            let errorMessage = error.localizedDescription.lowercased()
            if errorMessage.contains("already registered") || errorMessage.contains("already exists") {
                throw AuthenticationError.emailAlreadyInUse
            } else if errorMessage.contains("password") {
                throw AuthenticationError.weakPassword
            } else {
                throw AuthenticationError.unknown(error.localizedDescription)
            }
        }
    }
    
    func signOut() async throws {
        do {
            try await supabase.client.auth.signOut()
            isAuthenticated = false
        } catch {
            throw AuthenticationError.unknown("Failed to sign out: \(error.localizedDescription)")
        }
    }
}

// Custom error types for better error handling
enum AuthenticationError: LocalizedError {
    case invalidCredentials
    case userNotFound
    case weakPassword
    case emailAlreadyInUse
    case invalidEmail
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Incorrect email or password"
        case .userNotFound:
            return "No account found with this email"
        case .weakPassword:
            return "Password must be at least 6 characters long"
        case .emailAlreadyInUse:
            return "An account with this email already exists"
        case .invalidEmail:
            return "Please enter a valid email address"
        case .unknown(let message):
            return "Error: \(message)"
        }
    }
} 
