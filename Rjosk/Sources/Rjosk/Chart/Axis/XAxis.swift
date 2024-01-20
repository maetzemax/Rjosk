import SwiftUI

struct XAxis: ChartAxis {
    
    var chart: ChartView
    
    func drawAxis() -> Path {
        Path { path in
            // Move to the bottom leading corner
            path.move(
                to: CGPoint(
                    x: 0,
                    y: chart.chartHeight
                )
            )
            
            // Draw X-Axis
            path.addLine(
                to: CGPoint(
                    x: chart.chartWidth,
                    y: chart.chartHeight
                )
            )
        }
    }
    
    func drawLabels() -> some View {
        return ZStack {
            ForEach(getSuitableLabels(), id: \.hashValue) { entry in
                getLabel(x: entry)
            }
        }
    }
    
    private func getLabel(x: CGFloat) -> some View {
        let numberFormatter = NumberFormatter()
        
        let minX = chart.entries.min(by: { $0.x < $1.x })?.x ?? 0
        let maxX = chart.entries.max(by: { $0.x < $1.x })?.x ?? chart.width
        
        let scaleRatioWidth = chart.chartWidth / (maxX - minX)
        
        let posX = (x - minX) * scaleRatioWidth
        let posY = chart.axisHeight/2
            
        return Text(numberFormatter.string(from: x as NSNumber) ?? "")
            .font(.callout)
            .fixedSize(horizontal: true, vertical: false)
            .background {
                GeometryReader { reader in
                    Color(.systemBackground)
                        .onAppear {
                            if chart.axisHeight < reader.size.height {
                                chart.axisHeight = reader.size.height
                            }
                        }
                }
            }
            .position(x: posX, y: posY)
    }
    
    private func getSuitableLabels() -> [CGFloat] {
        var labels: [CGFloat] = []
        
        let minX = chart.entries.min(by: { $0.x < $1.x})?.x
        let maxX = chart.entries.max(by: { $0.x < $1.x})?.x
        
        guard let minX, let maxX else {
            return labels
        }
        
        labels.append(minX)
        labels.append(maxX)
        
        let halfX = chart.entries[(chart.entries.count - 1) / 2].x
        
        labels.append(halfX)
        
        return labels
    }
}
