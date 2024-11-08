import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isSignUp = false
    @State private var showingConfirmationAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                // Logo and welcome text
                Image(systemName: "fork.knife.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                
                Text(isSignUp ? "Create Account" : "Welcome Back")
                    .font(.title)
                    .fontWeight(.bold)
                
                // Form fields
                VStack(spacing: 15) {
                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .disabled(viewModel.isLoading)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(isSignUp ? .newPassword : .password)
                        .disabled(viewModel.isLoading)
                }
                .padding(.horizontal)
                
                // Error or Success message
                Group {
                    if let error = viewModel.error {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    } else if viewModel.showSuccessMessage {
                        VStack(spacing: 8) {
                            Text("Account created successfully!")
                                .foregroundColor(.green)
                            Text("Please check your email to confirm your account")
                                .foregroundColor(.secondary)
                            Text("The confirmation link will expire in 1 hour")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal)
                
                // Sign In/Up button
                Button(action: {
                    Task {
                        await viewModel.authenticate(isSignUp: isSignUp)
                    }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text(isSignUp ? "Create Account" : "Sign In")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .disabled(viewModel.isLoading)
                
                // Toggle between sign in/up
                Button(action: {
                    viewModel.error = nil
                    isSignUp.toggle()
                }) {
                    Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                }
                .disabled(viewModel.isLoading)
            }
            .padding()
            .navigationBarHidden(true)
            .alert("Email Verification Required", isPresented: $showingConfirmationAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("We've sent a confirmation link to your email. Please verify your account within 1 hour to continue.")
            }
            .onChange(of: viewModel.shouldShowConfirmationAlert) { newValue in
                if newValue {
                    showingConfirmationAlert = true
                    viewModel.shouldShowConfirmationAlert = false
                }
            }
        }
    }
}

// Preview provider
struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Light mode preview
            AuthView()
                .previewDisplayName("Light Mode")
            
            // Dark mode preview
            AuthView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
} 
