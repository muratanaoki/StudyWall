import SwiftUI

struct IconButton: View {
    let imageName: String

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 60, height: 60)
            Image(systemName: imageName)
                .font(.system(size: 30))
                .foregroundColor(.white)
        }
    }
}
