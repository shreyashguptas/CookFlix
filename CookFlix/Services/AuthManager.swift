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
        isAuthenticated = supabase.client.auth.currentSession != nil
    }
    
    func signIn(email: String, password: String) async throws {
        do {
            let response = try await supabase.client.auth.signIn(
                email: email,
                password: password
            )
            
            // Since response.user is not optional, we don't need if let
            let user = response.user
            
            // Convert AnyJSON to Any using proper casting
            let metadata = user.userMetadata
            if let emailConfirmed = metadata["email_confirmed"]?.boolValue,
               !emailConfirmed {
                throw AuthenticationError.emailNotConfirmed
            }
            
            isAuthenticated = true
            
        } catch let error as AuthenticationError {
            throw error
        } catch {
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
                password: password,
                data: ["email_confirmed": false]
            )
            
            // Since response.user is not optional, we don't need if let
            let user = response.user
            guard !user.id.uuidString.isEmpty else {
                throw AuthenticationError.unknown("Failed to create account")
            }
            
            print("User created, awaiting email confirmation")
            
        } catch let error as AuthenticationError {
            throw error
        } catch {
            let errorMessage = error.localizedDescription.lowercased()
            if errorMessage.contains("already registered") || errorMessage.contains("already exists") {
                throw AuthenticationError.emailAlreadyInUse
            } else if errorMessage.contains("password") {
                throw AuthenticationError.weakPassword
            } else if errorMessage.contains("invalid email") {
                throw AuthenticationError.invalidEmail
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

enum AuthenticationError: LocalizedError {
    case invalidCredentials
    case userNotFound
    case weakPassword
    case emailAlreadyInUse
    case invalidEmail
    case emailNotConfirmed
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
        case .emailNotConfirmed:
            return "Please confirm your email address before signing in. Check your inbox for the confirmation link."
        case .unknown(let message):
            return "Error: \(message)"
        }
    }
}