//
//  ContentView.swift
//  Rjosk
//
//  Created by Max Maetze on 17.01.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            ChartView(
                padding: UIEdgeInsets(
                    top: 0,
                    left: 10,
                    bottom: 0,
                    right: 10
                )
            )
            
            ChartView(
                width: 300,
                height: 100,
                padding: UIEdgeInsets(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    right: 0
                )
            )
        }
    }
}

struct ChartEntry {
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
        padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    ) {
        self.width = width - (padding.left + padding.right)
        self.height = height - (padding.top + padding.bottom)
    }
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var body: some View {
        ZStack {
            drawXAxis()
                .stroke(.primary, lineWidth: 3)
            
            drawLeftYAxis()
                .stroke(.primary, lineWidth: 3)
            
            drawRightYAxis()
                .stroke(.primary, lineWidth: 3)
            
            drawLine()
                .stroke(.green, lineWidth: 3)
        }
        .frame(width: width, height: height)
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
    
    func drawBackground() -> Path {
        Path { path in
            path.addRect(
                CGRect(
                    x: 0,
                    y: 0,
                    width: Int(width),
                    height: Int(height)
                )
            )
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
                    x: width,
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
    
    func drawRightYAxis() -> Path {
        Path { path in
            // Move to the bottom leading corner
            path.move(
                to: CGPoint(
                    x: width,
                    y: height
                )
            )
            
            // Draw Y-Axis
            path.addLine(
                to: CGPoint(
                    x: width,
                    y: 0
                )
            )
        }
    }
    
    func applyScaling(chartEntries: [ChartEntry]) -> [ChartEntry] {
        let maxX = chartEntries.max(by: { $0.x < $1.x })?.x
        let maxY = chartEntries.max(by: { $0.y < $1.y })?.y
        
        let scaleRatioWidth = width / (maxX ?? width)
        let scaleRatioHeight = height / (maxY ?? height)
        
        let result = chartEntries.map {
            let x = $0.x * scaleRatioWidth
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
