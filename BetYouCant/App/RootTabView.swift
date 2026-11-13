import SwiftUI

struct RootTabView: View {
    @State private var selectedTab: AppTab = .home
    @State private var isCreatingChallenge = false

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack { HomeView() }
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(AppTab.home)

            NavigationStack { ChallengesView() }
                .tabItem { Label("Challenges", systemImage: "bolt.fill") }
                .tag(AppTab.challenges)

            Color.clear
                .tabItem { Label("Create", systemImage: "plus.circle.fill") }
                .tag(AppTab.create)

            NavigationStack { LeaderboardView() }
                .tabItem { Label("Leaderboard", systemImage: "trophy.fill") }
                .tag(AppTab.leaderboard)

            NavigationStack { ProfileView() }
                .tabItem { Label("Profile", systemImage: "person.crop.circle.fill") }
                .tag(AppTab.profile)
        }
        .onChange(of: selectedTab) { _, tab in
            guard tab == .create else { return }
            isCreatingChallenge = true
            selectedTab = .home
        }
        .sheet(isPresented: $isCreatingChallenge) {
            NavigationStack { CreateChallengeView() }
        }
    }
}

private enum AppTab: Hashable {
    case home, challenges, create, leaderboard, profile
}
