import SwiftUI
import RjoskChart

struct ContentView: View {
    
    let chartStyling: ChartStyling = ChartStyling(
        lineWidth: 2,
        lineColor: .green,
        labelColor: .white,
        chartBackground: .brown,
        axisColor: .white,
        axisLineWidth: 1
    )
    
    var body: some View {
        ChartView(
            chartConfig: ChartConfiguration(
                chartStyling: chartStyling,
                horizontalPadding: 100
            )
        )
    }
}

#Preview {
    ContentView()
}
