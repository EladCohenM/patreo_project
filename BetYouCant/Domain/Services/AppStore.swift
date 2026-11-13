import Foundation
import Combine

final class AppStore: ObservableObject {
    @Published var currentUser: User
    @Published var users: [User]
    @Published var groups: [FriendGroup]
    @Published var challenges: [Challenge]

    init(currentUser: User, users: [User], groups: [FriendGroup], challenges: [Challenge]) {
        self.currentUser = currentUser
        self.users = users
        self.groups = groups
        self.challenges = challenges
    }

    func user(id: User.ID) -> User? { users.first { $0.id == id } }
    func group(id: FriendGroup.ID) -> FriendGroup? { groups.first { $0.id == id } }

    func addChallenge(title: String, details: String, challengerID: User.ID, groupID: FriendGroup.ID, deadline: Date, points: Int) {
        challenges.insert(
            Challenge(
                id: UUID(), title: title, details: details, creatorID: currentUser.id,
                challengerID: challengerID, groupID: groupID, deadline: deadline,
                points: points, status: .open, yesVotes: 0, noVotes: 0
            ),
            at: 0
        )
    }
}

extension AppStore {
    static var preview: AppStore {
        let mia = User(id: UUID(), name: "Mia Chen", handle: "@mia", points: 860, wins: 14, currentStreak: 4)
        let noah = User(id: UUID(), name: "Noah Williams", handle: "@noah", points: 1020, wins: 18, currentStreak: 6)
        let ava = User(id: UUID(), name: "Ava Patel", handle: "@ava", points: 740, wins: 11, currentStreak: 2)
        let leo = User(id: UUID(), name: "Leo Martin", handle: "@leo", points: 610, wins: 9, currentStreak: 1)
        let group = FriendGroup(id: UUID(), name: "Weekend Warriors", emoji: "⚡️", memberIDs: [mia.id, noah.id, ava.id, leo.id])
        let challenges = [
            Challenge(id: UUID(), title: "Run a 5K before Sunday", details: "Strava screenshot required. No treadmill!", creatorID: mia.id, challengerID: noah.id, groupID: group.id, deadline: .now.addingTimeInterval(172_800), points: 100, status: .open, yesVotes: 7, noVotes: 3),
            Challenge(id: UUID(), title: "Make homemade pasta", details: "From scratch—including the dough.", creatorID: ava.id, challengerID: mia.id, groupID: group.id, deadline: .now.addingTimeInterval(345_600), points: 75, status: .open, yesVotes: 5, noVotes: 5),
            Challenge(id: UUID(), title: "Cold shower for 7 days", details: "Daily proof in the group chat.", creatorID: leo.id, challengerID: ava.id, groupID: group.id, deadline: .now.addingTimeInterval(86_400), points: 150, status: .awaitingProof, yesVotes: 2, noVotes: 8)
        ]
        return AppStore(currentUser: mia, users: [mia, noah, ava, leo], groups: [group], challenges: challenges)
    }
}
