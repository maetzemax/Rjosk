import SwiftUI
import RjoskChart

struct ContentView: View {
    
    // CONFIG
    
    @State var height: CGFloat = 300
    @State var width: CGFloat = UIScreen.main.bounds.width
    
    // STYLING
    
    @State var lineColor: Color = .green
    @State var lineWidth: CGFloat = 1
    
    @State var axisColor: Color = .primary
    @State var axisLineWidth: CGFloat = 1
    
    @State var axisTickColor: Color = .primary
    @State var axisTickLineWidth: CGFloat = 1
    
    var chartStyling: ChartStyling {
        ChartStyling(
            lineWidth: lineWidth,
            lineColor: lineColor,
            labelColor: .primary,
            chartBackground: .clear,
            axisColor: axisColor,
            axisTickColor: axisTickColor,
            axisLineWidth: axisLineWidth,
            axisTickLineWidth: axisTickLineWidth
        )
    }
    
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    var body: some View {
        VStack {
            ChartView(
                chartConfig: ChartConfiguration(
                    chartStyling: chartStyling,
                    height: height,
                    width: width
                )
            )
            .clipped()
            
            Form {
                Section {
                    VStack(alignment: .leading) {
                        Text("Height")
                        HStack {
                            Slider(value: $height, in: 100...500, step: 1)
                            Text(numberFormatter.string(from: height as NSNumber) ?? "")
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Width")
                        HStack {
                            Slider(value: $width, in: 100...UIScreen.main.bounds.width, step: 1)
                            Text(numberFormatter.string(from: width as NSNumber) ?? "")
                        }
                    }
                } header: {
                    Text("Configure chart viewport")
                }
                
                Section {
                    ColorPicker("Color", selection: $lineColor)
                    
                    VStack(alignment: .leading) {
                        Text("Width")
                        HStack {
                            Slider(value: $lineWidth, in: 0.05...5, step: 0.01)
                            Text(numberFormatter.string(from: lineWidth as NSNumber) ?? "")
                        }
                        
                    }
                } header: {
                    Text("Configure chart graph line")
                }
                
                Section {
                    ColorPicker("Color", selection: $axisColor)
                    
                    VStack(alignment: .leading) {
                        Text("Width")
                        HStack {
                            Slider(value: $axisLineWidth, in: 0.05...5, step: 0.01)
                            Text(numberFormatter.string(from: axisLineWidth as NSNumber) ?? "")
                        }
                    }
                } header: {
                    Text("Configure chart axis")
                }
                
                Section {                    
                    ColorPicker("Color", selection: $axisTickColor)
                    
                    VStack(alignment: .leading) {
                        Text("Width")
                        
                        HStack {
                            Slider(value: $axisTickLineWidth, in: 0.05...5, step: 0.01)
                            Text(numberFormatter.string(from: axisTickLineWidth as NSNumber) ?? "")
                        }
                    }
                } header: {
                    Text("Configure chart axis ticks")
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    ContentView()
}
