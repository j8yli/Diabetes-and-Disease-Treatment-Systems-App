//
//  ContentView.swift
//  GlucoseApp
//
//  Created by Victor  Andrade on 10/17/25.
//

import SwiftUI

struct ActivityEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let type: String
    let duration: Int
    let intensity: String
    let bloodGlucoseBefore: Int?
    let bloodGlucoseAfter: Int?
    
    init(id: UUID = UUID(), date: Date = Date(), type: String, duration: Int, intensity: String, bloodGlucoseBefore: Int? = nil, bloodGlucoseAfter: Int? = nil) {
        self.id = id
        self.date = date
        self.type = type
        self.duration = duration
        self.intensity = intensity
        self.bloodGlucoseBefore = bloodGlucoseBefore
        self.bloodGlucoseAfter = bloodGlucoseAfter
    }
}

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

struct SleepEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let bedTime: Date
    let wakeTime: Date
    let quality: Int
    let bloodGlucoseBedtime: Int?
    let bloodGlucoseWaking: Int?
    let notes: String
    
    init(id: UUID = UUID(), date: Date = Date(), bedTime: Date, wakeTime: Date, quality: Int, bloodGlucoseBedtime: Int? = nil, bloodGlucoseWaking: Int? = nil, notes: String = "") {
        self.id = id
        self.date = date
        self.bedTime = bedTime
        self.wakeTime = wakeTime
        self.quality = quality
        self.bloodGlucoseBedtime = bloodGlucoseBedtime
        self.bloodGlucoseWaking = bloodGlucoseWaking
        self.notes = notes
    }
    
    var duration: TimeInterval {
        wakeTime.timeIntervalSince(bedTime)
    }
}

// MARK: - ViewModels

class ActivityViewModel: ObservableObject {
    @Published var entries: [ActivityEntry] = []
    @Published var showingAddEntry = false
    @Published var editingEntry: ActivityEntry?
    
    func addEntry(_ entry: ActivityEntry) {
        entries.insert(entry, at: 0)
    }
    
    func updateEntry(_ entry: ActivityEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
        }
    }
    
    func deleteEntry(_ entry: ActivityEntry) {
        entries.removeAll { $0.id == entry.id }
    }
}

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

class SleepViewModel: ObservableObject {
    @Published var entries: [SleepEntry] = []
    @Published var showingAddEntry = false
    @Published var editingEntry: SleepEntry?
    
    func addEntry(_ entry: SleepEntry) {
        entries.insert(entry, at: 0)
    }
    
    func updateEntry(_ entry: SleepEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
        }
    }
    
    func deleteEntry(_ entry: SleepEntry) {
        entries.removeAll { $0.id == entry.id }
    }
}

// MARK: - Reusable Components

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 80))
                .foregroundColor(color)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct StatBadge: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
            Text("\(value) \(label)")
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

struct BloodGlucoseCard: View {
    let before: Int
    let after: Int
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Before")
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack(spacing: 4) {
                    Image(systemName: "drop.fill")
                        .font(.caption)
                        .foregroundColor(.red)
                    Text("\(before) mg/dL")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            
            Image(systemName: "arrow.right")
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("After")
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack(spacing: 4) {
                    Image(systemName: "drop.fill")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Text("\(after) mg/dL")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(10)
    }
}

struct IntensityButton: View {
    let level: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(level)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? .white : intensityColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isSelected ? intensityColor : intensityColor.opacity(0.1))
                .cornerRadius(10)
        }
    }
    
    var intensityColor: Color {
        switch level {
        case "Low": return .green
        case "Medium": return .orange
        case "High": return .red
        default: return .gray
        }
    }
}

struct MacroIndicator: View {
    let icon: String
    let value: Int
    let unit: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            Text("\(value)\(unit)")
                .font(.headline)
                .fontWeight(.bold)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Main Content View

struct ContentView: View {
    @StateObject private var activityVM = ActivityViewModel()
    @StateObject private var foodVM = FoodViewModel()
    @StateObject private var sleepVM = SleepViewModel()
    
    var body: some View {
        TabView {
            ActivityView()
                .environmentObject(activityVM)
                .tabItem {
                    Label("Activity", systemImage: "figure.run")
                }
            
            FoodView()
                .environmentObject(foodVM)
                .tabItem {
                    Label("Food", systemImage: "fork.knife")
                }
            
            SleepView()
                .environmentObject(sleepVM)
                .tabItem {
                    Label("Sleep", systemImage: "moon.stars.fill")
                }
        }
        .accentColor(.purple)
    }
}

// MARK: - Activity Views

struct ActivityView: View {
    @EnvironmentObject var vm: ActivityViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.orange.opacity(0.1), Color.pink.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    if vm.entries.isEmpty {
                        EmptyStateView(
                            icon: "figure.run.circle.fill",
                            title: "No Activities Yet",
                            message: "Start tracking your activities!",
                            color: .orange
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(vm.entries) { entry in
                                    ActivityCardView(entry: entry)
                                        .onTapGesture {
                                            vm.editingEntry = entry
                                        }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("🏃 Activity Log")
            .toolbar {
                Button(action: { vm.showingAddEntry = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
            }
            .sheet(isPresented: $vm.showingAddEntry) {
                AddActivityView(editingEntry: nil)
            }
            .sheet(item: $vm.editingEntry) { entry in
                AddActivityView(editingEntry: entry)
            }
        }
    }
}

struct ActivityCardView: View {
    let entry: ActivityEntry
    @EnvironmentObject var vm: ActivityViewModel
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(intensityColor(entry.intensity).opacity(0.2))
                        .frame(width: 50, height: 50)
                    Image(systemName: activityIcon(entry.type))
                        .font(.title2)
                        .foregroundColor(intensityColor(entry.intensity))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.type)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(entry.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
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
            
            HStack(spacing: 20) {
                StatBadge(icon: "clock.fill", value: "\(entry.duration)", label: "min", color: .blue)
                StatBadge(icon: "flame.fill", value: entry.intensity, label: "", color: intensityColor(entry.intensity))
            }
            
            if let before = entry.bloodGlucoseBefore, let after = entry.bloodGlucoseAfter {
                BloodGlucoseCard(before: before, after: after)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .alert("Delete Activity", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                vm.deleteEntry(entry)
            }
        } message: {
            Text("Are you sure you want to delete this activity?")
        }
    }
    
    func activityIcon(_ type: String) -> String {
        switch type {
        case "Walking": return "figure.walk"
        case "Running": return "figure.run"
        case "Cycling": return "bicycle"
        case "Swimming": return "figure.pool.swim"
        case "Sports": return "sportscourt.fill"
        default: return "figure.flexibility"
        }
    }
    
    func intensityColor(_ intensity: String) -> Color {
        switch intensity {
        case "Low": return .green
        case "Medium": return .orange
        case "High": return .red
        default: return .gray
        }
    }
}

struct AddActivityView: View {
    @EnvironmentObject var vm: ActivityViewModel
    @Environment(\.dismiss) var dismiss
    
    let editingEntry: ActivityEntry?
    
    @State private var type: String
    @State private var duration: Int
    @State private var intensity: String
    @State private var bgBefore: String
    @State private var bgAfter: String
    
    let activityTypes = ["Walking", "Running", "Cycling", "Swimming", "Sports", "Other"]
    let intensities = ["Low", "Medium", "High"]
    
    init(editingEntry: ActivityEntry?) {
        self.editingEntry = editingEntry
        _type = State(initialValue: editingEntry?.type ?? "Walking")
        _duration = State(initialValue: editingEntry?.duration ?? 30)
        _intensity = State(initialValue: editingEntry?.intensity ?? "Medium")
        _bgBefore = State(initialValue: editingEntry?.bloodGlucoseBefore.map(String.init) ?? "")
        _bgAfter = State(initialValue: editingEntry?.bloodGlucoseAfter.map(String.init) ?? "")
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.orange.opacity(0.15), Color.pink.opacity(0.15)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                Form {
                    Section {
                        Picker("Activity Type", selection: $type) {
                            ForEach(activityTypes, id: \.self) { activityType in
                                HStack {
                                    Image(systemName: iconFor(activityType))
                                    Text(activityType)
                                }
                                .tag(activityType)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Duration: \(duration) minutes")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Slider(value: Binding(
                                get: { Double(duration) },
                                set: { duration = Int($0) }
                            ), in: 5...180, step: 5)
                            .accentColor(.orange)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Intensity")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            HStack(spacing: 12) {
                                ForEach(intensities, id: \.self) { level in
                                    IntensityButton(level: level, isSelected: intensity == level) {
                                        intensity = level
                                    }
                                }
                            }
                        }
                    } header: {
                        Text("Activity Details")
                            .foregroundColor(.orange)
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
                    } header: {
                        Text("Blood Glucose")
                            .foregroundColor(.orange)
                    }
                    .listRowBackground(Color.white.opacity(0.8))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(editingEntry == nil ? "Log Activity" : "Edit Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.orange)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(editingEntry == nil ? "Save" : "Update") {
                        if let existing = editingEntry {
                            let updated = ActivityEntry(
                                id: existing.id,
                                date: existing.date,
                                type: type,
                                duration: duration,
                                intensity: intensity,
                                bloodGlucoseBefore: Int(bgBefore),
                                bloodGlucoseAfter: Int(bgAfter)
                            )
                            vm.updateEntry(updated)
                        } else {
                            let entry = ActivityEntry(
                                type: type,
                                duration: duration,
                                intensity: intensity,
                                bloodGlucoseBefore: Int(bgBefore),
                                bloodGlucoseAfter: Int(bgAfter)
                            )
                            vm.addEntry(entry)
                        }
                        dismiss()
                    }
                    .foregroundColor(.orange)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    func iconFor(_ type: String) -> String {
        switch type {
        case "Walking": return "figure.walk"
        case "Running": return "figure.run"
        case "Cycling": return "bicycle"
        case "Swimming": return "figure.pool.swim"
        case "Sports": return "sportscourt.fill"
        default: return "figure.flexibility"
        }
    }
}

// MARK: - Food Views

struct FoodView: View {
    @EnvironmentObject var vm: FoodViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.green.opacity(0.1), Color.blue.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    if vm.entries.isEmpty {
                        EmptyStateView(
                            icon: "fork.knife.circle.fill",
                            title: "No Meals Logged",
                            message: "Start tracking your meals!",
                            color: .green
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(vm.entries) { entry in
                                    FoodCardView(entry: entry)
                                        .onTapGesture {
                                            vm.editingEntry = entry
                                        }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("🍎 Food Log")
            .toolbar {
                Button(action: { vm.showingAddEntry = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
            .sheet(isPresented: $vm.showingAddEntry) {
                AddFoodView(editingEntry: nil)
            }
            .sheet(item: $vm.editingEntry) { entry in
                AddFoodView(editingEntry: entry)
            }
        }
    }
}

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

// MARK: - Sleep Views

struct SleepView: View {
    @EnvironmentObject var vm: SleepViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.indigo.opacity(0.1), Color.purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    if vm.entries.isEmpty {
                        EmptyStateView(
                            icon: "moon.stars.circle.fill",
                            title: "No Sleep Logged",
                            message: "Start tracking your sleep!",
                            color: .indigo
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(vm.entries) { entry in
                                    SleepCardView(entry: entry)
                                        .onTapGesture {
                                            vm.editingEntry = entry
                                        }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("😴 Sleep Log")
            .toolbar {
                Button(action: { vm.showingAddEntry = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.indigo)
                }
            }
            .sheet(isPresented: $vm.showingAddEntry) {
                AddSleepView(editingEntry: nil)
            }
            .sheet(item: $vm.editingEntry) { entry in
                AddSleepView(editingEntry: entry)
            }
        }
    }
}

struct SleepCardView: View {
    let entry: SleepEntry
    @EnvironmentObject var vm: SleepViewModel
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.indigo.opacity(0.2))
                        .frame(width: 50, height: 50)
                    Image(systemName: "moon.stars.fill")
                        .font(.title2)
                        .foregroundColor(.indigo)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.date, style: .date)
                        .font(.title3)
                        .fontWeight(.bold)
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= entry.quality ? "star.fill" : "star")
                                .font(.caption)
                                .foregroundColor(.yellow)
                        }
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
                HStack(spacing: 4) {
                    Image(systemName: "moon.fill")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Text(entry.bedTime, style: .time)
                        .font(.subheadline)
                }
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundColor(.gray)
                HStack(spacing: 4) {
                    Image(systemName: "sun.max.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                    Text(entry.wakeTime, style: .time)
                        .font(.subheadline)
                }
            }
            
            StatBadge(icon: "clock.fill", value: formatDuration(entry.duration), label: "", color: .purple)
            
            if let bedtime = entry.bloodGlucoseBedtime, let waking = entry.bloodGlucoseWaking {
                BloodGlucoseCard(before: bedtime, after: waking)
            }
            
            if !entry.notes.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Notes")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fontWeight(.semibold)
                    Text(entry.notes)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .alert("Delete Sleep Entry", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                vm.deleteEntry(entry)
            }
        } message: {
            Text("Are you sure you want to delete this sleep entry?")
        }
    }
    
    func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}

struct AddSleepView: View {
    @EnvironmentObject var vm: SleepViewModel
    @Environment(\.dismiss) var dismiss
    
    let editingEntry: SleepEntry?
    
    @State private var bedTime: Date
    @State private var wakeTime: Date
    @State private var quality: Int
    @State private var bgBedtime: String
    @State private var bgWaking: String
    @State private var notes: String
    
    init(editingEntry: SleepEntry?) {
        self.editingEntry = editingEntry
        _bedTime = State(initialValue: editingEntry?.bedTime ?? Date())
        _wakeTime = State(initialValue: editingEntry?.wakeTime ?? Date())
        _quality = State(initialValue: editingEntry?.quality ?? 3)
        _bgBedtime = State(initialValue: editingEntry?.bloodGlucoseBedtime.map(String.init) ?? "")
        _bgWaking = State(initialValue: editingEntry?.bloodGlucoseWaking.map(String.init) ?? "")
        _notes = State(initialValue: editingEntry?.notes ?? "")
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.indigo.opacity(0.15), Color.purple.opacity(0.15)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                Form {
                    Section {
                        DatePicker("Bedtime", selection: $bedTime, displayedComponents: [.date, .hourAndMinute])
                        
                        DatePicker("Wake Time", selection: $wakeTime, displayedComponents: [.date, .hourAndMinute])
                    } header: {
                        Text("Sleep Times")
                            .foregroundColor(.indigo)
                    }
                    .listRowBackground(Color.white.opacity(0.8))
                    
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Quality")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                HStack(spacing: 4) {
                                    ForEach(1...5, id: \.self) { star in
                                        Image(systemName: star <= quality ? "star.fill" : "star")
                                            .foregroundColor(.yellow)
                                    }
                                }
                            }
                            Slider(value: Binding(
                                get: { Double(quality) },
                                set: { quality = Int($0) }
                            ), in: 1...5, step: 1)
                            .accentColor(.indigo)
                        }
                    } header: {
                        Text("Sleep Quality")
                            .foregroundColor(.indigo)
                    }
                    .listRowBackground(Color.white.opacity(0.8))
                    
                    Section {
                        HStack {
                            Image(systemName: "drop.fill")
                                .foregroundColor(.red)
                            TextField("Bedtime (mg/dL)", text: $bgBedtime)
                                .keyboardType(.numberPad)
                        }
                        
                        HStack {
                            Image(systemName: "drop.fill")
                                .foregroundColor(.blue)
                            TextField("Waking (mg/dL)", text: $bgWaking)
                                .keyboardType(.numberPad)
                        }
                    } header: {
                        Text("Blood Glucose")
                            .foregroundColor(.indigo)
                    }
                    .listRowBackground(Color.white.opacity(0.8))
                    
                    Section {
                        TextEditor(text: $notes)
                            .frame(height: 100)
                    } header: {
                        Text("Notes")
                            .foregroundColor(.indigo)
                    }
                    .listRowBackground(Color.white.opacity(0.8))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(editingEntry == nil ? "Log Sleep" : "Edit Sleep")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.indigo)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(editingEntry == nil ? "Save" : "Update") {
                        if let existing = editingEntry {
                            let updated = SleepEntry(
                                id: existing.id,
                                date: existing.date,
                                bedTime: bedTime,
                                wakeTime: wakeTime,
                                quality: quality,
                                bloodGlucoseBedtime: Int(bgBedtime),
                                bloodGlucoseWaking: Int(bgWaking),
                                notes: notes
                            )
                            vm.updateEntry(updated)
                        } else {
                            let entry = SleepEntry(
                                bedTime: bedTime,
                                wakeTime: wakeTime,
                                quality: quality,
                                bloodGlucoseBedtime: Int(bgBedtime),
                                bloodGlucoseWaking: Int(bgWaking),
                                notes: notes
                            )
                            vm.addEntry(entry)
                        }
                        dismiss()
                    }
                    .foregroundColor(.indigo)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}
