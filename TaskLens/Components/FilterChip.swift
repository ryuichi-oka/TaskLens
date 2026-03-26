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
                .font(.caption.weight(.semibold))
                .padding(.vertical, Layout.chipVertical)
                .padding(.horizontal, Layout.chipHorizontal)
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .background(isSelected ? tint : Color(.secondarySystemBackground))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.gray.opacity(0.2), lineWidth: isSelected ? 0 : 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FilterChip(title: "進行中", isSelected: true, tint: .blue, action: {})
}
