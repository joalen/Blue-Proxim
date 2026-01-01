import SwiftUI
import SwiftData

@main
struct BlueProxim : App {
    @available(iOS 17, *)
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [SavedDevice.self, DeviceSighting.self])
    }
}
