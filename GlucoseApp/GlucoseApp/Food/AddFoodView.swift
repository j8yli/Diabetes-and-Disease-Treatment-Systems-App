//
//  AddFoodView.swift
//  GlucoseApp
//
//  Created by Sai Varsha Ravisankar on 10/28/25.
//

import SwiftUI

// Helper struct to track ingredient with amount
struct IngredientWithAmount: Identifiable, Hashable {
    let id = UUID()
    let foodItem: FoodItem
    var amountInGrams: String = "100"
    
    var amountDouble: Double {
        Double(amountInGrams) ?? 0
    }
    
    var carbs: Double {
        (foodItem.carbsPer100g * amountDouble) / 100.0
    }
    
    var protein: Double {
        (foodItem.proteinPer100g * amountDouble) / 100.0
    }
    
    var fat: Double {
        (foodItem.fatPer100g * amountDouble) / 100.0
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: IngredientWithAmount, rhs: IngredientWithAmount) -> Bool {
        lhs.id == rhs.id
    }
}

struct AddFoodView: View {
    @EnvironmentObject var vm: FoodViewModel
    @Environment(\.dismiss) var dismiss
    
    let editingEntry: FoodEntry?
    
    @State private var mealType: String
    @State private var foodName: String
    @State private var carbs: String
    @State private var protein: String
    @State private var fat: String
    @State private var bgBefore: String
    @State private var bgAfter: String
    @State private var insulin: String
    @State private var availableFoodItems: [FoodItem] = []
    @State private var selectedIngredients: [IngredientWithAmount] = []
    @State private var showingIngredientPicker = false
    
    let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"]
    
    init(editingEntry: FoodEntry?) {
        self.editingEntry = editingEntry
        _mealType = State(initialValue: editingEntry?.mealType ?? "Breakfast")
        _foodName = State(initialValue: editingEntry?.foodName ?? "")
        _carbs = State(initialValue: editingEntry != nil ? String(editingEntry!.carbs) : "")
        _protein = State(initialValue: editingEntry != nil ? String(editingEntry!.protein) : "")
        _fat = State(initialValue: editingEntry != nil ? String(editingEntry!.fat) : "")
        _bgBefore = State(initialValue: editingEntry?.bloodGlucoseBefore != nil ? String(editingEntry!.bloodGlucoseBefore!) : "")
        _bgAfter = State(initialValue: editingEntry?.bloodGlucoseAfter != nil ? String(editingEntry!.bloodGlucoseAfter!) : "")
        _insulin = State(initialValue: editingEntry?.insulinDose != nil ? String(editingEntry!.insulinDose!) : "")
    }
    
    // Calculate totals from all ingredients
    func calculateTotals() {
        let totalCarbs = selectedIngredients.reduce(0.0) { $0 + $1.carbs }
        let totalProtein = selectedIngredients.reduce(0.0) { $0 + $1.protein }
        let totalFat = selectedIngredients.reduce(0.0) { $0 + $1.fat }
        
        carbs = String(Int(totalCarbs.rounded()))
        protein = String(Int(totalProtein.rounded()))
        fat = String(Int(totalFat.rounded()))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.green.opacity(0.15), Color.blue.opacity(0.15)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                Form {
                    Section {
                        Picker("Meal Type", selection: $mealType) {
                            ForEach(mealTypes, id: \.self) { meal in
                                Text(meal).tag(meal)
                            }
                        }
                        
                        HStack {
                            Image(systemName: "text.bubble.fill")
                                .foregroundColor(.green)
                            TextField("Food Name", text: $foodName)
                        }
                        
                        // Multiple Ingredient Selection
                        HStack {
                            Image(systemName: "list.bullet")
                                .foregroundColor(.green)
                            Button(action: {
                                showingIngredientPicker = true
                            }) {
                                HStack {
                                    Text(selectedIngredients.isEmpty ? "Select Ingredients" : "\(selectedIngredients.count) selected")
                                        .foregroundColor(selectedIngredients.isEmpty ? .gray : .primary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        // Display selected ingredients with amounts
                        if !selectedIngredients.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(Array(selectedIngredients.enumerated()), id: \.element.id) { offset, ingredient in
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(ingredient.foodItem.description)
                                                .font(.caption)
                                                .fontWeight(.medium)
                                            Spacer()
                                            Button(action: {
                                                if let index = selectedIngredients.firstIndex(where: { $0.id == ingredient.id }) {
                                                    selectedIngredients.remove(at: index)
                                                    calculateTotals()
                                                }
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.red)
                                                    .font(.caption)
                                            }
                                        }
                                        
                                        HStack {
                                            Text("Amount (g):")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                            
                                            if let index = selectedIngredients.firstIndex(where: { $0.id == ingredient.id }) {
                                                TextField("100", text: Binding(
                                                    get: { selectedIngredients[index].amountInGrams },
                                                    set: { newValue in
                                                        selectedIngredients[index].amountInGrams = newValue
                                                        calculateTotals()
                                                    }
                                                ))
                                                .keyboardType(.decimalPad)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .frame(width: 80)
                                            }
                                            
                                            Spacer()
                                            
                                            Text("C:\(Int(ingredient.carbs))g P:\(Int(ingredient.protein))g F:\(Int(ingredient.fat))g")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                    
                                    if offset < selectedIngredients.count - 1 {
                                        Divider()
                                    }
                                }
                            }
                        }
                    } header: {
                        Text("Meal Details")
                            .foregroundColor(.green)
                    }
                    .listRowBackground(Color.white.opacity(0.8))
                    
                    Section {
                        HStack {
                            Image(systemName: "leaf.fill")
                                .foregroundColor(.yellow)
                            TextField("Carbs (g)", text: $carbs)
                                .keyboardType(.numberPad)
                        }
                        
                        HStack {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.red)
                            TextField("Protein (g)", text: $protein)
                                .keyboardType(.numberPad)
                        }
                        
                        HStack {
                            Image(systemName: "drop.fill")
                                .foregroundColor(.blue)
                            TextField("Fat (g)", text: $fat)
                                .keyboardType(.numberPad)
                        }
                    } header: {
                        Text("Macronutrients (Auto-calculated)")
                            .foregroundColor(.green)
                    }
                    .listRowBackground(Color.white.opacity(0.8))
                    
                    Section {
                        HStack {
                            Image(systemName: "drop.fill")
                                .foregroundColor(.red)
                            TextField("Before (mg/dL)", text: $bgBefore)
                                .keyboardType(.numberPad)
                        }
                        
                        HStack {
                            Image(systemName: "drop.fill")
                                .foregroundColor(.blue)
                            TextField("After (mg/dL)", text: $bgAfter)
                                .keyboardType(.numberPad)
                        }
                        
                        HStack {
                            Image(systemName: "cross.vial.fill")
                                .foregroundColor(.purple)
                            TextField("Insulin (units)", text: $insulin)
                                .keyboardType(.decimalPad)
                        }
                    }
                    header: {
                        Text("Diabetes Management")
                            .foregroundColor(.green)
                    }
                    .listRowBackground(Color.white.opacity(0.8))
                }
                .scrollContentBackground(.hidden)
                .onAppear {
                    if availableFoodItems.isEmpty {
                        availableFoodItems = FoodDataLoader.loadFoods()
                        print("🍎 Loaded \(availableFoodItems.count) food items in AddFoodView")
                    }
                }
            }
            .navigationTitle(editingEntry == nil ? "Log Food" : "Edit Food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.green)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(editingEntry == nil ? "Save" : "Update") {
                        if let existing = editingEntry {
                            let updated = FoodEntry(
                                id: existing.id,
                                date: existing.date,
                                mealType: mealType,
                                foodName: foodName,
                                carbs: Int(carbs) ?? 0,
                                protein: Int(protein) ?? 0,
                                fat: Int(fat) ?? 0,
                                bloodGlucoseBefore: Int(bgBefore),
                                bloodGlucoseAfter: Int(bgAfter),
                                insulinDose: Double(insulin)
                            )
                            vm.updateEntry(updated)
                        } else {
                            let entry = FoodEntry(
                                mealType: mealType,
                                foodName: foodName,
                                carbs: Int(carbs) ?? 0,
                                protein: Int(protein) ?? 0,
                                fat: Int(fat) ?? 0,
                                bloodGlucoseBefore: Int(bgBefore),
                                bloodGlucoseAfter: Int(bgAfter),
                                insulinDose: Double(insulin)
                            )
                            vm.addEntry(entry)
                        }
                        dismiss()
                    }
                    .disabled(foodName.isEmpty)
                    .foregroundColor(.green)
                    .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $showingIngredientPicker) {
                IngredientPickerView(
                    availableFoodItems: availableFoodItems,
                    selectedIngredients: $selectedIngredients,
                    onDismiss: {
                        calculateTotals()
                    }
                )
            }
        }
    }
}

// Separate view for the ingredient picker
struct IngredientPickerView: View {
    let availableFoodItems: [FoodItem]
    @Binding var selectedIngredients: [IngredientWithAmount]
    let onDismiss: () -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @State private var localFoodItems: [FoodItem] = []
    
    var filteredIngredients: [FoodItem] {
        let items = localFoodItems.isEmpty ? availableFoodItems : localFoodItems
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.description.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func isSelected(_ foodItem: FoodItem) -> Bool {
        selectedIngredients.contains { $0.foodItem.description == foodItem.description }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if availableFoodItems.isEmpty && localFoodItems.isEmpty {
                    ProgressView("Loading ingredients...")
                        .onAppear {
                            print("⚠️ Loading ingredients in picker because availableFoodItems is empty")
                            localFoodItems = FoodDataLoader.loadFoods()
                            print("📦 Loaded \(localFoodItems.count) items locally")
                        }
                } else {
                    List(filteredIngredients, id: \.self) { foodItem in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(foodItem.description)
                                Text("Per 100g: C:\(Int(foodItem.carbsPer100g))g P:\(Int(foodItem.proteinPer100g))g F:\(Int(foodItem.fatPer100g))g")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            if isSelected(foodItem) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.gray)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if let index = selectedIngredients.firstIndex(where: { $0.foodItem.description == foodItem.description }) {
                                selectedIngredients.remove(at: index)
                            } else {
                                selectedIngredients.append(IngredientWithAmount(foodItem: foodItem))
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search ingredients")
            .navigationTitle("Select Ingredients")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onDismiss()
                        dismiss()
                    }
                    .foregroundColor(.green)
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                print("🎬 Picker appeared with \(availableFoodItems.count) items passed in")
            }
        }
    }
}
