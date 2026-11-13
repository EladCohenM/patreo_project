import SwiftUI

enum AppTheme {
    static let accent = Color(red: 0.38, green: 0.24, blue: 0.96)
    static let success = Color(red: 0.08, green: 0.67, blue: 0.45)
    static let danger = Color(red: 0.94, green: 0.26, blue: 0.35)
    static let card = Color(uiColor: .secondarySystemGroupedBackground)
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(AppTheme.card, in: RoundedRectangle(cornerRadius: 20))
    }
}

extension View {
    func cardStyle() -> some View { modifier(CardStyle()) }
}
