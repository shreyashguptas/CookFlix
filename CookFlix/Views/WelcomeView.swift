import SwiftUI

struct WelcomeView: View {
    @Binding var isWelcomeScreenDismissed: Bool
    
    var body: some View {
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
                
                // Get Started button
                Button(action: {
                    withAnimation {
                        isWelcomeScreenDismissed = true
                    }
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(isWelcomeScreenDismissed: .constant(false))
    }
} 