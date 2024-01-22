import SwiftUI

public struct ChartView: View {
    
    var entries: [ChartEntry] = .exampleSinus
    
    // Width of chart frame
    var width: CGFloat
    
    var chartWidth: CGFloat {
        width - axisSpacing - axisWidth
    }
    
    // Height of chart frame
    var height: CGFloat
    
    var chartHeight: CGFloat {
        height - axisSpacing - axisHeight
    }
    
    var chartStyling: ChartStyling
    
    public init(
        entries: [ChartEntry] = .exampleSinus,
        chartConfig: ChartConfiguration = ChartConfiguration()
    ) {
        self.entries = entries
        self.width = chartConfig.width - chartConfig.horizontalPadding
        self.height = chartConfig.height
        self.axisSpacing = chartConfig.axisSpacing
        self.chartStyling = chartConfig.chartStyling
    }
    
    private var yAxis: YAxis {
        YAxis(chart: self)
    }
    
    private var xAxis: XAxis {
        XAxis(chart: self)
    }
    
    @State var axisWidth: CGFloat = 0
    @State var axisHeight: CGFloat = 0
    
    var axisSpacing: CGFloat
    
    public var body: some View {
        HStack(alignment: .top, spacing: axisSpacing) {
            ZStack {
                yAxis.drawLabels()
                    .foregroundStyle(chartStyling.labelColor)
            }
            .frame(width: axisWidth, height: chartHeight)
            
            VStack(spacing: axisSpacing) {
                ZStack {
                    xAxis.drawAxis()
                        .stroke(chartStyling.axisColor, lineWidth: chartStyling.axisLineWidth)
                    
                    yAxis.drawAxis()
                        .stroke(chartStyling.axisColor, lineWidth: chartStyling.axisLineWidth)
                    
                    drawLine()
                        .stroke(chartStyling.lineColor, lineWidth: chartStyling.lineWidth)
                }
                .frame(width: chartWidth, height: chartHeight)
                
                ZStack {
                    xAxis.drawLabels()
                        .foregroundStyle(chartStyling.labelColor)
                }
                .frame(width: chartWidth, height: axisHeight)
            }
        }
        .frame(width: width, height: height)
        .background(chartStyling.chartBackground)
    }
    
    func drawLine() -> Path {
        Path { path in
            
            var scaledEntries = applyScaling(chartEntries: entries)
            
            path.move(
                to: CGPoint(
                    x: scaledEntries[0].x,
                    y: chartHeight - scaledEntries[0].y
                )
            )
            
            scaledEntries.removeFirst()
            
            for entry in scaledEntries {
                path.addLine(
                    to: CGPoint(
                        x: entry.x,
                        y: chartHeight - entry.y
                    )
                )
            }
        }
    }
    
    func applyScaling(chartEntries: [ChartEntry]) -> [ChartEntry] {
        let minX = chartEntries.min(by: { $0.x < $1.x })?.x ?? 0
        let minY = chartEntries.min(by: { $0.y < $1.y })?.y ?? 0
        
        let maxX = chartEntries.max(by: { $0.x < $1.x })?.x ?? width
        let maxY = chartEntries.max(by: { $0.y < $1.y })?.y ?? height
        
        let scaleRatioWidth = chartWidth / (maxX - minX)
        let scaleRatioHeight = chartHeight / (maxY - minY)
        
        let result = chartEntries.map {
            let x = ($0.x - minX) * scaleRatioWidth
            let y = ($0.y - minY) * scaleRatioHeight
            
            return ChartEntry(x: x, y: y)
        }
        
        return result
    }
}

#Preview {
    ChartView()
}
