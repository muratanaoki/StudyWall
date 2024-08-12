import SwiftUI

struct TopButtonsView: View {
    @Binding var isFullScreen: ImageItem?  // このバインディングを追加

    var body: some View {
        HStack {
            Spacer()  // 右端に配置するためのスペーサー
            Button(action: {
                isFullScreen = nil  // ここでフルスクリーンを解除
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .padding()
            }
            .foregroundColor(.white)
        }
        .padding(.horizontal, 10)
        .padding(.top, 0)
    }
}
