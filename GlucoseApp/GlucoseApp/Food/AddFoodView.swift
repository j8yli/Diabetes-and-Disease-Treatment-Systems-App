//
//  AddFoodView.swift
//  GlucoseApp
//
//  Created by Sai Varsha Ravisankar on 10/28/25.
//

import SwiftUI

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
    @State private var availableIngredients: [String] = []
    @State private var selectedIngredients: Set<String> = []
    @State private var showingIngredientPicker = false
    @State private var searchText: String = ""
    
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
    
    var filteredIngredients: [String] {
        if searchText.isEmpty {
            return availableIngredients
        } else {
            return availableIngredients.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
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
                                // Make sure ingredients are loaded before showing picker
                                if availableIngredients.isEmpty {
                                    let foodItems = FoodDataLoader.loadFoods()
                                    availableIngredients = foodItems.map { $0.description }
                                    print("🔄 Loading ingredients for picker: \(availableIngredients.count)")
                                }
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
                        
                        // Display selected ingredients
                        if !selectedIngredients.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(selectedIngredients).sorted(), id: \.self) { ingredient in
                                    HStack {
                                        Text("• \(ingredient)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Button(action: {
                                            selectedIngredients.remove(ingredient)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                                .font(.caption)
                                        }
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
                        Text("Macronutrients")
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
                    if availableIngredients.isEmpty {
                        let foodItems = FoodDataLoader.loadFoods()
                        availableIngredients = foodItems.map { $0.description }
                        print("🍎 Loaded \(availableIngredients.count) ingredients in AddFoodView")
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
                    selectedIngredients: $selectedIngredients
                )
                .onAppear {
                    print("🔍 IngredientPickerView opened with \(availableIngredients.count) ingredients")
                }
            }
        }
    }
}

// Separate view for the ingredient picker
struct IngredientPickerView: View {
    @Binding var selectedIngredients: Set<String>
    @Environment(\.dismiss) var dismiss
    
    @State private var searchText = ""
    @State private var availableIngredients: [String] = []
    
    var filteredIngredients: [String] {
        if searchText.isEmpty {
            return availableIngredients
        } else {
            return availableIngredients.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if availableIngredients.isEmpty {
                    ProgressView("Loading ingredients...")
                } else {
                    Text("Total ingredients: \(availableIngredients.count)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    List(filteredIngredients, id: \.self) { ingredient in
                        HStack {
                            Text(ingredient)
                            Spacer()
                            if selectedIngredients.contains(ingredient) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.gray)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedIngredients.contains(ingredient) {
                                selectedIngredients.remove(ingredient)
                            } else {
                                selectedIngredients.insert(ingredient)
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
                        dismiss()
                    }
                    .foregroundColor(.green)
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                print("🎬 IngredientPickerView appeared")
                if availableIngredients.isEmpty {
                    let foodItems = FoodDataLoader.loadFoods()
                    availableIngredients = foodItems.map { $0.description }
                    print("📦 Loaded in picker: \(availableIngredients.count)")
                }
            }
        }
    }
}
