//
//  FoodDataLoader.swift
//  GlucoseApp
//
//  Created by Sai Varsha Ravisankar on 11/3/25.
//

import SwiftUI

struct FoodItem: Codable {
    let description: String
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
