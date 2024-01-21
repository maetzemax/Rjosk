import Foundation

public struct ChartEntry: Equatable {
    let x: CGFloat
    let y: CGFloat
}

extension Array<ChartEntry> {
    public static var exampleSinus: [ChartEntry] {
        let amplitude: Double = 10
        let frequency: Double = 0.025
        
        var entries: [ChartEntry] = []
        for index in 0..<1000 {
            entries.append(
                ChartEntry(
                    x: CGFloat(index),
                    y: amplitude * sin(frequency * Double(index))
                )
            )
        }
        
        return entries
    }
}
