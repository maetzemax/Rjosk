import SwiftUI
import RjoskChart

struct ContentView: View {
    
    let chartStyling: ChartStyling = ChartStyling(
        lineWidth: 3,
        lineColor: .green,
        labelColor: .primary,
        chartBackground: .secondary,
        axisColor: .primary,
        axisTickColor: .pink,
        axisLineWidth: 1,
        axisTickLineWidth: 2
    )
    
    var body: some View {
        ChartView(
            chartConfig: ChartConfiguration(
                chartStyling: chartStyling
            )
        )
    }
}

#Preview {
    ContentView()
}
