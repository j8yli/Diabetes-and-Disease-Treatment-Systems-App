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
                    } header: {
                        Text("Diabetes Management")
                            .foregroundColor(.green)
                    }
                    .listRowBackground(Color.white.opacity(0.8))
                }
                .scrollContentBackground(.hidden)
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
        }
    }
}
