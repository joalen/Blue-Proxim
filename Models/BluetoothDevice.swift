//
//  BluetoothDevice.swift
//
//
//  Serves as a proper data model for finding bluetooth devices
//  Created by Alen Jo on 12/31/25.
//

import SwiftUI
import Foundation
import CoreBluetooth

struct BluetoothDevice : Identifiable, Hashable
{
    let id: UUID
    let name: String
    let rssi: Int
    let proximity: Proximity
    let lastSeen: Date
    
    var displayInfo: String
    {
        "Device: \(name), RSSI: \(rssi), Proximity: \(proximity.rawValue)"
    }
    
    enum Proximity: String
    {
        case immediate = "immediate"
        case near = "near"
        case far = "far"
        
        var color : Color
        {
            switch self 
            {
            case .immediate: return .red
            case .near: return .green
            case .far: return .blue
            }
        }
        
        static func from(rssi: Int) -> Proximity
        {
            if rssi < -90
            {
                return .far
            } else if rssi < -70
            {
                return .near
            } else
            {
                return .immediate
            }
        }
    }
}
