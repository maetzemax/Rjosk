import SwiftUI

struct YAxis: ChartAxis {
    
    var chart: ChartView
    
    func drawAxis() -> Path {
        Path { path in
            path.move(
                to: CGPoint(
                    x: 0,
                    y: 0
                )
            )
            
            // Draw Y-Axis
            path.addLine(
                to: CGPoint(
                    x: 0,
                    y: chart.chartHeight
                )
            )
        }
    }
    
    func drawLabels() -> some View {
        return ZStack {
            ForEach(getSuitableLabels(), id: \.hashValue) { entry in
                getLabel(y: entry)
            }
        }
    }
    
    private func getLabel(y: CGFloat) -> some View {
        let numberFormatter = NumberFormatter()
        
        let minY = chart.entries.min(by: { $0.y < $1.y })?.y ?? 0
        let maxY = chart.entries.max(by: { $0.y < $1.y })?.y ?? chart.height
        
        let scaleRatioHeight = chart.chartHeight / (maxY - minY)
        
        let posX = chart.axisWidth / 2
        let posY = (y - minY) * scaleRatioHeight
        
        return Text(numberFormatter.string(from: y as NSNumber) ?? "")
            .font(.callout)
            .fixedSize(horizontal: true, vertical: false)
            .background {
                GeometryReader { reader in
                    Color.clear
                        .onAppear {
                            if chart.axisWidth < reader.size.width {
                                chart.axisWidth = reader.size.width
                            }
                        }
                }
            }
            .position(x: posX, y: chart.chartHeight - posY)
    }
    
    private func getSuitableLabels() -> [CGFloat] {
        var labels: [CGFloat] = []
        
        let minY = chart.entries.min(by: { $0.y < $1.y})?.y
        let maxY = chart.entries.max(by: { $0.y < $1.y})?.y
        
        guard let minY, let maxY else {
            return labels
        }
        
        labels.append(minY)
        labels.append(maxY)
        
        let halfY = (minY + maxY) / 2
        
        labels.append(halfY)
        
        return labels
    }
}
