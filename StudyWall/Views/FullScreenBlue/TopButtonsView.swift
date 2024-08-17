import SwiftUI

struct TopButtonsView: View {
    @Binding var isFullScreen: ImageItem?  // このバインディングを追加
    let scalingFactor: CGFloat

    var body: some View {
        HStack {
            Spacer()  // 右端に配置するためのスペーサー
            Button(action: {
                isFullScreen = nil  // ここでフルスクリーンを解除
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()  // サイズを変更可能にする
                    .aspectRatio(contentMode: .fit)  // アスペクト比を保つ
                    .frame(width: 30 * scalingFactor, height: 30 * scalingFactor)  // スケーリングに対応
                    .padding(10 * scalingFactor)  // パディングをスケーリングに対応
            }
            .foregroundColor(.white)
        }
        .padding(.horizontal, 10 * scalingFactor)
//        .padding(.top)
    }
}
