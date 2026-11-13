import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        List {
            Section {
                VStack(spacing: 10) {
                    Circle().fill(AppTheme.accent.gradient).frame(width: 88, height: 88)
                        .overlay(Text(store.currentUser.initials).font(.title.bold()).foregroundStyle(.white))
                    Text(store.currentUser.name).font(.title2.bold())
                    Text(store.currentUser.handle).foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity).padding(.vertical)
            }
            Section("Stats") {
                LabeledContent("Points", value: "\(store.currentUser.points)")
                LabeledContent("Wins", value: "\(store.currentUser.wins)")
                LabeledContent("Current streak", value: "\(store.currentUser.currentStreak)")
            }
            Section("Your groups") {
                ForEach(store.groups) { group in Label(group.name, systemImage: "person.3.fill") }
            }
        }
        .navigationTitle("Profile")
    }
}
