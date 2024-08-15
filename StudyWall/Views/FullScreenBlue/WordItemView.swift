import SwiftUI
import AVFoundation

struct WordItemView: View {
    let wordData: WordData
    let speechSynthesizer: AVSpeechSynthesizer
    @Binding var areControlButtonsHidden: Bool
    @State private var isChecked: Bool = false  // チェックボックスの状態を管理するための状態変数

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            headerView
            Divider()
                .background(Color.gray)
            sentencesView
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
            if !areControlButtonsHidden {
                speakerButton(for: wordData.word)
            }
            Text(wordData.pronunciation)
                .font(.caption2)
                .foregroundColor(.gray)
            Text(wordData.translation)
                .font(.caption)
                .foregroundColor(.gray)
            Spacer()
            if !areControlButtonsHidden {
                Toggle("", isOn: $isChecked)
                    .toggleStyle(CheckboxStyle())
                    .labelsHidden()
            }
        }
        .padding(.bottom, 3)
    }

    // 文章部分を分離
    private var sentencesView: some View {
        ForEach(wordData.sentences) { sentence in
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    if !areControlButtonsHidden {
                        speakerButton(for: sentence.english)
                    }
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
struct WordItemView_Previews: PreviewProvider {
    @State static var areControlButtonsHidden = false

    static var previews: some View {
        WordItemView(
            wordData: WordData(
                word: "Example",
                translation: "例",
                pronunciation: "ɪɡˈzæmpəl",
                sentences: [
                    Sentence(english: "This is an example sentence.", japanese: "これは例文です。"),
                    Sentence(english: "Another example sentence.", japanese: "もう一つの例文です。")
                ]
            ),
            speechSynthesizer: AVSpeechSynthesizer(),
            areControlButtonsHidden: $areControlButtonsHidden
        )
        .previewLayout(.sizeThatFits)
    }
}
