import SwiftUI

public struct ChartStyling {
    let lineWidth: CGFloat
    let lineColor: Color
    let labelColor: Color
    
    public init(
        lineWidth: CGFloat = 1,
        lineColor: Color = .green,
        labelColor: Color = .primary
    ) {
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.labelColor = labelColor
    }
}

public extension ChartStyling {
    static var `default`: Self = ChartStyling(
        lineWidth: 1,
        lineColor: .green,
        labelColor: .primary
    )
}
