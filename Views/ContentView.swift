import SwiftUI

struct ContentView : View
{
    @StateObject private var viewModel = BluetoothViewModel()
    
    var body: some View
    {
        VStack
        {
            HeaderView()
            
            RadarWithBluetoothView(
                devices: viewModel.devices,
                selectedDevice: viewModel.selectedDevice,
                onDeviceTap: { device in
                    viewModel.selectDevice(device)
                }
            )
            .frame(width: 300, height: 300)
            .blur(radius: viewModel.selectedDevice == nil ? 0 : 3)
            
            LegendView().padding()
        }
        .overlay(
            viewModel.selectedDevice.map { device in
                DeviceInfoPrompt(
                    deviceInfo: device.displayInfo,
                    onDismiss: {
                        viewModel.deselectDevice()
                    }
                )
                .padding()
            }
        )
        .onAppear
        {
            viewModel.startScanning()
        }
    }
}
