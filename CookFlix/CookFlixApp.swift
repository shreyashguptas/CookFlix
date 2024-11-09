//
//  CookFlixApp.swift
//  CookFlix
//
//  Created by Shreyash Gupta on 11/7/24.
//

import SwiftUI

@main
struct CookFlixApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("hasSeenWelcomeScreen") private var hasSeenWelcomeScreen = false
    @StateObject private var authManager = AuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Group {
                    switch appState {
                    case .welcome:
                        WelcomeView(isWelcomeScreenDismissed: .init(
                            get: { !hasSeenWelcomeScreen },
                            set: { hasSeenWelcomeScreen = !$0 }
                        ))
                    case .authentication:
                        AuthView()
                    case .main:
                        ContentView()
                    }
                }
                .animation(.easeInOut, value: appState)
            }
        }
    }
    
    private var appState: AppState {
        if !hasSeenWelcomeScreen {
            return .welcome
        } else if !authManager.isAuthenticated {
            return .authentication
        } else {
            return .main
        }
    }
}

private enum AppState {
    case welcome
    case authentication
    case main
}
