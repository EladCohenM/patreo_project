import SwiftUI

@main
struct BetYouCantApp: App {
    @StateObject private var store = AppStore.preview

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(store)
                .tint(AppTheme.accent)
        }
    }
}
