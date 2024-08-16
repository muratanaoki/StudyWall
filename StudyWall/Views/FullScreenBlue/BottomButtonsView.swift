import SwiftUI

struct BottomButtonsView: View {
    @Binding var isLocked: Bool
    @Binding var hideButtonsForScreenshot: Bool
    var captureScreenshot: () -> Void
    @Binding var tapGestureEnabled: Bool
    @Binding var areControlButtonsHidden: Bool
    @Binding var selectedColor: Color
    @ObservedObject var viewModel: FullScreenBlueViewModel // ViewModelを渡す

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
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        ColorPicker("", selection: $selectedColor, supportsOpacity: true)
                            .labelsHidden()
                            .frame(width: 44, height: 44)
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
