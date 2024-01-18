//
//  ContentView.swift
//  Rjosk
//
//  Created by Max Maetze on 17.01.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 40) {
            ChartView(paddingHorizontal: 0)
            
            ChartView(
                width: 300,
                height: 100
            )
        }
    }
}

struct ChartEntry {
    let x: CGFloat
    let y: CGFloat
}

struct XAxisLabelRender: UIViewRepresentable {
    
    let entries: [ChartEntry]
    
    let axisWidth: CGFloat
    let chartHeight: CGFloat
    
    init(
        entries: [ChartEntry],
        axisWidth: CGFloat = 0,
        chartHeight: CGFloat
    ) {
        self.entries = entries
        self.axisWidth = axisWidth
        self.chartHeight = chartHeight
    }
    
    func updateUIView(_ uiView: XAxisLabelView, context: Context) {
        uiView.draw(uiView.bounds)
    }
    
    func makeUIView(context: Context) -> XAxisLabelView {
        XAxisLabelView(
            entries: entries,
            axisWidth: axisWidth,
            chartHeight: chartHeight
        )
    }
    
    class XAxisLabelView: UIView {
        
        var entries: [ChartEntry]
        
        var axisWidth: CGFloat
        var chartHeight: CGFloat
        
        init(
            entries: [ChartEntry],
            axisWidth: CGFloat = 0,
            chartHeight: CGFloat
        ) {
            self.entries = entries
            self.axisWidth = axisWidth
            self.chartHeight = chartHeight
            
            super.init(
                frame: CGRect(
                    x: 0,
                    y: 0,
                    width: axisWidth,
                    height: chartHeight
                )
            )
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func draw(_ rect: CGRect) {
            let ctx = UIGraphicsGetCurrentContext()
            
            let textAttrs: [NSAttributedString.Key : Any] = [
                .font: UIFont.preferredFont(
                    forTextStyle: .headline
                ),
                .foregroundColor: UIColor.label,
                .backgroundColor: UIColor.systemBackground
            ]
            
            let label: UILabel = UILabel(frame: rect)
            label.text = "31"
            
            // Calculate the bounding box and adjust for the center location
            let labelRect = label.text!.boundingRect(
                with: CGSize(
                    width: axisWidth,
                    height: 20
                ),
                attributes: textAttrs,
                context: nil
            )
            
            label.text!.draw(
                in: labelRect,
                withAttributes: textAttrs
            )
        }
    }
    
}

struct ChartView: View {
    
    var entries: [ChartEntry] = .example
    
    // Width of chart frame
    private var width: CGFloat
    
    // Height of chart frame
    private var height: CGFloat
    
    init(
        width: CGFloat = UIScreen.main.bounds.width,
        height: CGFloat = 300,
        paddingHorizontal: CGFloat = 10,
        paddingVertical: CGFloat = 0
    ) {
        self.width = width - paddingHorizontal
        self.height = height - paddingVertical
    }
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    private var axisWidth: CGFloat = 100
    private var axisSpacing: CGFloat = 10
    
    var body: some View {
        HStack(spacing: axisSpacing) {
            XAxisLabelRender(
                entries: entries,
                axisWidth: axisWidth,
                chartHeight: height
            )
            .frame(width: axisWidth - axisSpacing, height: height)
            
            ZStack {
                drawXAxis()
                    .stroke(.primary, lineWidth: 3)
                
                drawLeftYAxis()
                    .stroke(.primary, lineWidth: 3)
                
                drawLine()
                    .stroke(.green, lineWidth: 3)
            }
            .frame(width: width - axisWidth - axisSpacing, height: height)
        }
        .frame(width: width, height: height)
    }
    
    func getSuitableXLabels(entries _: [ChartEntry]) -> [ChartEntry] {
        []
    }
    
    func drawLine() -> Path {
        Path { path in
            
            let entries = applyScaling(chartEntries: entries)
            
            // Move to the bottom leading corner
            path.move(
                to: CGPoint(
                    x: entries[0].x,
                    y: entries[0].y
                )
            )
            
            for entry in entries {
                // Draw X-Axis
                path.addLine(
                    to: CGPoint(
                        x: entry.x,
                        y: entry.y
                    )
                )
            }
        }
    }
    
    func drawXAxis() -> Path {
        Path { path in
            // Move to the bottom leading corner
            path.move(
                to: CGPoint(
                    x: 0,
                    y: height
                )
            )
            
            // Draw X-Axis
            path.addLine(
                to: CGPoint(
                    x: (width - axisSpacing - axisWidth),
                    y: height
                )
            )
        }
    }
    
    func drawLeftYAxis() -> Path {
        Path { path in
            // Move to the bottom leading corner
            path.move(
                to: CGPoint(
                    x: 0,
                    y: height
                )
            )
            
            // Draw Y-Axis
            path.addLine(
                to: CGPoint(
                    x: 0,
                    y: 0
                )
            )
        }
    }
    
    func applyScaling(chartEntries: [ChartEntry]) -> [ChartEntry] {
        let maxX = chartEntries.max(by: { $0.x < $1.x })?.x
        let maxY = chartEntries.max(by: { $0.y < $1.y })?.y
        
        let chartWidth: CGFloat = width - axisSpacing - axisWidth
        
        let scaleRatioWidth = chartWidth / ((maxX ?? width))
        let scaleRatioHeight = height / (maxY ?? height)
        
        let result = chartEntries.map {
            let x = ($0.x * scaleRatioWidth)
            let y = height - $0.y * scaleRatioHeight
            
            return ChartEntry(
                x: x,
                y: y
            )
        }
        
        return result
    }
}

extension Array<ChartEntry> {
    static var example: [ChartEntry] {
        var entries: [ChartEntry] = []
        for index in 0..<30 {
            entries.append(
                ChartEntry(
                    x: CGFloat(index),
                    y: .random(in: 0..<200)
                )
            )
        }
        
        return entries
    }
}

#Preview {
    ContentView()
}
