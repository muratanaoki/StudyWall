import SwiftUI
import Photos

struct FullScreenBlueView: View {
    let wordsData: [WordData]
    @Binding var selectedIndex: Int
    @Binding var isFullScreen: ImageItem?
    @State private var alertData = AlertData(title: "", message: "", isPresented: false)
    @State private var currentTime: Date = Date()
    @State private var isLocked: Bool = false
    @State private var showControlButtons: Bool = false
    @State private var tapGestureEnabled: Bool = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // 背景色を青に設定し、画面全体に広がるようにする
            Color.blue
                .ignoresSafeArea()

            // 単語データを表示するコンテンツ
            VStack(spacing: 5) {
                TabView {
                    ForEach(0..<5, id: \.self) { _ in
                        VStack {
                            ForEach(0..<min(5, wordsData.count), id: \.self) { index in
                                WordItemView(wordData: wordsData[index])
                            }
                        }
                        .padding(.top, 20)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .frame(maxHeight: .infinity)
            .alert(isPresented: $alertData.isPresented) {
                Alert(
                    title: Text(alertData.title),
                    message: Text(alertData.message),
                    dismissButton: .default(Text("OK"))
                )
            }

            // 画面全体でのタップ操作を検知
            if tapGestureEnabled {
                Color.clear
                    .contentShape(Rectangle())  // タップ可能な領域を拡張
                    .onTapGesture {
                        // 画面をタップしたときにボタンの表示を切り替える
                        withAnimation {
                            showControlButtons = false
                            isLocked = false
                            tapGestureEnabled = false  // タップ機能をオフにする
                        }
                    }
            }

            // 時計、日付、ライトボタン、カメラボタン（ロックされている時に表示）
            if isLocked { timeOverlay }
            if isLocked { controlIcons }

            // 上部にDLボタン、バツボタン、ロックボタンを表示（初期表示とロック解除後に表示）
            if !isLocked { topButtons }
        }
        .onAppear {
            startClock()
        }
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

    // フラッシュライトとカメラのアイコンを表示するビュー
    private var controlIcons: some View {
        HStack {
            IconButton(imageName: "flashlight.on.fill")
            Spacer()
            IconButton(imageName: "camera.fill")
        }
        .padding(.bottom, 20)
        .padding(.horizontal, 60)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }

    // 上部にロックボタンやスクリーンショットボタン、バツボタンを表示するビュー
    private var topButtons: some View {
        HStack {
            Button(action: {
                withAnimation {
                    isLocked = true
                    showControlButtons = true
                    tapGestureEnabled = true  // タップ機能を有効にする
                }
            }) {
                Image(systemName: "lock.iphone")
                    .font(.title)
                    .padding()
            }
            .foregroundColor(.white)
            Spacer()
            Button(action: {
                // DL機能（スクリーンショットをキャプチャして保存する）
                captureScreenshot()
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

    // 時計をスタートさせる関数
    private func startClock() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            currentTime = Date()
        }
    }

    // スクリーンショットをキャプチャして保存する関数
    private func captureScreenshot() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        let screenBounds = window.bounds
        UIGraphicsBeginImageContextWithOptions(screenBounds.size, false, 0)
        window.drawHierarchy(in: screenBounds, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let screenshot = screenshot {
            saveImageToPhotos(screenshot) { success in
                if success {
                    alertData.title = "ダウンロード成功"
                    alertData.message = "画像が正常に保存されました。"
                } else {
                    alertData.title = "ダウンロード失敗"
                    alertData.message = "画像の保存に失敗しました。もう一度お試しください。"
                }
                alertData.isPresented = true
            }
        }
    }

    // 画像をフォトライブラリに保存する関数
    private func saveImageToPhotos(_ image: UIImage, completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }

            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        }
    }
}

// 単語データの表示をカスタマイズするビュー
struct WordItemView: View {
    let wordData: WordData

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(wordData.word)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
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
}

// 丸いアイコンを表示するカスタムビュー（ボタン機能なし）
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

// アラートデータ構造体
struct AlertData {
    var title: String
    var message: String
    var isPresented: Bool
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
            ),

        ]
    }
}
