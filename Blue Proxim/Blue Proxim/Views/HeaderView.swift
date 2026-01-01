import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack {
            Image(systemName: "bluetooth")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Text("Discovered Bluetooth Devices:")
        }
    }
}
