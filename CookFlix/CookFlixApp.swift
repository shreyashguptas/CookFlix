//
//  CookFlixApp.swift
//  CookFlix
//
//  Created by Shreyash Gupta on 11/7/24.
//

import SwiftUI

@main
struct CookFlixApp: App {
    @AppStorage("hasSeenWelcomeScreen") private var hasSeenWelcomeScreen = false
    @StateObject private var authManager = AuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !hasSeenWelcomeScreen {
                    WelcomeView(isWelcomeScreenDismissed: .init(
                        get: { !hasSeenWelcomeScreen },
                        set: { hasSeenWelcomeScreen = !$0 }
                    ))
                    .transition(.opacity)
                } else if !authManager.isAuthenticated {
                    AuthView()
                        .transition(.opacity)
                } else {
                    ContentView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut, value: hasSeenWelcomeScreen)
            .animation(.easeInOut, value: authManager.isAuthenticated)
        }
    }
}
