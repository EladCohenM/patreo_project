import SwiftUI

struct Challenge: Identifiable, Codable {
    var id = UUID()
    var title: String
    var person: String
    var deadline: Date
    var predictions: [String: Bool] = [:]
    var outcome: Bool?
}

@MainActor
final class ChallengeStore: ObservableObject {
    @Published var challenges: [Challenge] = []
    @Published var saveError: String?
    let friends = ["You", "Alex", "Jordan", "Sam"]
    private let key = "bet-you-cant.challenges.v1"

    init() {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                challenges = try JSONDecoder().decode([Challenge].self, from: data)
            } catch {
                saveError = "Saved challenges could not be loaded. Your saved data has been kept."
            }
        } else {
            challenges = [
                Challenge(title: "Run 5K before breakfast", person: "Alex", deadline: Date().addingTimeInterval(86400), predictions: ["Jordan": true, "Sam": false]),
                Challenge(title: "Cook dinner without a recipe", person: "Sam", deadline: Date().addingTimeInterval(172800), predictions: ["Alex": true]),
                Challenge(title: "Finish a book in a weekend", person: "Jordan", deadline: Date().addingTimeInterval(-86400), predictions: ["Alex": true, "Sam": false], outcome: true)
            ]
            save()
        }
    }

    func save() {
        do { UserDefaults.standard.set(try JSONEncoder().encode(challenges), forKey: key) }
        catch { saveError = "Your latest changes could not be saved. Please try again." }
    }

    func add(title: String, person: String, deadline: Date) {
        let clean = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty, deadline > Date() else { return }
        challenges.insert(Challenge(title: clean, person: person, deadline: deadline), at: 0)
        save()
    }

    func predict(_ id: UUID, yes: Bool) {
        guard let i = challenges.firstIndex(where: { $0.id == id }),
              challenges[i].outcome == nil, challenges[i].deadline > Date() else { return }
        challenges[i].predictions["You"] = yes
        save()
    }

    func resolve(_ id: UUID, success: Bool) {
        guard let i = challenges.firstIndex(where: { $0.id == id }), challenges[i].outcome == nil else { return }
        challenges[i].outcome = success
        save()
    }

    func score(_ friend: String) -> Int {
        challenges.reduce(0) { score, challenge in
            guard let result = challenge.outcome else { return score }
            return score + (challenge.predictions[friend] == result ? 10 : 0)
        }
    }
}

@main
struct BetYouCantApp: App {
    @StateObject private var store = ChallengeStore()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(store).tint(.indigo)
                .alert("Storage issue", isPresented: Binding(get: { store.saveError != nil }, set: { if !$0 { store.saveError = nil } })) {
                    Button("OK") { store.saveError = nil }
                } message: { Text(store.saveError ?? "") }
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            ChallengeList().tabItem { Label("Challenges", systemImage: "bolt.fill") }
            Leaderboard().tabItem { Label("Leaderboard", systemImage: "trophy.fill") }
        }
    }
}

struct ChallengeList: View {
    @EnvironmentObject private var store: ChallengeStore
    @State private var showCreate = false
    @State private var showCompleted = false
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Big talk. Small challenges.").font(.title2.bold())
                        Text("Make a prediction. Cheer on your friends. Earn bragging rights.")
                            .foregroundStyle(.secondary)
                        Label("Local demo · No real-money betting", systemImage: "sparkles")
                            .font(.caption).foregroundStyle(.indigo)
                    }.padding(.vertical, 8)
                }
                Section {
                    Picker("Show challenges", selection: $showCompleted) {
                        Text("Active").tag(false)
                        Text("Completed").tag(true)
                    }.pickerStyle(.segmented)
                    let visible = store.challenges.filter { ($0.outcome != nil) == showCompleted }
                    if visible.isEmpty {
                        ContentUnavailableView(showCompleted ? "No results yet" : "Your next challenge?", systemImage: "bolt.circle", description: Text(showCompleted ? "Completed challenges will appear here." : "Tap + to challenge a friend."))
                    }
                    ForEach(visible) { challenge in
                        NavigationLink {
                            ChallengeDetail(id: challenge.id)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(challenge.person.uppercased()).font(.caption.bold()).foregroundStyle(.indigo)
                                Text(challenge.title).font(.headline)
                                if let outcome = challenge.outcome {
                                    Label(outcome ? "Challenge completed" : "Challenge missed", systemImage: outcome ? "checkmark.circle.fill" : "xmark.circle")
                                        .font(.caption).foregroundStyle(.secondary)
                                } else {
                                    Text(challenge.deadline, style: .relative).font(.caption)
                                        .foregroundStyle(.secondary)
                                    Text("Due \(challenge.deadline.formatted(date: .abbreviated, time: .shortened)) · \(challenge.predictions.count) predictions")
                                        .font(.caption).foregroundStyle(.secondary)
                                }
                            }.padding(.vertical, 6)
                        }
                    }
                }
            }
            .navigationTitle("Bet You Can’t")
            .toolbar { Button { showCreate = true } label: { Image(systemName: "plus") }.accessibilityLabel("Create challenge") }
            .sheet(isPresented: $showCreate) { CreateChallenge() }
        }
    }
}

struct CreateChallenge: View {
    @EnvironmentObject private var store: ChallengeStore
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var person = "You"
    @State private var deadline = Date().addingTimeInterval(86400)
    var body: some View {
        NavigationStack {
            Form {
                Section("The challenge") {
                    TextField("e.g. Go a whole day without coffee", text: $title, axis: .vertical)
                    Picker("Who's doing it?", selection: $person) {
                        ForEach(store.friends, id: \.self) { Text($0) }
                    }
                    DatePicker("Deadline", selection: $deadline, in: Date()...)
                }
                Section {
                    Text("Choose something safe, specific, and easy to verify. Correct predictions earn 10 points; incorrect predictions earn 0.")
                    Text("These friends are demo profiles on this device.").foregroundStyle(.secondary)
                }
            }
            .navigationTitle("New challenge").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { store.add(title: title, person: person, deadline: deadline); dismiss() }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || deadline <= Date())
                }
            }
        }
    }
}

struct ChallengeDetail: View {
    @EnvironmentObject private var store: ChallengeStore
    let id: UUID
    @State private var pendingOutcome: Bool?
    @State private var confirmResult = false
    var body: some View {
        if let challenge = store.challenges.first(where: { $0.id == id }) {
            List {
                Section {
                    Text(challenge.title).font(.largeTitle.bold())
                    Label(challenge.person, systemImage: "person.fill")
                    Label(challenge.deadline.formatted(date: .abbreviated, time: .shortened), systemImage: "clock")
                }
                Section("Your prediction") {
                    if let outcome = challenge.outcome {
                        Text(outcome ? "They did it!" : "Maybe next time.").font(.headline)
                        if let prediction = challenge.predictions["You"] {
                            Text(prediction == outcome ? "Correct prediction! +10 points" : "Incorrect prediction · 0 points")
                        } else { Text("You didn't predict this challenge.") }
                    } else {
                        TimelineView(.periodic(from: .now, by: 1)) { context in
                            VStack(alignment: .leading, spacing: 12) {
                                Text(challenge.predictions["You"].map { $0 ? "You said: They can!" : "You said: Bet they can’t!" } ?? "Think they can pull it off?")
                                HStack {
                                    Button("They can!") { store.predict(id, yes: true) }
                                    Button("Bet they can’t") { store.predict(id, yes: false) }
                                }.buttonStyle(.bordered).disabled(context.date >= challenge.deadline)
                                Text(context.date >= challenge.deadline ? "Predictions closed. Record the result below." : "You can change your prediction until the deadline or a result is recorded.")
                                    .font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                Section("Predictions · \(challenge.predictions.count)") {
                    if challenge.predictions.isEmpty { Text("Be the first to predict.").foregroundStyle(.secondary) }
                    ForEach(challenge.predictions.keys.sorted(), id: \.self) { friend in
                        HStack { Text(friend); Spacer(); Text(challenge.predictions[friend] == true ? "They can!" : "They can’t").foregroundStyle(.secondary) }
                    }
                }
                if challenge.outcome == nil {
                    Section {
                        Button("They did it") { pendingOutcome = true; confirmResult = true }
                        Button("They didn't make it") { pendingOutcome = false; confirmResult = true }
                    } header: { Text("Record result") } footer: {
                        Text("In this demo, you record results for everyone. Recording a result closes predictions and updates the leaderboard permanently.")
                    }
                }
            }
            .navigationTitle("Challenge").navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("Confirm result: \(pendingOutcome == true ? "They did it" : "They didn't make it")?", isPresented: $confirmResult, titleVisibility: .visible) {
                Button("Record result") { if let outcome = pendingOutcome { store.resolve(id, success: outcome) } }
                Button("Cancel", role: .cancel) {}
            } message: { Text("This closes predictions and awards points. It cannot be undone.") }
        }
    }
}

struct Leaderboard: View {
    @EnvironmentObject private var store: ChallengeStore
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Bragging rights only.").font(.title2.bold())
                        Text("10 points per correct prediction. No money, no wagers.").foregroundStyle(.secondary)
                    }.padding(.vertical, 8)
                }
                Section("Your demo group") {
                    let ranked = store.friends.sorted { store.score($0) == store.score($1) ? $0 < $1 : store.score($0) > store.score($1) }
                    ForEach(ranked, id: \.self) { friend in
                        let rank = 1 + store.friends.filter { store.score($0) > store.score(friend) }.count
                        HStack(spacing: 16) {
                            Text("\(rank)").font(.headline).foregroundStyle(.indigo).frame(width: 24)
                            Text(friend).fontWeight(friend == "You" ? .bold : .regular)
                            Spacer()
                            Text("\(store.score(friend)) pts").monospacedDigit().foregroundStyle(.secondary)
                        }.padding(.vertical, 8)
                    }
                }
            }.navigationTitle("Leaderboard")
        }
    }
}
