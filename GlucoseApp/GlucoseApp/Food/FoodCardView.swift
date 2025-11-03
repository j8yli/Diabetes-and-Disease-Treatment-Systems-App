//
//  FoodCardView.swift
//  GlucoseApp
//
//  Created by Sai Varsha Ravisankar on 10/28/25.
//

import SwiftUI

struct FoodCardView: View {
    let entry: FoodEntry
    @EnvironmentObject var vm: FoodViewModel
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(mealColor(entry.mealType).opacity(0.2))
                        .frame(width: 50, height: 50)
                    Image(systemName: mealIcon(entry.mealType))
                        .font(.title2)
                        .foregroundColor(mealColor(entry.mealType))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.foodName)
                        .font(.title3)
                        .fontWeight(.bold)
                    HStack(spacing: 8) {
                        Text(entry.mealType)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(mealColor(entry.mealType).opacity(0.2))
                            .foregroundColor(mealColor(entry.mealType))
                            .cornerRadius(8)
                        Text(entry.date, style: .time)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Menu {
                    Button(action: { vm.editingEntry = entry }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    Button(role: .destructive, action: { showDeleteAlert = true }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
            
            HStack(spacing: 16) {
                MacroIndicator(icon: "leaf.fill", value: entry.carbs, unit: "g", label: "Carbs", color: .yellow)
                MacroIndicator(icon: "flame.fill", value: entry.protein, unit: "g", label: "Protein", color: .red)
                MacroIndicator(icon: "drop.fill", value: entry.fat, unit: "g", label: "Fat", color: .blue)
            }
            
            if let insulin = entry.insulinDose {
                HStack {
                    Image(systemName: "cross.vial.fill")
                        .foregroundColor(.purple)
                    Text("Insulin: \(insulin, specifier: "%.1f") units")
                        .font(.subheadline)
                        .foregroundColor(.purple)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(10)
            }
            
            if let before = entry.bloodGlucoseBefore, let after = entry.bloodGlucoseAfter {
                BloodGlucoseCard(before: before, after: after)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .alert("Delete Meal", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                vm.deleteEntry(entry)
            }
        } message: {
            Text("Are you sure you want to delete this meal?")
        }
    }
    
    func mealIcon(_ type: String) -> String {
        switch type {
        case "Breakfast": return "sunrise.fill"
        case "Lunch": return "sun.max.fill"
        case "Dinner": return "moon.stars.fill"
        case "Snack": return "star.fill"
        default: return "fork.knife"
        }
    }
    
    func mealColor(_ type: String) -> Color {
        switch type {
        case "Breakfast": return .orange
        case "Lunch": return .yellow
        case "Dinner": return .indigo
        case "Snack": return .pink
        default: return .green
        }
    }
}
