import SwiftUI
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, ObservableObject {
    private var centralManager: CBCentralManager!
    @Published var discoveredDevices: [String] = []
    var discoveredDeviceIdentifiers = Set<String>()
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth not available!")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let deviceName = peripheral.name ?? "Unnamed"
        let deviceIdentifier = peripheral.identifier.uuidString
        
        guard !discoveredDeviceIdentifiers.contains(deviceIdentifier) else {
            return // avoid duplicates -- slows program performance
        }
        
        let proximity = calculateProximityFromRSSI(RSSI)
        let deviceInfo = "Device: \(deviceName), RSSI: \(RSSI), Proximity: \(proximity)"
        
        DispatchQueue.main.async {
            self.discoveredDevices.append(deviceInfo)
            self.discoveredDeviceIdentifiers.insert(deviceIdentifier)
        }
    }
    
    func calculateProximityFromRSSI(_ rssi: NSNumber) -> String {
        if rssi.intValue < -90 {
            return "far"
        } else if rssi.intValue < -70 {
            return "near"
        } else {
            return "immediate"
        }
    }
}

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

struct ContentView: View {
    @StateObject private var bluetoothManager = BluetoothManager()
    @State private var tappedDeviceInfo: String? // Track tapped device info
    
    var body: some View {
        VStack {
            Image(systemName: "bluetooth")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Text("Discovered Bluetooth Devices:")
            
            RadarWithBluetoothView(discoveredDevices: bluetoothManager.discoveredDevices, tappedDeviceInfo: $tappedDeviceInfo)
                .frame(width: 300, height: 300)
                .blur(radius: tappedDeviceInfo == nil ? 0 : 3) // Blur when device info is shown
            
            // Legend
            HStack {
                Circle().fill(Color.red).frame(width: 10, height: 10)
                Text("Immediate").font(.system(.body, design: .monospaced))
                Circle().fill(Color.green).frame(width: 10, height: 10)
                Text("Near").font(.system(.body, design: .monospaced))
                Circle().fill(Color.blue).frame(width: 10, height: 10)
                Text("Far").font(.system(.body, design: .monospaced))
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .padding()
        }
        .overlay(
            tappedDeviceInfo != nil ?
            DeviceInfoPrompt(deviceInfo: tappedDeviceInfo!) {
                // Dismiss tapped device info
                tappedDeviceInfo = nil
            }
            .padding()
            : nil
        )
    }
}

struct DeviceInfoPrompt: View {
    var deviceInfo: String
    var onTapOutside: () -> Void
    
    var body: some View {
        VStack {
            Text(deviceInfo)
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .shadow(radius: 5)
                .onTapGesture {} // Prevent tapping through to underlying views
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3))
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            onTapOutside() // Dismiss prompt when tapped outside
        }
    }
}


struct RadarWithBluetoothView: View {
    var discoveredDevices: [String]
    @Binding var tappedDeviceInfo: String?
    
    // Define a dictionary to map proximity values to colors
    let proximityColors: [String: Color] = [
        "far": .blue,
        "near": .green,
        "immediate": .red
    ]
    
    var body: some View {
        ZStack {
            RadarView()
            
            ForEach(discoveredDevices, id: \.self) { deviceInfo in
                let color = colorForDeviceInfo(deviceInfo)
                let position = CGPoint(x: CGFloat.random(in: 50...250), y: CGFloat.random(in: 50...250))
                
                RadarDot(position: position, color: color)
                    .onTapGesture {
                        tappedDeviceInfo = deviceInfo // Update tappedDeviceInfo when tapped
                    }
            }
        }
    }
    private func colorForDeviceInfo(_ deviceInfo: String) -> Color {
        let components = deviceInfo.components(separatedBy: ", ")
        if let proximityComponent = components.last {
            let proximity = proximityComponent.replacingOccurrences(of: "Proximity: ", with: "")

            return proximityColors[proximity] ?? .gray
        } else {
            return .gray // Default color if proximity component is missing
        }
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
