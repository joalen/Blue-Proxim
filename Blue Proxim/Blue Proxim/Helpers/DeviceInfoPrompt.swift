import SwiftUI

struct DeviceInfoPrompt: View {
    let deviceInfo: String
    let onDismiss: () -> Void
    
    var body: some View {
        VStack {
            Text(deviceInfo)
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .shadow(radius: 5)
                .onTapGesture {} // Prevent tap-through
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3))
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            onDismiss()
        }
    }
}
