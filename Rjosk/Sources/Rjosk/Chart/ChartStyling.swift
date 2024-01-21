import SwiftUI

public struct ChartStyling {
    let lineWidth: CGFloat
    let lineColor: Color
    
    let labelColor: Color
    
    let chartBackground: Color
    
    let axisColor: Color
    let axisLineWidth: CGFloat
    
    public init(
        lineWidth: CGFloat = 1,
        lineColor: Color = .green,
        labelColor: Color = .primary,
        chartBackground: Color = Color(uiColor: .secondarySystemBackground),
        axisColor: Color = Color.primary,
        axisLineWidth: CGFloat = 1
    ) {
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.labelColor = labelColor
        self.chartBackground = chartBackground
        self.axisColor = axisColor
        self.axisLineWidth = axisLineWidth
    }
}
