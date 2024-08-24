import SwiftUI

struct IconButton: View {
    let imageName: String
    let scalingFactor: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 50 * scalingFactor, height: 50 * scalingFactor)
            Image(systemName: imageName)
                .font(.system(size: 20 * scalingFactor))
                .foregroundColor(.white)
        }
    }
}
