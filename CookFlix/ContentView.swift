//
//  ContentView.swift
//  CookFlix
//
//  Created by Shreyash Gupta on 11/7/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAddRecipe = false
    // Sample data - later this would come from your data source
    let recipes = [
        Recipe(title: "Margherita Pizza", 
               summary: "A classic Italian pizza with tomatoes, mozzarella, and fresh basil.",
               imageName: "pizza"),
        Recipe(title: "Berry Smoothie Bowl", 
               summary: "A refreshing blend of berries topped with fresh fruits and nuts.",
               imageName: "smoothie"),
        Recipe(title: "Creamy Mushroom Soup", 
               summary: "A rich and creamy soup with sautéed mushrooms and herbs.",
               imageName: "soup")
    ]
    
    var body: some View {
        NavigationView {
            List(recipes) { recipe in
                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                    RecipeRowView(recipe: recipe)
                }
            }
            .navigationTitle("CookFlix")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddRecipe = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .background(.blue)
                            .clipShape(.circle)
                            .padding(.top, 90)
                            .padding(.trailing, 10)
                    }
                }
            }
            .sheet(isPresented: $showingAddRecipe) {
                AddRecipeView(isPresented: $showingAddRecipe)
            }
        }
    }
}

struct RecipeRowView: View {
    let recipe: Recipe
    
    var body: some View {
        HStack(spacing: 15) {
            // Image placeholder - you'll need to replace this with your actual images
            Image(recipe.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(recipe.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(recipe.summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 8)
    }
}

// This is a placeholder for the detail view
struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        Text("Detail view for \(recipe.title)")
            .navigationTitle(recipe.title)
    }
}

// Add this new view
struct AddRecipeView: View {
    @Binding var isPresented: Bool
    @State private var title = ""
    @State private var summary = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Details")) {
                    TextField("Recipe Title", text: $title)
                    TextField("Summary", text: $summary)
                }
            }
            .navigationTitle("Add Recipe")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // TODO: Add save functionality
                        isPresented = false
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
