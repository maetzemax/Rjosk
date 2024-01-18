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
        self.width = width - paddingHorizontal
        self.height = height - paddingVertical
    }
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    @State var axisWidth: CGFloat = 0
    private var axisSpacing: CGFloat = 0
    
    var body: some View {
        HStack(spacing: axisSpacing) {
            ZStack {
                let scaledEntries = applyScaling(chartEntries: entries)
                ForEach(Array(entries.enumerated()), id: \.offset) { entry in
                    if entry.offset == 0 {
                        let y = scaledEntries[entry.offset].y
                        getLabel(posY: y, valueY: entry.element.y)
                    }
                    
                    if entry.element.x == entries.min(by: { $0.y > $1.y })?.x {
                        let y = scaledEntries[entry.offset].y
                        getLabel(posY: y, valueY: entry.element.y)
                    }
                    
                    if entry.element.x == entries.max(by: { $0.y > $1.y })?.x {
                        let y = scaledEntries[entry.offset].y
                        getLabel(posY: y, valueY: entry.element.y)
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
    
    func getLabel(posY: CGFloat, valueY: CGFloat) -> some View {
        Text("\(Int(valueY))")
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
            
            let entries = applyScaling(chartEntries: entries)
            
            // Move to the bottom leading corner
            path.move(
                to: CGPoint(
                    x: entries[0].x,
                    y: entries[0].y
                )
            )
            
            for entry in entries {
                if let minY = entries.min(by: { $0.y < $1.y })?.y {
                    // Draw X-Axis
                    path.addLine(
                        to: CGPoint(
                            x: entry.x,
                            y: entry.y - minY
                        )
                    )
                }
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
        
        let scaleRatioWidth = chartWidth / (maxX ?? width)
        let scaleRatioHeight = height / (maxY ?? height)
        
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
        for index in 0..<100 {
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
