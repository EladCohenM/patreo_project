import SwiftUI

struct ChallengeCard: View {
    @EnvironmentObject private var store: AppStore
    let challenge: Challenge

    private var challenger: User? { store.user(id: challenge.challengerID) }
    private var totalVotes: Int { max(challenge.yesVotes + challenge.noVotes, 1) }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(challenge.status.rawValue.uppercased())
                    .font(.caption2.bold())
                    .foregroundStyle(challenge.status == .open ? AppTheme.success : .orange)
                Spacer()
                Label("\(challenge.points)", systemImage: "star.fill")
                    .font(.subheadline.bold())
                    .foregroundStyle(AppTheme.accent)
            }

            Text(challenge.title).font(.title3.bold())
            Text("Can \(challenger?.name ?? "your friend") pull it off?")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            GeometryReader { proxy in
                HStack(spacing: 0) {
                    AppTheme.success.frame(width: proxy.size.width * CGFloat(challenge.yesVotes) / CGFloat(totalVotes))
                    AppTheme.danger
                }
            }
            .frame(height: 7)
            .clipShape(Capsule())

            HStack {
                Text("YES \(challenge.yesVotes)").foregroundStyle(AppTheme.success)
                Spacer()
                Text("NO \(challenge.noVotes)").foregroundStyle(AppTheme.danger)
            }
            .font(.caption.bold())

            Label(challenge.deadline.formatted(.relative(presentation: .named)), systemImage: "clock")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .cardStyle()
    }
}
