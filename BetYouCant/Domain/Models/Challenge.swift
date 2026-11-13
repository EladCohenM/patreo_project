import Foundation

struct Challenge: Identifiable, Hashable {
    enum Status: String, CaseIterable {
        case open = "Open"
        case awaitingProof = "Awaiting proof"
        case completed = "Completed"
    }

    let id: UUID
    var title: String
    var details: String
    var creatorID: User.ID
    var challengerID: User.ID
    var groupID: FriendGroup.ID
    var deadline: Date
    var points: Int
    var status: Status
    var yesVotes: Int
    var noVotes: Int
}
