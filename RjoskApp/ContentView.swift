import SwiftUI
import Rjosk

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
                chartStyling: chartStyling
            )
        )
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ContentView()
}
