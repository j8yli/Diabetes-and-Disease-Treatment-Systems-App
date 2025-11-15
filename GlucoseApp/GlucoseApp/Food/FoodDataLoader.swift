//
//  FoodDataLoader.swift
//  GlucoseApp
//
//  Created by Sai Varsha Ravisankar on 11/3/25.
//

import SwiftUI

struct Nutrient: Codable {
    let name: String
    let number: String
}

struct FoodNutrient: Codable {
    let nutrient: Nutrient
    let amount: Double?
}

struct FoodItem: Codable {
    let description: String
    let foodNutrients: [FoodNutrient]
    
    // Computed properties to extract macros per 100g
    var carbsPer100g: Double {
        foodNutrients.first { $0.nutrient.number == "205" }?.amount ?? 0
    }
    
    var proteinPer100g: Double {
        foodNutrients.first { $0.nutrient.number == "203" }?.amount ?? 0
    }
    
    var fatPer100g: Double {
        foodNutrients.first { $0.nutrient.number == "204" }?.amount ?? 0
    }
}

// Make FoodItem Hashable - ADD THIS
extension FoodItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }
    
    static func == (lhs: FoodItem, rhs: FoodItem) -> Bool {
        lhs.description == rhs.description
    }
}

struct FoodDataResponse: Codable {
    let FoundationFoods: [FoodItem]
}

struct FoodDataLoader {
    static func loadFoods() -> [FoodItem] {
        guard let url = Bundle.main.url(forResource: "FoodData_Central_foundation_food_json_2025-04-24", withExtension: "json") else {
            print("JSON file not found in bundle.")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(FoodDataResponse.self, from: data)
            print("✅ Loaded \(response.FoundationFoods.count) foods.")
            return response.FoundationFoods
        } catch {
            print("Failed to decode JSON:", error)
            return []
        }
    }
}
