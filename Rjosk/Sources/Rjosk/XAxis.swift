import SwiftUI

struct XAxis: ChartAxis {
    
    var chart: ChartView
    
    func drawAxis() -> Path {
        Path { path in
            // Move to the bottom leading corner
            path.move(
                to: CGPoint(
                    x: 0 + chart.axisSpacing,
                    y: chart.height
                )
            )
            
            // Draw X-Axis
            path.addLine(
                to: CGPoint(
                    x: (chart.width - chart.axisSpacing - chart.axisWidth),
                    y: chart.height
                )
            )
        }
    }
    
    func drawLabels() -> some View {
        return ZStack {
            let scaledEntries = chart.applyScaling(chartEntries: chart.entries)
            ForEach(Array(chart.entries.enumerated()), id: \.offset) { entry in
                if let maxEntry = chart.entries.max(by: { $0.x < $1.x }), maxEntry == entry.element {
                    getLabel(posX: scaledEntries[entry.offset].x, valueX: maxEntry.x)
                }
                
                if let minEntry = chart.entries.min(by: { $0.x < $1.x }), minEntry == entry.element {
                    getLabel(posX: scaledEntries[entry.offset].x, valueX: minEntry.x)
                }
            }
        }
    }
    
    private func getLabel(posX: CGFloat, valueX: CGFloat) -> some View {
        let numberFormatter = NumberFormatter()
        
        return Text(numberFormatter.string(from: valueX as NSNumber) ?? "")
            .font(.callout)
            .fixedSize(horizontal: true, vertical: false)
            .background {
                GeometryReader { reader in
                    Color(.systemBackground)
                        .onAppear {
                            if chart.axisWidth < reader.size.width {
                                chart.axisWidth = reader.size.width
                            }
                        }
                }
            }
            .position(x: posX, y: chart.height + 10)
    }
}
