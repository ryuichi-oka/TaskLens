import SwiftUI

// ステータス表示用のバッジ
struct StatusBadge: View {
    let title: String
    let tint: Color

    var body: some View {
        Text(title)
            .font(.captionEmphasis)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(tint.opacity(0.16))
            .foregroundStyle(tint)
            .clipShape(Capsule())
    }
}

#Preview {
    StatusBadge(title: "進行中", tint: .blue)
}
