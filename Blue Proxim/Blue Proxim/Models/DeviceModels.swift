
import Foundation
import SwiftData

@available(iOS 17, *)
@Model
final class SavedDevice
{
    @Attribute(.unique) var id: UUID
    var name: String
    var firstSeen: Date
    var lastSeen: Date
    var timesDetected: Int
    var averageRSSI: Double
    var isFavorite: Bool
    
    @Relationship(deleteRule: .cascade, inverse: \DeviceSighting.device)
    var sightings: [DeviceSighting] = []
    
    init(id: UUID, name: String, firstSeen: Date = Date())
    {
        self.id = id
        self.name = name
        self.firstSeen = firstSeen
        self.lastSeen = firstSeen
        self.timesDetected = 1
        self.averageRSSI = 0
        self.isFavorite = false
    }
    
    var displayName: String
    {
        isFavorite ? "⭐ \(name)" : name
    }
}

@available(iOS 17, *)
@Model
final class DeviceSighting {
    var timestamp: Date
    var rssi: Int
    var proximity: String
    
    var device: SavedDevice?
    
    init(timestamp: Date = Date(), rssi: Int, proximity: String) {
        self.timestamp = timestamp
        self.rssi = rssi
        self.proximity = proximity
    }
}
