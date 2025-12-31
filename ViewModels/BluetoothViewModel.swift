//
//  BluetoothViewModel.swift
//
//  Now, I'm doing the magic of managing states from my Models to the Views
//
//  Created by Alen Jo on 12/31/25.
//

import SwiftUI
import Combine


@MainActor
class BluetoothViewModel : ObservableObject
{
    // published props
    @Published var devices: [BluetoothDevice] = []
    @Published var selectedDevice: BluetoothDevice?
    @Published var isScanning: Bool = false
    
    // private props
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
    
    private func setupBindings()
    {
        bluetoothService.devicePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] device in
                self?.devices.append(device)
            }
            .store(in: &cancellables)
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
