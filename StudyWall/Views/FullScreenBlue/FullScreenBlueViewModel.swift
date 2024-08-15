import SwiftUI
import AVFoundation
import Photos

class FullScreenBlueViewModel: ObservableObject {
    @Published var alertData = AlertData(title: "", message: "", isPresented: false)
    @Published var currentTime: Date = Date()
    @Published var isLocked: Bool = false
    @Published var showControlButtons: Bool = false
    @Published var tapGestureEnabled: Bool = false
    @Published var hideButtonsForScreenshot: Bool = false
    @Published var areControlButtonsHidden: Bool = false
    @Published var showColorPicker: Bool = false // カラーピッカーの表示状態を管理
    @Published var selectedColor: Color = .blue // 選択された色を保持

    let speechSynthesizer = AVSpeechSynthesizer()

    func startClock() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.currentTime = Date()
        }
    }

    func captureScreenshot() {
        areControlButtonsHidden = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            let screenBounds = window.bounds
            UIGraphicsBeginImageContextWithOptions(screenBounds.size, false, 0)
            window.drawHierarchy(in: screenBounds, afterScreenUpdates: true)
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            self.areControlButtonsHidden = false

            if let screenshot = screenshot {
                self.saveImageToPhotos(screenshot) { success in
                    if success {
                        self.alertData.title = "ダウンロード成功"
                        self.alertData.message = "画像が正常に保存されました。"
                    } else {
                        self.alertData.title = "ダウンロード失敗"
                        self.alertData.message = "画像の保存に失敗しました。もう一度お試しください。"
                    }
                    self.alertData.isPresented = true
                }
            }
        }
    }

    func toggleLock() {
        withAnimation {
            isLocked = true
            areControlButtonsHidden = true
            tapGestureEnabled = true
        }
    }

    func unlock() {
        withAnimation {
            isLocked = false
            areControlButtonsHidden = false
            tapGestureEnabled = false
        }
    }

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
