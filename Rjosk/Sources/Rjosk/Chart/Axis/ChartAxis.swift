import SwiftUI

protocol ChartAxis {
    associatedtype SwiftUIView: View
    
    func drawLabels() -> SwiftUIView
    
    func drawAxis() -> Path
    
    var chart: ChartView { get }
}

