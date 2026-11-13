import SwiftUI

struct CreateChallengeView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var details = ""
    @State private var challengerID: User.ID?
    @State private var groupID: FriendGroup.ID?
    @State private var deadline = Date.now.addingTimeInterval(86_400)
    @State private var points = 50

    var body: some View {
        Form {
            Section("The challenge") {
                TextField("Bet you can't…", text: $title)
                TextField("Rules and proof required", text: $details, axis: .vertical)
                    .lineLimit(3...6)
            }
            Section("Who and where") {
                Picker("Challenge", selection: $challengerID) {
                    Text("Choose a friend").tag(nil as User.ID?)
                    ForEach(store.users.filter { $0.id != store.currentUser.id }) { user in
                        Text(user.name).tag(user.id as User.ID?)
                    }
                }
                Picker("Group", selection: $groupID) {
                    Text("Choose a group").tag(nil as FriendGroup.ID?)
                    ForEach(store.groups) { group in Text("\(group.emoji) \(group.name)").tag(group.id as FriendGroup.ID?) }
                }
            }
            Section("Stakes") {
                DatePicker("Deadline", selection: $deadline, in: Date.now...)
                Stepper("\(points) points", value: $points, in: 25...500, step: 25)
            }
        }
        .navigationTitle("New challenge")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
            ToolbarItem(placement: .confirmationAction) {
                Button("Create") { create() }.disabled(!canCreate)
            }
        }
        .onAppear {
            challengerID = challengerID ?? store.users.first { $0.id != store.currentUser.id }?.id
            groupID = groupID ?? store.groups.first?.id
        }
    }

    private var canCreate: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && challengerID != nil && groupID != nil
    }

    private func create() {
        guard let challengerID, let groupID else { return }
        store.addChallenge(title: title, details: details, challengerID: challengerID, groupID: groupID, deadline: deadline, points: points)
        dismiss()
    }
}
