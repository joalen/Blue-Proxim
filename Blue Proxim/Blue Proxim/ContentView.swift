import SwiftUI
import SwiftData

struct MainTabView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Radar", systemImage: "dot.radiowaves.left.and.right")
                }
            
            DeviceHistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
        }
    }
}

struct ContentView : View
{
    @StateObject private var viewModel = BluetoothViewModel()
    @Environment(\.modelContext) private var modelContext
    
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
            viewModel.setModelContext(modelContext)
            viewModel.startScanning()
        }
    }
}
