//
//  ContentView.swift
//  CookFlix
//
//  Created by Shreyash Gupta on 11/7/24.
//

import SwiftUI

// Add this import if Recipe.swift is in a separate module
// import YourModuleName 

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
    @State private var ingredients: [Ingredient] = []
    @State private var instructions: [String] = []
    @State private var newIngredientName = ""
    @State private var newIngredientQuantity = ""
    @State private var newIngredientUnit = MeasurementUnit.cup
    @State private var newInstruction = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Name")) {
                    TextField("Enter recipe name", text: $title)
                }
                
                Section(header: Text("Ingredients")) {
                    ForEach(ingredients) { ingredient in
                        Text("\(ingredient.name) - \(ingredient.quantity) \(ingredient.unit.rawValue)")
                    }
                    
                    HStack {
                        TextField("Ingredient name", text: $newIngredientName)
                        TextField("138", text: $newIngredientQuantity)
                            .keyboardType(.decimalPad)
                            .frame(width: 60)
                        Picker("Unit", selection: $newIngredientUnit) {
                            ForEach(MeasurementUnit.allCases, id: \.self) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }
                        .frame(width: 100)
                    }
                    
                    Button("Add Ingredient") {
                        if let quantity = Double(newIngredientQuantity), !newIngredientName.isEmpty {
                            ingredients.append(Ingredient(name: newIngredientName,
                                                       quantity: quantity,
                                                       unit: newIngredientUnit))
                            newIngredientName = ""
                            newIngredientQuantity = ""
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.bordered)
                }
                
                Section(header: Text("Instructions")) {
                    ForEach(Array(instructions.enumerated()), id: \.offset) { index, instruction in
                        Text("Step \(index + 1): \(instruction)")
                    }
                    
                    TextField("Step \(instructions.count + 1)", text: $newInstruction)
                    
                    Button("Add Step") {
                        if !newInstruction.isEmpty {
                            instructions.append(newInstruction)
                            newInstruction = ""
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.bordered)
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
                    Button("Add to Recipe List") {
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
