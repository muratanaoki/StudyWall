import SwiftUI

struct HeaderView: View {
    let scalingFactor: CGFloat

    var body: some View {
        HStack {
            Text("単語")
                .font(.system(size: 18 * scalingFactor))  // スケーリングに対応
            Spacer()
            Text("|")
                .font(.system(size: 18 * scalingFactor))  // スケーリングに対応
            Text("復習")
                .font(.system(size: 18 * scalingFactor))  // スケーリングに対応
        }
        .padding(.horizontal, 8 * scalingFactor)
        .padding(.vertical, 10 * scalingFactor)
        .background(Color.white)
        .cornerRadius(10 * scalingFactor)
        .padding(.horizontal, 8 * scalingFactor)
    }
}
