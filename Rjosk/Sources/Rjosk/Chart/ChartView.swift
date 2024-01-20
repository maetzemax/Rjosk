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
    
    public init(
        entries: [ChartEntry] = .exampleSinus,
        width: CGFloat = UIScreen.main.bounds.width,
        height: CGFloat = 300,
        paddingHorizontal: CGFloat = 20
    ) {
        self.entries = entries
        self.width = width - paddingHorizontal
        self.height = height
    }
    
    private var yAxis: YAxis {
        YAxis(chart: self)
    }
    
    private var xAxis: XAxis {
        XAxis(chart: self)
    }
    
    @State var axisWidth: CGFloat = 0
    @State var axisHeight: CGFloat = 0
    
    var axisSpacing: CGFloat = 10
    
    public var body: some View {
        HStack(alignment: .top, spacing: axisSpacing) {
            ZStack {
                yAxis.drawLabels()
            }
            .frame(width: axisWidth, height: chartHeight)
            
            VStack(spacing: axisSpacing) {
                ZStack {
                    xAxis.drawAxis()
                        .stroke(.primary, lineWidth: 2)
                    
                    yAxis.drawAxis()
                        .stroke(.primary, lineWidth: 2)
                    
                    drawLine()
                        .stroke(.green, lineWidth: 1.5)
                }
                .frame(width: chartWidth, height: chartHeight)
                
                ZStack {
                    xAxis.drawLabels()
                }
                .frame(width: chartWidth, height: axisHeight)
            }
        }
        .frame(width: width, height: height)
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
