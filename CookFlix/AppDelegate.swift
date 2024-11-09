import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func application(_ app: UIApplication,
                    open url: URL,
                    options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.absoluteString.contains("auth/callback") {
            Task {
                await createSessionFromUrl(url)
            }
            return true
        }
        return false
    }
    
    private func createSessionFromUrl(_ url: URL) async {
        do {
            let queryItems = URLComponents(string: url.absoluteString)?.queryItems
            guard let accessToken = queryItems?.first(where: { $0.name == "access_token" })?.value,
                  let refreshToken = queryItems?.first(where: { $0.name == "refresh_token" })?.value
            else {
                print("Error: Missing tokens in URL")
                return
            }
            
            let supabase = SupabaseManager.shared.client
            let { data, error } = try await supabase.auth.setSession(
                accessToken: accessToken,
                refreshToken: refreshToken
            )
            
            if let error = error {
                print("Error setting session:", error)
            }
        } catch {
            print("Error handling auth callback:", error)
        }
    }
} 