//
//  DashboardView.swift
//  GlucoseApp
//
//  Created by Joy Li on 10/30/25.
//

import SwiftUI
import Charts

struct DashboardView: View {
    @EnvironmentObject var activityVM: ActivityViewModel
    @EnvironmentObject var foodVM: FoodViewModel
    @EnvironmentObject var sleepVM: SleepViewModel
    
    // Today's date
    private var today: Date { Date() }
    
    // MARK: - Computed Stats
    
    private var todayActivityDuration: Int {
        activityVM.entries
            .filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
            .reduce(0) { $0 + $1.duration }
    }
    
    private var todayCalories: Int {
        foodVM.entries
            .filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
            .reduce(0) { $0 + $1.carbs * 4 + $1.protein * 4 + $1.fat * 9 } // simple macro calories
    }
    
    private var todaySleepHours: Double {
        sleepVM.entries
            .filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
            .reduce(0) { $0 + $1.duration / 3600 } // in hours
    }
    
    private var todayBloodGlucose: String {
        let allBGs = activityVM.entries.compactMap { $0.bloodGlucoseAfter } +
                     foodVM.entries.compactMap { $0.bloodGlucoseAfter } +
                     sleepVM.entries.compactMap { $0.bloodGlucoseWaking }
        
        guard !allBGs.isEmpty else { return "--" }
        let avg = allBGs.reduce(0, +) / allBGs.count
        return "\(avg) mg/dL"
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    Text("📊 Today's Overview")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    // Stat Cards
                    HStack(spacing: 16) {
                        StatBadge(icon: "drop.fill", value: todayBloodGlucose, label: "Glucose", color: .red)
                        StatBadge(icon: "moon.fill", value: String(format: "%.1f", todaySleepHours), label: "hrs sleep", color: .purple)
                    }
                    
                    HStack(spacing: 16) {
                        StatBadge(icon: "flame.fill", value: "\(todayCalories)", label: "calories", color: .orange)
                        StatBadge(icon: "figure.run", value: "\(todayActivityDuration)", label: "min activity", color: .green)
                    }
                    
                    // Charts
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Activity Duration (min)")
                            .font(.headline)
                        Chart {
                            ForEach(activityVM.entries.prefix(7), id: \.id) { entry in
                                BarMark(
                                    x: .value("Date", entry.date, unit: .day),
                                    y: .value("Duration", entry.duration)
                                )
                                .foregroundStyle(.green.gradient)
                            }
                        }
                        .frame(height: 150)
                        
                        Text("Calories Intake")
                            .font(.headline)
                        Chart {
                            ForEach(foodVM.entries.prefix(7), id: \.id) { entry in
                                BarMark(
                                    x: .value("Date", entry.date, unit: .day),
                                    y: .value("Calories", entry.carbs * 4 + entry.protein * 4 + entry.fat * 9)
                                )
                                .foregroundStyle(.orange.gradient)
                            }
                        }
                        .frame(height: 150)
                        
                        Text("Sleep Hours")
                            .font(.headline)
                        Chart {
                            ForEach(sleepVM.entries.prefix(7), id: \.id) { entry in
                                BarMark(
                                    x: .value("Date", entry.date, unit: .day),
                                    y: .value("Hours", entry.duration / 3600)
                                )
                                .foregroundStyle(.purple.gradient)
                            }
                        }
                        .frame(height: 150)
                    }
                    .padding(.top)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("🏠 Dashboard")
        }
    }
}
