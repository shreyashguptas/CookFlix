import SwiftUI

struct WelcomeView: View {
    @Binding var isWelcomeScreenDismissed: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color.blue.opacity(0.1).ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // App logo/icon
                    Image(systemName: "fork.knife.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.blue)
                    
                    // Welcome text
                    Text("Welcome to CookFlix")
                        .font(.system(size: 32, weight: .bold))
                        .multilineTextAlignment(.center)
                    
                    Text("Your personal recipe collection\nand meal planning companion")
                        .font(.system(size: 18))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    // Get Started button with animation
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isWelcomeScreenDismissed = true
                        }
                    }) {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                Color.blue
                                    .cornerRadius(12)
                                    .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 2)
                            )
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                    // Add hover effect
                    .scaleEffect(1.0)
                    .animation(.spring(), value: isWelcomeScreenDismissed)
                }
            }
            .navigationBarHidden(true)
            // Add transition for the whole view
            .transition(.opacity)
        }
    }
}

// Preview provider
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Light mode preview
            WelcomeView(isWelcomeScreenDismissed: .constant(false))
                .previewDisplayName("Light Mode")
            
            // Dark mode preview
            WelcomeView(isWelcomeScreenDismissed: .constant(false))
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
} 