import SwiftUI
import Rjosk

struct ContentView: View {
    
    let chartStyling: ChartStyling = ChartStyling(
        lineWidth: 2,
        lineColor: .pink,
        labelColor: .gray
    )
    
    var body: some View {
        VStack {
            ChartView(
                chartConfig: ChartConfiguration(
                    chartStyling: chartStyling,
                    horizontalPadding: 40,
                    axisSpacing: 20
                )
            )
                
            ChartView()
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ContentView()
}
