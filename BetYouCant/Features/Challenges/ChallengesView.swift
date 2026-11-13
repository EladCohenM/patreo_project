import SwiftUI

struct ChallengesView: View {
    @EnvironmentObject private var store: AppStore
    @State private var status: Challenge.Status = .open

    var body: some View {
        List {
            Picker("Status", selection: $status) {
                ForEach(Challenge.Status.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)
            .listRowBackground(Color.clear)

            ForEach(store.challenges.filter { $0.status == status }) { challenge in
                ChallengeCard(challenge: challenge)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Challenges")
    }
}
