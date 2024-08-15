import SwiftUI

struct BottomButtonsView: View {
    @Binding var isLocked: Bool
    @Binding var hideButtonsForScreenshot: Bool
    var captureScreenshot: () -> Void
    @Binding var tapGestureEnabled: Bool
    @Binding var areControlButtonsHidden: Bool
    @Binding var selectedColor: Color // 選択された色

    var body: some View {
        VStack {
            if !areControlButtonsHidden {
                HStack {
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

                    ZStack {
                        // カスタムのpaintpaletteボタンを上に配置
                        Button(action: {
                            // このボタンが透明なColorPickerをクリック
                        }) {
                            Image(systemName: "paintpalette")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        // ColorPicker本体のラベルを隠して透明に設定
                        ColorPicker("", selection: $selectedColor, supportsOpacity: true)
                            .labelsHidden()  // ラベルを非表示
                            .frame(width: 44, height: 44) // ボタンの大きさに合わせる
                            .opacity(0.02) // 完全に透明に近いが、クリックを許可する
                            .background(Color.clear) // 背景色を透明に設定
                            .allowsHitTesting(true) // 透明でもヒットテストを許可
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
                .padding(.horizontal, 10)
                .padding(.bottom, 20)
            }
        }
    }

    private func controlButton(iconName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.title)
                .padding()
        }
        .foregroundColor(.white)
    }
}
