import Foundation
import Supabase
import PostgREST

class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        guard let supabaseURL = SupabaseConfig["SUPABASE_URL"],
              let supabaseKey = SupabaseConfig["SUPABASE_ANON_KEY"] else {
            fatalError("Missing Supabase configuration. Ensure Supabase.plist exists with required keys.")
        }
        
        self.client = SupabaseClient(
            supabaseURL: URL(string: supabaseURL)!,
            supabaseKey: supabaseKey
        )
    }
} 