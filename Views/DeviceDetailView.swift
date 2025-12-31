import SwiftUI
import SwiftData

struct DeviceDetailView: View {
    @Bindable var device: SavedDevice
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        List {
            Section("Device Info") {
                LabeledContent("Name", value: device.name)
                LabeledContent("ID", value: device.id.uuidString)
                LabeledContent("First Seen", value: device.firstSeen.formatted())
                LabeledContent("Last Seen", value: device.lastSeen.formatted())
                LabeledContent("Times Detected", value: "\(device.timesDetected)")
                LabeledContent("Average RSSI", value: "\(Int(device.averageRSSI)) dBm")
            }
            
            Section("Actions") {
                Toggle("Favorite", isOn: $device.isFavorite)
            }
            
            Section("Sighting History") {
                if device.sightings.isEmpty {
                    Text("No sightings recorded")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(device.sightings.sorted(by: { $0.timestamp > $1.timestamp })) { sighting in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(sighting.timestamp.formatted(date: .abbreviated, time: .shortened))
                                    .font(.subheadline)
                                Text(sighting.proximity.capitalized)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Text("\(sighting.rssi) dBm")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(device.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
