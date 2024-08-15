import SwiftUI

struct BottomButtonsView: View {
    @Binding var isLocked: Bool
    @Binding var hideButtonsForScreenshot: Bool
    var captureScreenshot: () -> Void
    @Binding var tapGestureEnabled: Bool
    @Binding var areControlButtonsHidden: Bool

    var body: some View {
        HStack {
            if !areControlButtonsHidden {
                controlButton(iconName: "lock.iphone") {
                    isLocked = true
                    areControlButtonsHidden = true
                    tapGestureEnabled = true
                }

                Spacer()

                controlButton(iconName: "eye") {
                    // ここに必要なアクションを追加
                }

                Spacer()

                controlButton(iconName: "paintpalette") {
                    // ここに必要なアクションを追加
                }

                Spacer()

                controlButton(iconName: "square.and.arrow.up") {
                    // ここに必要なアクションを追加
                }

                Spacer()

                controlButton(iconName: "square.and.arrow.down") {
                    hideButtonsForScreenshot = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        captureScreenshot()
                        hideButtonsForScreenshot = false
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 20)
    }

    // 共通のボタンを作成するヘルパーメソッド
    private func controlButton(iconName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.title)
                .padding()
        }
        .foregroundColor(.white)
    }
}
