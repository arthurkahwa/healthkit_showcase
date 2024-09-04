//
//  StepBarChart.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/20/24.
//

import SwiftUI
import Charts

struct StepBarChart: View {
    var selectedStat: HealthMetricContext
    var chartData: [HealthMetric]
    
    @State private var rawSelectedDate: Date?
    @State private var selectedDay: Date?
    
    var isSteps: Bool { selectedStat == .steps }
    
    var averageStepCount: Double {
        guard !chartData .isEmpty else { return 0 }
        
        let totalSteps = chartData.reduce(0) { $0 + $1.value }
        
        return totalSteps / Double(chartData.count)
    }
    
    var selectedHealthMetric: HealthMetric? {
        guard let rawSelectedDate else { return nil }
        
        return chartData.first {
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
        }
    }
    
    var body: some View {
        ChartContainer(title: "Steps",
                       symbol: "figure.walk",
                       subTitle: "Avereage \(Int(averageStepCount)) Steps",
                       context: .steps,
                       isNavigation: true) {
            
            if chartData.isEmpty {
               ChartEmptyView(systemImageName: "chart.bar",
                              title: "No Data",
                              description: "There is no step data available at this time.")
            }
            else {
                Chart {
                    if let selectedHealthMetric {
                        RuleMark(x: .value("Selected Metric", selectedHealthMetric.date, unit: .day))
                            .foregroundStyle(Color.secondary.opacity(0.4))
                            .offset(y: -12)
                            .annotation(position: .top,
                                        spacing: 0,
                                        overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                                annotationView
                            }
                    }
                    
                    RuleMark(y: .value("Average", averageStepCount))
                        .foregroundStyle(Color.secondary)
                        .lineStyle(.init(lineWidth: 1, dash: [4]))
                    
                    ForEach(chartData) { steps in
                        BarMark(x: .value("Date", steps.date, unit: .day),
                                y: .value("Steps", steps.value)
                        )
                        .foregroundStyle(Color.pink.gradient)
                        .opacity(rawSelectedDate == nil || steps.date == selectedHealthMetric?.date ? 1.0 : 0.4)
                    }
                }
                .frame(height: 150)
                .chartXSelection(value: $rawSelectedDate.animation(.easeIn))
                .chartXAxis {
                    AxisMarks {
                        AxisValueLabel(format: .dateTime.day().month(.defaultDigits))
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine()
                            .foregroundStyle(Color.secondary.opacity(0.4))
                        
                        AxisValueLabel((value.as(Double.self) ?? 0).formatted(.number.notation(.compactName)))
                    }
                }
            }
        }
        .sensoryFeedback(.selection, trigger: selectedDay)
        .onChange(of: rawSelectedDate) { oldValue, newValue in
            if oldValue?.weekDayInt != newValue?.weekDayInt {
                selectedDay = newValue
            }
        }
    }
    
    var annotationView: some View {
        VStack(alignment: .leading) {
            Text(selectedHealthMetric?.date ?? .now, format: .dateTime.weekday(.abbreviated).day().month(.abbreviated))
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            Text(selectedHealthMetric?.value ?? 0, format: .number.precision(.fractionLength(0)))
                .fontWeight(.heavy)
                .foregroundStyle(.pink)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2)
        )
    }
}

#Preview {
    VStack {
        StepBarChart(selectedStat: .steps, chartData: MockData.steps)
        StepBarChart(selectedStat: .steps, chartData: [])
    }
}
