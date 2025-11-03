//
//  FoodView.swift
//  GlucoseApp
//
//  Created by Sai Varsha Ravisankar on 10/28/25.
//

import SwiftUI

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
