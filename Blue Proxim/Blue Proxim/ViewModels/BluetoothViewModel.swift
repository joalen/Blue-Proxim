import SwiftUI
import Combine
import SwiftData

@MainActor
class BluetoothViewModel : ObservableObject
{
    // published props
    @Published var devices: [BluetoothDevice] = []
    @Published var selectedDevice: BluetoothDevice?
    @Published var isScanning: Bool = false
    
    // private props
    private var modelContext: ModelContext?
    private let bluetoothService: BluetoothServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // computed props
    var deviceCount: Int
    {
        devices.count
    }
    
    var proximityGroups: [BluetoothDevice.Proximity: [BluetoothDevice]]
    {
        Dictionary(grouping: devices, by: {$0.proximity })
    }
    
    init(bluetoothService: BluetoothServiceProtocol = BluetoothService())
    {
        self.bluetoothService = bluetoothService
        setupBindings()
    }
    
    func setModelContext(_ context: ModelContext)
    {
        self.modelContext = context
    }
    
    private func setupBindings()
    {
        bluetoothService.devicePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] device in
                self?.devices.append(device)
                self?.saveDevice(device)
            }
            .store(in: &cancellables)
    }
    
    private func saveDevice(_ device: BluetoothDevice)
    {
        guard let context = modelContext else { return }
        let deviceID = device.id
        let descriptor = FetchDescriptor<SavedDevice>(
            predicate: #Predicate { $0.id == deviceID }
        )
        
        do {
            let existingDevices = try context.fetch(descriptor)
            
            if let savedDevice = existingDevices.first
            {
                savedDevice.lastSeen = Date()
                savedDevice.timesDetected += 1
                
                let sighting = DeviceSighting(rssi: device.rssi, proximity: device.proximity.rawValue)
                sighting.device = savedDevice
                context.insert(sighting)
                
                let allRSSI = savedDevice.sightings.map { Double($0.rssi )}
            } else {
                let savedDevice = SavedDevice(
                    id: device.id,
                    name: device.name
                )
                savedDevice.averageRSSI = Double(device.rssi)
                
                let sighting = DeviceSighting(
                    rssi: device.rssi,
                    proximity: device.proximity.rawValue
                )
                sighting.device = savedDevice
                
                context.insert(savedDevice)
                context.insert(sighting)
    
            }
            
            try context.save()
            
        } catch {
            print("Error saving device: \(error)")
        }
    }
    
    func startScanning()
    {
        isScanning = true
        bluetoothService.stopScanning()
    }
    
    func stopScanning()
    {
        isScanning = false
        bluetoothService.stopScanning()
    }
    
    func selectDevice(_ device: BluetoothDevice)
    {
        selectedDevice = device
    }
    
    func deselectDevice()
    {
        selectedDevice = nil
    }
    
    func clearAllDevices()
    {
        devices.removeAll()
    }
}
