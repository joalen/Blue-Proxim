//
//  BluetoothManager.swift
//
//  Serves as the proper and pure service registry for Bluetooth related things
//
//  Created by Alen Jo on 12/31/25.
//

import CoreBluetooth
import Combine

protocol BluetoothServiceProtocol
{
    var devicePublisher: AnyPublisher<BluetoothDevice, Never> { get }
    func startScanning()
    func stopScanning()
}

class BluetoothService : NSObject, BluetoothServiceProtocol
{
    private var centralManager: CBCentralManager!
    private let deviceSubject = PassthroughSubject<BluetoothDevice, Never>()
    private var discoveredIdentifiers = Set<UUID>()
    
    var devicePublisher: AnyPublisher<BluetoothDevice, Never>
    {
        deviceSubject.eraseToAnyPublisher()
    }
    
    override init()
    {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScanning() {
        guard centralManager.state == .poweredOn else { return }
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScanning() {
        centralManager.stopScan()
    }
}

extension BluetoothService : CBCentralManagerDelegate
{
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        if central.state == .poweredOn
        {
            startScanning()
        } else
        {
            print("Bluetooth not available")
        }
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String : Any],
        rssi RSSI : NSNumber
    )
    {
        guard !discoveredIdentifiers.contains(peripheral.identifier) else
        {
            return
        }
        
        let device = BluetoothDevice(
            id: peripheral.identifier,
            name: peripheral.name ?? "Unknown",
            rssi: RSSI.intValue,
            proximity: .from(rssi: RSSI.intValue),
            lastSeen: Date()
        )
        
        discoveredIdentifiers.insert(peripheral.identifier)
        deviceSubject.send(device)
    }
}
