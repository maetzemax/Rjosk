import SwiftUI

struct YAxis: ChartAxis {
    
    var chart: ChartView
    
    func drawAxis() -> Path {
        Path { path in
            path.move(
                to: CGPoint(
                    x: 0 + chart.axisSpacing,
                    y: 0
                )
            )
            
            // Draw Y-Axis
            path.addLine(
                to: CGPoint(
                    x: 0 + chart.axisSpacing,
                    y: chart.height
                )
            )
        }
    }
    
    func drawLabels() -> some View {
        return ZStack {
            let scaledEntries = chart.applyScaling(chartEntries: chart.entries)
            ForEach(Array(chart.entries.enumerated()), id: \.offset) { entry in
                if let maxEntry = chart.entries.max(by: { $0.y < $1.y }), maxEntry == entry.element {
                    getLabel(posY: scaledEntries[entry.offset].y, valueY: maxEntry.y)
                }
                
                if let minEntry = chart.entries.min(by: { $0.y < $1.y }), minEntry == entry.element {
                    getLabel(posY: scaledEntries[entry.offset].y, valueY: minEntry.y)
                }
            }
        }
    }
    
    private func getLabel(posY: CGFloat, valueY: CGFloat) -> some View {
        let numberFormatter = NumberFormatter()
        
        return Text(numberFormatter.string(from: valueY as NSNumber) ?? "")
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
            .position(x: chart.axisWidth/2, y: chart.height - posY)
    }
}
