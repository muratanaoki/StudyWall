import SwiftUI
import AVFoundation

struct WordItemViewTest: View {
    let wordData: WordData
    let scalingFactor: CGFloat

    @State private var isChecked: Bool = false  // チェックボックスの状態を管理するための状態変数

    var body: some View {
        VStack(alignment: .leading, spacing: 4 * scalingFactor) {
            headerView
            Divider()
                .background(Color.gray)
            sentencesView
        }
        .padding(8 * scalingFactor) // スケーリングに対応
        .background(Color.white)
        .cornerRadius(10 * scalingFactor) // スケーリングに対応
        .shadow(radius: 5 * scalingFactor) // スケーリングに対応
        .padding(.horizontal, 8 * scalingFactor) // スケーリングに対応
    }

    // ヘッダー部分を分離
    private var headerView: some View {
        HStack {
            Text(wordData.word)
                .font(.system(size: 12 * scalingFactor)) // スケーリングに対応
            Text(wordData.pronunciation)
                .font(.system(size: 12 * scalingFactor)) // スケーリングに対応
                .foregroundColor(.gray)
            Text(wordData.translation)
                .font(.system(size: 12 * scalingFactor)) // スケーリングに対応
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.bottom, 3 * scalingFactor) // スケーリングに対応
    }

    // 文章部分を分離
    private var sentencesView: some View {
        ForEach(wordData.sentences) { sentence in
            VStack(alignment: .leading, spacing: 2 * scalingFactor) { // スケーリングに対応
                HStack {
                    Text(sentence.english)
                        .font(.system(size: 12 * scalingFactor)) // スケーリングに対応
                }
                Text(sentence.japanese)
                    .font(.system(size: 12 * scalingFactor)) // スケーリングに対応
                    .foregroundColor(.gray)
            }
        }
    }
}
