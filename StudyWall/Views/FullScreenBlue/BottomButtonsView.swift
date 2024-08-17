import SwiftUI

struct BottomButtonsView: View {
    @Binding var isLocked: Bool
    @Binding var hideButtonsForScreenshot: Bool
    var captureScreenshot: () -> Void
    @Binding var tapGestureEnabled: Bool
    @Binding var areControlButtonsHidden: Bool
    @Binding var selectedColor: Color

    @ObservedObject var viewModel: FullScreenBlueViewModel // ViewModelを渡す

    let scalingFactor: CGFloat

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

                    controlButton(iconName: viewModel.isEyeOpen ? "eye" : "eye.slash") {
                        viewModel.toggleEyeIcon()
                    }

                    Spacer()

                    ZStack {
                        Button(action: {
                            // カスタムのpaintpaletteボタンのアクション
                        }) {
                            Image(systemName: "paintpalette")
                                .resizable()  // サイズを変更可能にする
                                .aspectRatio(contentMode: .fit)  // アスペクト比を保つ
                                .frame(width: 30 * scalingFactor, height: 30 * scalingFactor)  // スケーリングに対応
                                .foregroundColor(.white)
                        }
                        ColorPicker("", selection: $selectedColor, supportsOpacity: true)
                            .labelsHidden()
                            .frame(width: 44 * scalingFactor, height: 44 * scalingFactor)
                            .opacity(0.02)
                            .background(Color.clear)
                            .allowsHitTesting(true)
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
                .padding(.horizontal, 10 * scalingFactor)
                .padding(.bottom, 10 * scalingFactor)
            }
        }
    }

    private func controlButton(iconName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: iconName)
                .resizable()  // サイズを変更可能にする
                .aspectRatio(contentMode: .fit)  // アスペクト比を保つ
                .frame(width: 30 * scalingFactor, height: 30 * scalingFactor)  // スケーリングに対応
                .padding(10 * scalingFactor)  // パディングもスケーリングに対応
        }
        .foregroundColor(.white)
    }
}
