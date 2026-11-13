import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hey, \(store.currentUser.name.split(separator: " ").first ?? "friend") 👋")
                        .font(.largeTitle.bold())
                    Text("What are your friends betting on?")
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Label("\(store.currentUser.points) pts", systemImage: "sparkles")
                    Spacer()
                    Label("\(store.currentUser.currentStreak) streak", systemImage: "flame.fill")
                }
                .font(.headline)
                .cardStyle()

                Text("Active challenges").font(.title2.bold())

                ForEach(store.challenges.filter { $0.status != .completed }) { challenge in
                    ChallengeCard(challenge: challenge)
                }
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Bet You Can't")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {}) { Image(systemName: "bell") }
            }
        }
    }
}
