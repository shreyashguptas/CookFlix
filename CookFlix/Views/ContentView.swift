import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    @State private var showingAddRecipe = false
    
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
                    VStack {
                        Text("No recipes yet")
                            .foregroundColor(.secondary)
                        Text("Tap + to add your first recipe")
                            .font(.caption)
                    }
                } else {
                    List(viewModel.recipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            RecipeRowView(recipe: recipe)
                        }
                    }
                }
            }
            .navigationTitle("CookFlix")
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

// Preview provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
