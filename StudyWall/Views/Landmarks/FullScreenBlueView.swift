import SwiftUI
import UIKit

struct FullScreenBlueView: View {
    let wordsData: [WordData]
    @Binding var selectedIndex: Int
    @Binding var isFullScreen: ImageItem?
    @State private var showAlert = false // アラートを表示するかどうか
    @State private var alertTitle = "" // アラートのタイトル
    @State private var alertMessage = "" // アラートのメッセージ
    @State private var currentTime: Date = Date()
    @State private var isLocked: Bool = true
    @State private var showButtons: Bool = true

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.blue
                .ignoresSafeArea()
            VStack(spacing: 5) {
                TabView {
                    ForEach(0..<5, id: \.self) { _ in
                        VStack {
                            ForEach(0..<min(5, wordsData.count), id: \.self) { index in
                                wordItemView(index: index)
                            }
                        }
                        .padding(.top, 20)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .frame(maxHeight: .infinity)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            if !isLocked { timeOverlay }
            if !isLocked { controlButtons }
            if showButtons { topButtons }
        }
        .onAppear {
            startClock()
            setupNotificationListeners()
        }
    }

    private func setupNotificationListeners() {
        NotificationCenter.default.addObserver(forName: .screenshotSaveSucceeded, object: nil, queue: .main) { _ in
            alertTitle = "ダウンロード成功"
            alertMessage = "画像が正常に保存されました。"
            showAlert = true
        }
        NotificationCenter.default.addObserver(forName: .screenshotSaveFailed, object: nil, queue: .main) { _ in
            alertTitle = "ダウンロード失敗"
            alertMessage = "画像の保存に失敗しました。もう一度お試しください。"
            showAlert = true
        }
    }

    private func wordItemView(index: Int) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(wordsData[index].word)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(wordsData[index].pronunciation)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(wordsData[index].translation)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 3)
            Divider()
                .background(Color.gray)
            ForEach(wordsData[index].sentences) { sentence in
                VStack(alignment: .leading, spacing: 2) {
                    Text(sentence.english)
                        .font(.caption)
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

    private var timeOverlay: some View {
        VStack {
            Text("\(currentTime, formatter: DateFormatter.dateFormatter)")
                .font(.system(size: 18))
                .foregroundColor(.white)
                .padding(.top, 10)
            Text("\(currentTime, formatter: DateFormatter.hhmmFormatter)")
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, -10)
                .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 10)
    }

    private var controlButtons: some View {
        HStack {
            Button(action: {}) {
                iconButton(imageName: "flashlight.on.fill")
            }
            Spacer()
            Button(action: {}) {
                iconButton(imageName: "camera.fill")
            }
        }
        .padding(.bottom, 20)
        .padding(.horizontal, 60)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }

    private var topButtons: some View {
        HStack {
            Button(action: { isLocked.toggle() }) {
                Image(systemName: isLocked ? "lock.iphone" : "iphone")
                    .font(.title)
                    .padding()
            }
            .foregroundColor(.white)
            Spacer()
            Button(action: {
                showButtons = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    captureScreenshot()
                    showButtons = true
                }
            }) {
                Image(systemName: "square.and.arrow.down")
                    .font(.title)
                    .padding()
            }
            .foregroundColor(.white)
            Spacer()
            Button(action: { isFullScreen = nil }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .padding()
            }
            .foregroundColor(.white)
        }
        .padding(.horizontal, 10)
        .padding(.top, 0)
    }

    private func iconButton(imageName: String) -> some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 60, height: 60)
            Image(systemName: imageName)
                .font(.system(size: 30))
                .foregroundColor(.white)
        }
    }

    private func startClock() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            currentTime = Date()
        }
    }

    func captureScreenshot() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        let screenBounds = window.bounds
        UIGraphicsBeginImageContextWithOptions(screenBounds.size, false, 0)
        window.drawHierarchy(in: screenBounds, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let screenshot = screenshot {
            UIImageWriteToSavedPhotosAlbum(screenshot, ScreenshotSaver.shared, #selector(ScreenshotSaver.saveCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
}

// クラスベースのクラスを使って Objective-C メソッドを使用
class ScreenshotSaver: NSObject {
    static let shared = ScreenshotSaver()

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        DispatchQueue.main.async {
            if let error = error {
                NotificationCenter.default.post(name: .screenshotSaveFailed, object: nil)
            } else {
                NotificationCenter.default.post(name: .screenshotSaveSucceeded, object: nil)
            }
        }
    }
}

extension Notification.Name {
    static let screenshotSaveSucceeded = Notification.Name("screenshotSaveSucceeded")
    static let screenshotSaveFailed = Notification.Name("screenshotSaveFailed")
}

// プレビュー用のコード
struct FullScreenBlueView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenBlueView(
            wordsData: sampleWordsData,
            selectedIndex: .constant(0),
            isFullScreen: .constant(nil)
        )
    }

    static var sampleWordsData: [WordData] {
        [
            WordData(
                word: "Example",
                translation: "例",
                pronunciation: "[ɪɡˈzæmpəl]",
                sentences: [
                    Sentence(english: "This is an example sentence.", japanese: "これは例文です。"),
                    Sentence(english: "Here is another example.", japanese: "こちらも例です。")
                ]
            )
        ]
    }
}
