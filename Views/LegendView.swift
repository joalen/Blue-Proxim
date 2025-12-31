import SwiftUI

struct LegendView : View
{
    var body: some View {
        HStack {
            LegendItem(color: .red, text: "Immediate")
            LegendItem(color: .green, text: "Near")
            LegendItem(color: .blue, text: "Far")
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
    }
}

struct LegendItem: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(text)
                .font(.system(.body, design: .monospaced))
        }
    }
}
