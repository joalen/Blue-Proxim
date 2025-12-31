import SwiftUI
import SwiftData

struct DeviceHistoryView: View {
    @Query(sort: \SavedDevice.lastSeen, order: .reverse)
    private var savedDevices: [SavedDevice]
    
    @State private var searchText = ""
    @State private var showOnlyFavorites = false
    
    var filteredDevices: [SavedDevice] {
        var devices = savedDevices
        
        if showOnlyFavorites {
            devices = devices.filter { $0.isFavorite }
        }
        
        if !searchText.isEmpty {
            devices = devices.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return devices
    }
    
    var body: some View {
        NavigationStack {
            List {
                if filteredDevices.isEmpty {
                    ContentUnavailableView(
                        "No Devices Found",
                        systemImage: "antenna.radiowaves.left.and.right.slash",
                        description: Text("Start scanning to discover devices")
                    )
                } else {
                    ForEach(filteredDevices) { device in
                        NavigationLink {
                            DeviceDetailView(device: device)
                        } label: {
                            DeviceHistoryRow(device: device)
                        }
                    }
                    .onDelete(perform: deleteDevices)
                }
            }
            .navigationTitle("Device History")
            .searchable(text: $searchText, prompt: "Search devices")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showOnlyFavorites.toggle()
                    } label: {
                        Image(systemName: showOnlyFavorites ? "star.fill" : "star")
                    }
                }
            }
        }
    }
    
    private func deleteDevices(at offsets: IndexSet) {
        // TODO: Implement using a ModelContext
    }
}

struct DeviceHistoryRow: View {
    let device: SavedDevice
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(device.displayName)
                    .font(.headline)
                
                Text("Last seen: \(device.lastSeen.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("Detected \(device.timesDetected) times")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(Int(device.averageRSSI)) dBm")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Circle()
                    .fill(proximityColor(device.averageRSSI))
                    .frame(width: 12, height: 12)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func proximityColor(_ rssi: Double) -> Color {
        if rssi < -90 { return .blue }
        else if rssi < -70 { return .green }
        else { return .red }
    }
}
