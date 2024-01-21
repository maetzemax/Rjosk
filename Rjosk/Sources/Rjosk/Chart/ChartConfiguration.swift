import UIKit

public struct ChartConfiguration {
    let chartStyling: ChartStyling
    let height: CGFloat
    let width: CGFloat
    let horizontalPadding: CGFloat
    let axisSpacing: CGFloat
    
    public init(
        chartStyling: ChartStyling = .default,
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

public extension ChartConfiguration {
    static var `default`: Self = ChartConfiguration(
        chartStyling: .default,
        height: 300,
        width: UIScreen.main.bounds.width,
        horizontalPadding: 20,
        axisSpacing: 20
    )
}
