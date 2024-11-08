import SwiftUI

struct AddRecipeView: View {
    @Binding var isPresented: Bool
    @ObservedObject var recipeListViewModel: RecipeListViewModel
    @StateObject private var viewModel: AddRecipeViewModel
    
    init(isPresented: Binding<Bool>, recipeListViewModel: RecipeListViewModel) {
        self._isPresented = isPresented
        self.recipeListViewModel = recipeListViewModel
        self._viewModel = StateObject(wrappedValue: AddRecipeViewModel(recipeListViewModel: recipeListViewModel))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Details")) {
                    TextField("Enter recipe name", text: $viewModel.title)
                    TextField("Enter recipe summary", text: $viewModel.summary)
                    TextField("Preparation time (e.g., 1 hr)", text: $viewModel.preparationTime)
                    TextField("Cooking time (e.g., 45 mins)", text: $viewModel.cookingTime)
                    TextField("Servings (e.g., 8)", text: $viewModel.servings)
                }
                
                Section(header: Text("Ingredients")) {
                    ForEach(viewModel.ingredients) { ingredient in
                        Text("\(ingredient.name) - \(ingredient.quantity) \(ingredient.unit.rawValue)")
                    }
                    
                    HStack {
                        TextField("Ingredient name", text: $viewModel.newIngredientName)
                        TextField("138", text: $viewModel.newIngredientQuantity)
                            .keyboardType(.decimalPad)
                            .frame(width: 60)
                        Picker("Unit", selection: $viewModel.newIngredientUnit) {
                            ForEach(MeasurementUnit.allCases, id: \.self) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }
                        .frame(width: 100)
                    }
                    
                    Button("Add Ingredient") {
                        viewModel.addIngredient()
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.bordered)
                }
                
                Section(header: Text("Instructions")) {
                    ForEach(Array(viewModel.instructions.enumerated()), id: \.offset) { index, instruction in
                        Text("Step \(index + 1): \(instruction)")
                    }
                    
                    TextField("Step \(viewModel.instructions.count + 1)", text: $viewModel.newInstruction)
                    
                    Button("Add Step") {
                        viewModel.addInstruction()
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
                        viewModel.saveRecipe()
                        isPresented = false
                    }
                    .disabled(viewModel.title.isEmpty)
                }
            }
        }
    }
} 