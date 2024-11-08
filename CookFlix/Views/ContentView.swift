import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    @State private var showingAddRecipe = false
    @EnvironmentObject private var authManager: AuthManager
    
    var body: some View {
        NavigationView {
            Group {
                if let error = viewModel.error {
                    VStack {
                        Text("Error loading recipes")
                            .foregroundColor(.red)
                        Text(error.localizedDescription)
                            .font(.caption)
                        Button("Retry") {
                            Task {
                                await viewModel.loadRecipes()
                            }
                        }
                    }
                } else if viewModel.recipes.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "fork.knife.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text("No recipes yet")
                            .font(.title2)
                            .foregroundColor(.primary)
                        
                        Text("Tap + to add your first recipe")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            showingAddRecipe = true
                        }) {
                            Label("Add Recipe", systemImage: "plus")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                } else {
                    List(viewModel.recipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            RecipeRowView(recipe: recipe)
                        }
                    }
                }
            }
            .navigationTitle("My Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddRecipe = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        Task {
                            try? await authManager.signOut()
                        }
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
            }
            .sheet(isPresented: $showingAddRecipe) {
                Task {
                    await viewModel.loadRecipes()
                }
            } content: {
                AddRecipeView(isPresented: $showingAddRecipe, recipeListViewModel: viewModel)
            }
            .refreshable {
                await viewModel.loadRecipes()
            }
            .task {
                await viewModel.loadRecipes()
            }
        }
    }
}

// Simple preview without mock data
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthManager.shared)
    }
}
