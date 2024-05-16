//
//  DashboardView.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/16/24.
//

import SwiftUI

struct DashboardView: View {
    @State private var selectedStat: HealthMetrcContext = .steps
    var isSteps: Bool { selectedStat == .steps }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing: 20) {
                    Picker("Selected stat", selection: $selectedStat) {
                        ForEach(HealthMetrcContext.allCases) {
                            Text($0.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    VStack { // Overall chart card
                        NavigationLink(value: selectedStat){
                            HStack {
                                VStack(alignment: .leading) {
                                    Label("Steps", systemImage: "figure.walk")
                                        .font(.title3.bold())
                                        .foregroundStyle(.pink)
                                    
                                    Text("Avereage 10k Steps")
                                        .font(.caption)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")                            }
                        }
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 12)
                        
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.secondary)
                            .frame(height: 160)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                    
                    VStack(alignment: .leading) { // Overall chart card
                        VStack(alignment: .leading) {
                            Label("Averages", systemImage: "calendar")
                                .font(.title3.bold())
                                .foregroundStyle(.pink)
                            
                            Text("last 28 days")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                        }
                        .padding(.bottom, 12)
                        
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.secondary)
                            .frame(height: 240)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                }
            }
            .padding()
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetrcContext.self) { metric in
                HealthDetailListView(metric: metric)
            }
        }
        .tint( isSteps ? .pink : .indigo)
    }
}

#Preview {
    DashboardView()
}