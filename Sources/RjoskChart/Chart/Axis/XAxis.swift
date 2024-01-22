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
    
    func drawTicks(x: CGFloat) -> some View {
        
        var minX: CGFloat {
            chart.entries.min(by: { $0.x < $1.x})?.x ?? 0
        }
        
        var maxX: CGFloat {
            chart.entries.max(by: { $0.x < $1.x })?.x ?? chart.width
        }
        
        var scaleRatioWidth: CGFloat {
            chart.chartWidth / (maxX - minX)
        }
        
        var posX: CGFloat {
            (x - minX) * scaleRatioWidth
        }
        
        var posY: CGFloat {
            -chart.axisHeight
        }
        
        return Rectangle()
            .foregroundStyle(chart.chartStyling.axisTickColor)
            .frame(width: chart.chartStyling.axisTickLineWidth, height: 10)
            .position(x: x == maxX ? posX - chart.chartStyling.axisTickLineWidth/2 : posX, y: posY)
    }
    
    func drawGrid(x: CGFloat) -> some View {
        
        var minX: CGFloat {
            chart.entries.min(by: { $0.x < $1.x})?.x ?? 0
        }
        
        var maxX: CGFloat {
            chart.entries.max(by: { $0.x < $1.x })?.x ?? chart.width
        }
        
        var scaleRatioWidth: CGFloat {
            chart.chartWidth / (maxX - minX)
        }
        
        var posX: CGFloat {
            (x - minX) * scaleRatioWidth
        }
        
        var posY: CGFloat {
            -chart.chartHeight / 2 - chart.axisSpacing
        }
        
        return Rectangle()
            .foregroundStyle(chart.chartStyling.axisTickColor)
            .frame(width: chart.chartStyling.axisTickLineWidth, height: chart.chartHeight)
            .position(x: x == maxX ? posX - chart.chartStyling.axisTickLineWidth/2 : posX, y: posY)
    }
    
    func drawLabels() -> some View {
        return ZStack {
            ForEach(getSuitableLabels(), id: \.hashValue) { entry in
                XAxisLabel(x: entry, chart: chart)
                drawTicks(x: entry)
                drawGrid(x: entry)
            }
        }
    }
    
    struct XAxisLabel: View {
        
        @State var labelWidth: CGFloat = 0
        
        let x: CGFloat
        let chart: ChartView
        
        init(x: CGFloat, chart: ChartView) {
            self.x = x
            self.chart = chart
        }
        
        let numberFormatter = NumberFormatter()
        
        var minX: CGFloat {
            chart.entries.min(by: { $0.x < $1.x})?.x ?? 0
        }
        
        var maxX: CGFloat {
            chart.entries.max(by: { $0.x < $1.x })?.x ?? chart.width
        }
        
        var scaleRatioWidth: CGFloat {
            chart.chartWidth / (maxX - minX)
        }
        
        var posX: CGFloat {
            (x - minX) * scaleRatioWidth
        }
        
        var posY: CGFloat {
            chart.axisHeight/2
        }
        
        var body: some View {
            Text(numberFormatter.string(from: x as NSNumber) ?? "")
                .font(.callout)
                .fixedSize(horizontal: true, vertical: false)
                .background {
                    GeometryReader { reader in
                        Color.clear
                            .onAppear {
                                if chart.axisHeight < reader.size.height {
                                    chart.axisHeight = reader.size.height
                                }
                                labelWidth = reader.size.width
                            }
                    }
                }
                .position(x: x == maxX ? posX - labelWidth/2 : posX, y: posY)
        }
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
