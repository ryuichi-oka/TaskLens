import SwiftUI

// フィルタ選択用のチップ
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.captionEmphasis)
                .padding(.vertical, Layout.chipVertical)
                .padding(.horizontal, Layout.chipHorizontal)
                .foregroundStyle(isSelected ? Color.accentPrimary : Color.textPrimary)
                .background(isSelected ? Color.accentPrimary.opacity(0.14) : Color.surfacePrimary)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.borderPrimary, lineWidth: isSelected ? 0 : 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FilterChip(title: "進行中", isSelected: true, tint: .blue, action: {})
}
