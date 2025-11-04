//
//  FoodEntry.swift
//  GlucoseApp
//
//  Created by Sai Varsha Ravisankar on 10/28/25.
//

import SwiftUI

struct FoodEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let mealType: String
    let foodName: String
    let carbs: Int
    let protein: Int
    let fat: Int
    let bloodGlucoseBefore: Int?
    let bloodGlucoseAfter: Int?
    let insulinDose: Double?
    
    init(id: UUID = UUID(), date: Date = Date(), mealType: String, foodName: String, carbs: Int, protein: Int, fat: Int, bloodGlucoseBefore: Int? = nil, bloodGlucoseAfter: Int? = nil, insulinDose: Double? = nil) {
        self.id = id
        self.date = date
        self.mealType = mealType
        self.foodName = foodName
        self.carbs = carbs
        self.protein = protein
        self.fat = fat
        self.bloodGlucoseBefore = bloodGlucoseBefore
        self.bloodGlucoseAfter = bloodGlucoseAfter
        self.insulinDose = insulinDose
    }
}
