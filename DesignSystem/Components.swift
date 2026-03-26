import SwiftUI

struct RoundedCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(Spacing.cardInner)
            .background(Color.surfacePrimary)
            .cornerRadius(12)
    }
}

struct StatusBadgeStyle: ViewModifier {
    let backgroundColor: Color
    let textColor: Color

    func body(content: Content) -> some View {
        content
            .font(.captionEmphasis)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(10)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.bodyEmphasis)
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(Color.accentPrimary.opacity(configuration.isPressed ? 0.85 : 1.0))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

extension View {
    func roundedCard() -> some View {
        modifier(RoundedCardStyle())
    }

    func statusBadge(backgroundColor: Color, textColor: Color) -> some View {
        modifier(StatusBadgeStyle(backgroundColor: backgroundColor, textColor: textColor))
    }
}
