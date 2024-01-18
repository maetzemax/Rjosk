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
            ChartView(paddingHorizontal: 100)
            
            ChartView(
                width: 500,
                height: 300
            )
        }
    }
}

struct ChartEntry: Equatable {
    let x: CGFloat
    let y: CGFloat
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
        self.width = width
        self.height = height
    }
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    @State var axisWidth: CGFloat = 0
    private var axisSpacing: CGFloat = 0
    
    var body: some View {
        VStack {
            if entries.isEmpty {
                ProgressView()
            } else {
                HStack(spacing: axisSpacing) {
                    ZStack {
                        let scaledEntries = applyScaling(chartEntries: entries)
                        ForEach(Array(entries.enumerated()), id: \.offset) { entry in
                            if entry.offset == 0 {
                                getLabel(posY: scaledEntries[entry.offset].y, valueY: entry.element.y)
                            }
                            
                            if let maxEntry = entries.max(by: { $0.y < $1.y }), maxEntry == entry.element {
                                getLabel(posY: scaledEntries[entry.offset].y, valueY: maxEntry.y)
                            }
                            
                            if let minEntry = entries.min(by: { $0.y < $1.y }), minEntry == entry.element {
                                getLabel(posY: scaledEntries[entry.offset].y, valueY: minEntry.y)
                            }
                        }
                    }
                    .frame(width: axisWidth, height: height)
                    
                    ZStack {
                        drawXAxis()
                            .stroke(.primary, lineWidth: 3)
                        
                        drawLeftYAxis()
                            .stroke(.primary, lineWidth: 3)
                        
                        drawLine()
                            .stroke(.green, lineWidth: 3)
                    }
                    .frame(width: width - axisWidth, height: height)
                }
                .frame(width: width, height: height)
            }
        }
        .transition(.slide)
        .animation(.bouncy, value: entries)
    }
    
    func getLabel(posY: CGFloat, valueY: CGFloat) -> some View {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        
        return Text(numberFormatter.string(from: valueY as NSNumber) ?? "")
            .font(.callout)
            .fixedSize(horizontal: true, vertical: false)
            .background {
                GeometryReader { reader in
                    Color(.systemBackground)
                        .onAppear {
                            if axisWidth < reader.size.width {
                                axisWidth = reader.size.width
                            }
                        }
                }
            }
            .position(x: 0, y: height - posY)
    }
    
    func drawLine() -> Path {
        Path { path in
            
            let scaledEntries = applyScaling(chartEntries: entries)
            
            path.move(
                to: CGPoint(
                    x: scaledEntries[0].x,
                    y: height - scaledEntries[0].y
                )
            )
            
            for entry in scaledEntries {
                path.addLine(
                    to: CGPoint(
                        x: entry.x,
                        y: height - entry.y
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
        let maxX = chartEntries.max(by: { $0.x < $1.x })?.x ?? width
        let maxY = chartEntries.max(by: { $0.y < $1.y })?.y ?? height
        
        let chartWidth: CGFloat = width - axisSpacing - axisWidth
        
        let scaleRatioWidth = chartWidth / maxX
        let scaleRatioHeight = height / maxY
        
        let result = chartEntries.map {
            let x = $0.x * scaleRatioWidth
            let y = $0.y * scaleRatioHeight
            
            return ChartEntry(x: x, y: y)
        }
        
        return result
    }
}

extension Array<ChartEntry> {
    static var example: [ChartEntry] {
        var entries: [ChartEntry] = []
        for index in 0..<10 {
            entries.append(
                ChartEntry(
                    x: CGFloat(index),
                    y: .random(in: 2000..<5001)
                )
            )
        }
        
        return entries
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ContentView()
        .frame(width: 1000, height: 1000, alignment: .center)
}
