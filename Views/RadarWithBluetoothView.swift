import SwiftUI

struct RadarWithBluetoothView: View {
    let devices: [BluetoothDevice]
    let selectedDevice: BluetoothDevice?
    let onDeviceTap: (BluetoothDevice) -> Void
    
    var body: some View {
        ZStack {
            RadarView()
            
            ForEach(devices) { device in
                let position = CGPoint(
                    x: CGFloat.random(in: 50...250),
                    y: CGFloat.random(in: 50...250)
                )
                
                RadarDot(
                    position: position,
                    color: device.proximity.color
                )
                .onTapGesture {
                    onDeviceTap(device)
                }
            }
        }
    }
}
