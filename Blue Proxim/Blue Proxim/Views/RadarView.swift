import SwiftUI

struct RadarView: View {
    var body: some View {
        ZStack {
            // Draw concentric circles
            ForEach(1..<6) { index in
                Circle()
                    .stroke(Color.gray.opacity(0.5))
                    .frame(width: CGFloat(index) * 60, height: CGFloat(index) * 60)
            }
            
            // Draw radial lines
            ForEach(0..<12) { index in
                let angle = Angle(degrees: Double(index) * 30)
                let startPoint = CGPoint(x: 150, y: 150)
                let endPoint = CGPoint(x: 150 + cos(angle.radians) * 150, y: 150 + sin(angle.radians) * 150)
                
                Path { path in
                    path.move(to: startPoint)
                    path.addLine(to: endPoint)
                }
                .stroke(Color.gray.opacity(0.5))
            }
        }
        .frame(width: 300, height: 300)
    }
}

struct RadarDot: View {
    var position: CGPoint
    var color: Color
    
    var body: some View {
        Circle()
            .fill(color) // Set the fill color here
            .frame(width: 10, height: 10)
            .position(position)
    }
}
