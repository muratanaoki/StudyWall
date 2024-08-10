import SwiftUI
import UIKit

// フルスクリーンで青い背景と単語データを表示するビュー
struct FullScreenBlueView: View {
    // 表示する単語データ
    let wordsData: [WordData]
    // 現在選択されているインデックス
    @Binding var selectedIndex: Int
    // モーダル表示の状態
    @Binding var isFullScreen: ImageItem?
    // アラートを表示するかどうか
    @State private var showAlert = false
    // アラートのタイトル
    @State private var alertTitle = ""
    // アラートのメッセージ
    @State private var alertMessage = ""
    // 現在の時刻
    @State private var currentTime: Date = Date()
    // 画面がロックされているかどうか
    @State private var isLocked: Bool = true
    // ボタンを表示するかどうか
    @State private var showButtons: Bool = true

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // 背景色を青に設定し、画面全体に広がるようにする
            Color.blue
                .ignoresSafeArea()

            // 単語データを表示するコンテンツ
            VStack(spacing: 5) {
                // 横にスライドできるタブビュー
                TabView {
                    // 単語データを表示する繰り返し処理
                    ForEach(0..<5, id: \.self) { _ in
                        VStack {
                            ForEach(0..<min(5, wordsData.count), id: \.self) { index in
                                wordItemView(index: index)
                            }
                        }
                        .padding(.top, 20)
                    }
                }
                // タブインジケーターを表示しない設定
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .frame(maxHeight: .infinity)

            // アラートを表示するためのモディファイア
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }

            // 画面がロックされていない場合に時計とボタンを表示
            if !isLocked { timeOverlay }
            if !isLocked { controlButtons }
            if showButtons { topButtons }
        }
        .onAppear {
            // 画面が表示されたときに時計を開始し、通知リスナーを設定
            startClock()
            setupNotificationListeners()
        }
    }

    // 通知リスナーを設定する関数
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

    // 単語データの表示をカスタマイズするビュー
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

    // 時計と日付を表示するビュー
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

    // フラッシュライトとカメラのボタンを表示するビュー
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

    // 上部にロックボタンやスクリーンショットボタンを表示するビュー
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

    // 丸いアイコンボタンを表示するカスタムビュー
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

    // 時計をスタートさせる関数
    private func startClock() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            currentTime = Date()
        }
    }

    // スクリーンショットをキャプチャして保存する関数
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

// スクリーンショットの保存処理を行うクラス
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

// 通知名を拡張して簡単に使えるようにする
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
