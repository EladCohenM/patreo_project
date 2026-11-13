import Foundation

struct User: Identifiable, Hashable {
    let id: UUID
    var name: String
    var handle: String
    var points: Int
    var wins: Int
    var currentStreak: Int

    var initials: String {
        name.split(separator: " ").prefix(2).compactMap(\.first).map(String.init).joined()
    }
}
