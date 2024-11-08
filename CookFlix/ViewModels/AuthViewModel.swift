import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var error: String?
    @Published var isLoading = false
    @Published var showSuccessMessage = false
    @Published var shouldShowConfirmationAlert = false
    
    private let authManager = AuthManager.shared
    
    func authenticate(isSignUp: Bool) async {
        guard validateInput() else { return }
        
        isLoading = true
        error = nil
        showSuccessMessage = false
        
        do {
            if isSignUp {
                try await authManager.signUp(email: email, password: password)
                showSuccessMessage = true
                shouldShowConfirmationAlert = true
            } else {
                try await authManager.signIn(email: email, password: password)
            }
        } catch {
            self.error = error.localizedDescription
            showSuccessMessage = false
        }
        
        isLoading = false
    }
    
    private func validateInput() -> Bool {
        // Clear previous errors
        error = nil
        
        // Validate email
        guard !email.isEmpty else {
            error = "Please enter your email"
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            error = "Please enter a valid email address"
            return false
        }
        
        // Validate password
        guard !password.isEmpty else {
            error = "Please enter your password"
            return false
        }
        
        guard password.count >= 6 else {
            error = "Password must be at least 6 characters long"
            return false
        }
        
        return true
    }
} 