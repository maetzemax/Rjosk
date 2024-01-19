import Foundation

struct ChartEntry: Equatable {
    let x: CGFloat
    let y: CGFloat
}

extension Array<ChartEntry> {
    static var example: [ChartEntry] {
        var entries: [ChartEntry] = []
        for index in 2..<10 {
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
