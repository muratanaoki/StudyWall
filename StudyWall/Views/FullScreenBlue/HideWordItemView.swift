import SwiftUI
import AVFoundation

struct HideWordItemView: View {
    let wordData: WordData
    let speechSynthesizer: AVSpeechSynthesizer
    @State private var isChecked: Bool = false
    let scalingFactor: CGFloat //

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            headerView
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal, 8)
    }

    // ヘッダー部分を分離
    private var headerView: some View {
        HStack {
            Text(wordData.word)
                .font(.subheadline)

            speakerButton(for: wordData.word)

            Text(wordData.pronunciation)
                .font(.caption2)
                .foregroundColor(.gray)
            Spacer()

            Toggle("", isOn: $isChecked)
                .toggleStyle(CheckboxStyle(scalingFactor: scalingFactor))
                .labelsHidden()
        }
        .padding(.bottom, 3)
    }

    // 文章部分を分離
    private var sentencesView: some View {
        ForEach(wordData.sentences) { sentence in
            VStack(alignment: .leading, spacing: 2) {
                HStack {

                    speakerButton(for: sentence.english)

                    Text(sentence.english)
                        .font(.caption)
                }
                Text(sentence.japanese)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }

    // スピーカーボタンの共通化
    private func speakerButton(for text: String) -> some View {
        Button(action: {
            if speechSynthesizer.isSpeaking {
                speechSynthesizer.stopSpeaking(at: .immediate)
            }
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            speechSynthesizer.speak(utterance)
        }) {
            Image(systemName: "speaker.wave.2.fill")
                .foregroundColor(.blue)
        }
    }
}

// プレビュー
//struct HideWordItemView_Previews: PreviewProvider {
//    @State static var areControlButtonsHidden = false
//
//    static var previews: some View {
//        HideWordItemView(
//            wordData: WordData(
//                word: "Example",
//                translation: "例",
//                pronunciation: "ɪɡˈzæmpəl",
//                sentences: [
//                    Sentence(english: "This is an example sentence.", japanese: "これは例文です。"),
//                    Sentence(english: "Another example sentence.", japanese: "もう一つの例文です。")
//                ]
//            ),
//            speechSynthesizer: AVSpeechSynthesizer(),
//            areControlButtonsHidden: $areControlButtonsHidden, scalingFactor: CGFloat
//        )
//        .previewLayout(.sizeThatFits)
//    }
//}
