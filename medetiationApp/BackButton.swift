import SwiftUI

struct GlassBackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(Color.white.opacity(0.2))
                .clipShape(Circle())
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [.purple, .indigo],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()

        GlassBackButton {}
    }
}
