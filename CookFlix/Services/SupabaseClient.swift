import Foundation
import Supabase

class SupabaseClient {
    static let shared = SupabaseClient()
    
    private let client: SupabaseClient
    
    private init() {
        let supabaseURL = "https://lkvjcfyejtgetcedykzi.supabase.co"
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxrdmpjZnllanRnZXRjZWR5a3ppIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzEwMjg5OTQsImV4cCI6MjA0NjYwNDk5NH0.CM9vwIGPySJkX-FLeIqYXJehi-K__pTp1AahsOtHv5w"
        
        self.client = SupabaseClient(
            supabaseURL: URL(string: supabaseURL)!,
            supabaseKey: supabaseKey
        )
    }
} 