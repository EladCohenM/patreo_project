import Foundation

struct FriendGroup: Identifiable, Hashable {
    let id: UUID
    var name: String
    var emoji: String
    var memberIDs: [User.ID]
}
