import SwiftUI
import AVFoundation

struct WordItemView: View {
    let wordData: WordData
    let speechSynthesizer: AVSpeechSynthesizer

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(wordData.word)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: {
                    // 現在再生中の音声を停止する
                    if speechSynthesizer.isSpeaking {
                        speechSynthesizer.stopSpeaking(at: .immediate)
                    }
                    // 新しい音声を再生する
                    let utterance = AVSpeechUtterance(string: wordData.word)
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                    speechSynthesizer.speak(utterance)
                }) {
                    Image(systemName: "speaker.wave.2.fill")
                        .foregroundColor(.blue)
                }
                Text(wordData.pronunciation)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(wordData.translation)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 3)
            Divider()
                .background(Color.gray)
            ForEach(wordData.sentences) { sentence in
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(sentence.english)
                            .font(.caption)
                        Spacer()
                        Button(action: {
                            // 現在再生中の音声を停止する
                            if speechSynthesizer.isSpeaking {
                                speechSynthesizer.stopSpeaking(at: .immediate)
                            }
                            // 新しい音声を再生する
                            let utterance = AVSpeechUtterance(string: sentence.english)
                            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                            speechSynthesizer.speak(utterance)
                        }) {
                            Image(systemName: "speaker.wave.2.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    Text(sentence.japanese)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal, 8)
    }
}
