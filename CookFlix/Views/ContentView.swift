import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    @State private var showingAddRecipe = false
    
    var body: some View {
        NavigationView {
            List(viewModel.recipes) { recipe in
                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                    RecipeRowView(recipe: recipe)
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
                AddRecipeView(isPresented: $showingAddRecipe, recipeListViewModel: viewModel)
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
