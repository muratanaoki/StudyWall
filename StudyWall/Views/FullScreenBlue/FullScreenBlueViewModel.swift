import SwiftUI
import AVFoundation
import Photos

/// `FullScreenBlueViewModel` クラスは、フルスクリーンモードのビューに関連する状態管理とロジックを提供する。
class FullScreenBlueViewModel: ObservableObject {
    // アラートデータを保持するPublishedプロパティ
    @Published var alertData = AlertData(title: "", message: "", isPresented: false)
    @Published var currentTime: Date = Date() // 現在の時間を保持するPublishedプロパティ
    @Published var isLocked: Bool = false // ビューがロックされているかどうかの状態を管理
    @Published var showControlButtons: Bool = false // コントロールボタンを表示するかどうかの状態を管理
    @Published var tapGestureEnabled: Bool = false // タップジェスチャーが有効かどうかの状態を管理
    @Published var hideButtonsForScreenshot: Bool = false // スクリーンショット時にボタンを隠すかどうかの状態を管理
    @Published var areControlButtonsHidden: Bool = false // コントロールボタンが非表示かどうかの状態を管理
    @Published var showColorPicker: Bool = false // カラーピッカーを表示するかどうかの状態を管理
    @Published var selectedColor: Color = .blue // 選択された色を保持
    @Published var isEyeOpen: Bool = true // アイコンの状態を管理

    // 音声合成のためのオブジェクト
    let speechSynthesizer = AVSpeechSynthesizer()
    private var timer: Timer? // 時間更新のためのタイマー

    /**
     時間を1秒ごとに更新するタイマーを開始する。

     - タイマーは既存のタイマーを無効化し、新しいタイマーを開始することで、複数のタイマーが動作するのを防ぐ。
     */
    func startClock() {
        timer?.invalidate() // 既存のタイマーを無効化
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.currentTime = Date() // 毎秒現在の時間を更新
        }
    }

    /**
     タイマーを停止し、タイマーオブジェクトをnilにする。

     - タイマーが不要になった時に呼び出してリソースを解放する。
     */
    func stopClock() {
        timer?.invalidate() // タイマーを無効化
        timer = nil
    }

    /**
     現在の画面のスクリーンショットをキャプチャし、フォトライブラリに保存する。

     - ボタンを一時的に隠し、スクリーンショットをキャプチャしてから再度表示する。
     */
    func captureScreenshot() {
        areControlButtonsHidden = true // スクリーンショットの前にボタンを隠す
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.createScreenshot { screenshot in
                self.areControlButtonsHidden = false // スクリーンショット後にボタンを表示する
                if let screenshot = screenshot {
                    self.saveImageToPhotos(screenshot) // スクリーンショットをフォトライブラリに保存
                }
            }
        }
    }

    /**
     現在の画面のスクリーンショットを作成し、完了ハンドラーで画像を返す。

     - Parameters:
       - completion: 生成されたスクリーンショット画像を返すクロージャ
     */
    private func createScreenshot(completion: @escaping (UIImage?) -> Void) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            completion(nil) // ウィンドウが見つからない場合はnilを返す
            return
        }

        let screenBounds = window.bounds
        UIGraphicsBeginImageContextWithOptions(screenBounds.size, false, 0)
        window.drawHierarchy(in: screenBounds, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        completion(screenshot) // スクリーンショット画像を返す
    }

    /**
     ロック状態を切り替え、コントロールボタンの表示状態を変更する。

     - ロック状態が変わるとアニメーションを伴い、関連するプロパティの値も変更される。
     */
    func toggleLock() {
        withAnimation {
            isLocked.toggle() // ロック状態を切り替える
            areControlButtonsHidden = isLocked // ロック状態に応じてコントロールボタンを表示/非表示
            tapGestureEnabled = isLocked // ロック状態に応じてタップジェスチャーを有効/無効
        }
    }

    /**
     アイコンの状態を管理するプロパティの値を反転させる。

     - アイコンが開いているかどうかの状態を管理する。
     */
    func toggleEyeIcon() {
        isEyeOpen.toggle() // アイコンの開閉状態を反転
    }

    /**
     指定した画像をフォトライブラリに保存し、成功または失敗のアラートを表示する。

     - Parameters:
       - image: 保存する画像
     */
    private func saveImageToPhotos(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                DispatchQueue.main.async {
                    self.showSaveResultAlert(success: false) // アクセス権がない場合は失敗アラートを表示
                }
                return
            }

            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, _ in
                DispatchQueue.main.async {
                    self.showSaveResultAlert(success: success) // 保存成功または失敗のアラートを表示
                }
            }
        }
    }

    /**
     画像保存の結果に応じてアラートを設定し、表示する。

     - Parameters:
       - success: 画像保存が成功したかどうか
     */
    private func showSaveResultAlert(success: Bool) {
        alertData.title = success ? "ダウンロード成功" : "ダウンロード失敗"
        alertData.message = success ? "画像が正常に保存されました。" : "画像の保存に失敗しました。もう一度お試しください。"
        alertData.isPresented = true // アラートを表示するためにフラグを設定
    }
}
