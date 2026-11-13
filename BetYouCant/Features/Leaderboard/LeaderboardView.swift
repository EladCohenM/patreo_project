import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        List(Array(store.users.sorted { $0.points > $1.points }.enumerated()), id: \.element.id) { index, user in
            HStack(spacing: 14) {
                Text(index < 3 ? ["🥇", "🥈", "🥉"][index] : "\(index + 1)")
                    .font(.title2).frame(width: 34)
                Circle().fill(AppTheme.accent.opacity(0.14)).frame(width: 46, height: 46)
                    .overlay(Text(user.initials).font(.subheadline.bold()).foregroundStyle(AppTheme.accent))
                VStack(alignment: .leading) {
                    Text(user.name).font(.headline)
                    Text("\(user.wins) wins · \(user.currentStreak) streak").font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Text("\(user.points)").font(.headline.monospacedDigit())
            }
            .padding(.vertical, 6)
        }
        .navigationTitle("Leaderboard")
    }
}
