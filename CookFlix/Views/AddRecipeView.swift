import SwiftUI

struct AddRecipeView: View {
    @Binding var isPresented: Bool
    @ObservedObject var recipeListViewModel: RecipeListViewModel
    @StateObject private var viewModel: AddRecipeViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(isPresented: Binding<Bool>, recipeListViewModel: RecipeListViewModel) {
        self._isPresented = isPresented
        self.recipeListViewModel = recipeListViewModel
        self._viewModel = StateObject(wrappedValue: AddRecipeViewModel(recipeListViewModel: recipeListViewModel))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Details")) {
                    TextField("Recipe name", text: $viewModel.title)
                    TextField("Summary", text: $viewModel.summary)
                    TextField("Preparation time", text: $viewModel.preparationTime)
                        .keyboardType(.default)
                    TextField("Cooking time", text: $viewModel.cookingTime)
                        .keyboardType(.default)
                    TextField("Servings", text: $viewModel.servings)
                        .keyboardType(.default)
                }
                
                Section(header: Text("Ingredients")) {
                    ForEach(viewModel.ingredients) { ingredient in
                        Text("\(ingredient.quantity) \(ingredient.unit.rawValue) \(ingredient.name)")
                    }
                    .onDelete(perform: viewModel.deleteIngredient)
                    
                    HStack {
                        TextField("Name", text: $viewModel.newIngredientName)
                        TextField("Quantity", text: $viewModel.newIngredientQuantity)
                            .keyboardType(.decimalPad)
                        Picker("Unit", selection: $viewModel.newIngredientUnit) {
                            ForEach(MeasurementUnit.allCases, id: \.self) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }
                    }
                    
                    Button("Add Ingredient") {
                        viewModel.addIngredient()
                    }
                    .disabled(viewModel.newIngredientName.isEmpty || viewModel.newIngredientQuantity.isEmpty)
                }
                
                Section(header: Text("Instructions")) {
                    ForEach(Array(viewModel.instructions.enumerated()), id: \.offset) { index, instruction in
                        Text("\(index + 1). \(instruction)")
                    }
                    .onDelete(perform: viewModel.deleteInstruction)
                    
                    TextField("Add instruction step", text: $viewModel.newInstruction)
                    Button("Add Step") {
                        viewModel.addInstruction()
                    }
                    .disabled(viewModel.newInstruction.isEmpty)
                }
            }
            .navigationTitle("New Recipe")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await viewModel.saveRecipe()
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView(
            isPresented: .constant(true),
            recipeListViewModel: RecipeListViewModel()
        )
    }
} 