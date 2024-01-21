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
                YAxisLabel(y: entry, chart: chart)
            }
        }
    }
    
    struct YAxisLabel: View {
        
        @State var labelHeight: CGFloat = 0
        
        let y: CGFloat
        let chart: ChartView
        
        init(y: CGFloat, chart: ChartView) {
            self.y = y
            self.chart = chart
        }
        
        let numberFormatter = NumberFormatter()
        
        var minY: CGFloat {
            chart.entries.min(by: { $0.y < $1.y })?.y ?? 0
        }
        
        var maxY: CGFloat {
            chart.entries.max(by: { $0.y < $1.y })?.y ?? chart.height
        }
        
        var scaleRatioHeight: CGFloat {
            chart.chartHeight / (maxY - minY)
        }
        
        var posX: CGFloat {
            chart.axisWidth / 2
        }
        var posY: CGFloat {
            (y - minY) * scaleRatioHeight
        }
        
        var body: some View {
            Text(numberFormatter.string(from: y as NSNumber) ?? "")
                .font(.callout)
                .fixedSize(horizontal: true, vertical: false)
                .background {
                    GeometryReader { reader in
                        Color.clear
                            .onAppear {
                                if chart.axisWidth < reader.size.width {
                                    chart.axisWidth = reader.size.width
                                }
                                labelHeight = reader.size.height
                            }
                    }
                }
                .position(x: posX, y: chart.chartHeight - (y == maxY ? posY - labelHeight/2 : posY))
        }
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
