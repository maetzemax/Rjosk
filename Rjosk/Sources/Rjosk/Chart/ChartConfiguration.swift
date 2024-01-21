import UIKit

public struct ChartConfiguration {
    let chartStyling: ChartStyling
    let height: CGFloat
    let width: CGFloat
    let horizontalPadding: CGFloat
    let axisSpacing: CGFloat
    
    public init(
        chartStyling: ChartStyling = ChartStyling(),
        height: CGFloat = 300,
        width: CGFloat = UIScreen.main.bounds.width,
        horizontalPadding: CGFloat = 20,
        axisSpacing: CGFloat = 20
    ) {
        self.chartStyling = chartStyling
        self.height = height
        self.width = width
        self.horizontalPadding = horizontalPadding
        self.axisSpacing = axisSpacing
    }
}
