//
//  FoodViewModel.swift
//  GlucoseApp
//
//  Created by Sai Varsha Ravisankar on 10/28/25.
//

import SwiftUI

class FoodViewModel: ObservableObject {
    @Published var entries: [FoodEntry] = []
    @Published var showingAddEntry = false
    @Published var editingEntry: FoodEntry?
    
    func addEntry(_ entry: FoodEntry) {
        entries.insert(entry, at: 0)
    }
    
    func updateEntry(_ entry: FoodEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
        }
    }
    
    func deleteEntry(_ entry: FoodEntry) {
        entries.removeAll { $0.id == entry.id }
    }
}
