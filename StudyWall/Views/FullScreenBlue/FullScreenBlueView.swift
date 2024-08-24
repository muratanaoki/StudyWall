import SwiftUI

import SwiftUI

struct FullScreenBlueView: View {
    let wordsData: [WordData]
    @Binding var selectedIndex: Int
    @Binding var isFullScreen: ImageItem?
    @StateObject private var viewModel = FullScreenBlueViewModel()

    var body: some View {
        ResponsiveContainer { scalingFactor in // 上位で一度だけResponsiveContainerを使用
            FullScreenContentView(
                wordsData: wordsData,
                selectedIndex: $selectedIndex,
                isFullScreen: $isFullScreen,
                viewModel: viewModel,
                scalingFactor: scalingFactor // scalingFactorを渡す
            )
        }
    }
}

struct FullScreenContentView: View {
    let wordsData: [WordData]
    @Binding var selectedIndex: Int
    @Binding var isFullScreen: ImageItem?
    @ObservedObject var viewModel: FullScreenBlueViewModel
    let scalingFactor: CGFloat

    var body: some View {
        ZStack(alignment: .topTrailing) {
            viewModel.selectedColor
                .ignoresSafeArea()

            VStack(spacing: 5) {
                TabView {
                    ForEach(0..<5, id: \.self) { _ in
                        VStack {
                            if shouldShowHeaderView() {
                                HeaderView(scalingFactor: scalingFactor)
                            }

                            displayWordItems(isEyeOpen: viewModel.isEyeOpen, scalingFactor: scalingFactor)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .frame(maxHeight: .infinity)
            .alert(isPresented: $viewModel.alertData.isPresented) {
                Alert(
                    title: Text(viewModel.alertData.title),
                    message: Text(viewModel.alertData.message),
                    dismissButton: .default(Text("OK"))
                )
            }

            overlayViews(scalingFactor: scalingFactor)
        }
        .onAppear {
            viewModel.startClock()
        }
    }

    @ViewBuilder
    private func displayWordItems(isEyeOpen: Bool, scalingFactor: CGFloat) -> some View {
        ForEach(0..<min(5, wordsData.count), id: \.self) { index in
            if isEyeOpen {
                WordItemView(
                    wordData: wordsData[index],
                    speechSynthesizer: viewModel.speechSynthesizer,
                    areControlButtonsHidden: $viewModel.areControlButtonsHidden,
                    scalingFactor: scalingFactor
                )
            } else {
                HideWordItemView(
                    wordData: wordsData[index],
                    speechSynthesizer: viewModel.speechSynthesizer,
                    areControlButtonsHidden: $viewModel.areControlButtonsHidden,
                    scalingFactor: scalingFactor
                )
            }
        }
    }

    @ViewBuilder
    private func overlayViews(scalingFactor: CGFloat) -> some View {
        if viewModel.tapGestureEnabled {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.toggleLock() // ロック状態の切り替え
                }
        }

        if viewModel.isLocked {
            TimeOverlayView(currentTime: viewModel.currentTime)
            ControlIconsView()
        }

        if shouldShowHeaderView() {
            VStack {
                TopButtonsView(isFullScreen: $isFullScreen, scalingFactor: scalingFactor)
                Spacer()
                BottomButtonsView(
                    isLocked: $viewModel.isLocked,
                    hideButtonsForScreenshot: $viewModel.hideButtonsForScreenshot,
                    captureScreenshot: {
                        viewModel.captureScreenshot()
                    },
                    tapGestureEnabled: $viewModel.tapGestureEnabled,
                    areControlButtonsHidden: $viewModel.areControlButtonsHidden,
                    selectedColor: $viewModel.selectedColor,
                    viewModel: viewModel,
                    scalingFactor: scalingFactor
                )
            }
        }
    }

    private func shouldShowHeaderView() -> Bool {
        !viewModel.isLocked && !viewModel.hideButtonsForScreenshot && !viewModel.areControlButtonsHidden
    }
}


struct FullScreenBlueView_Previews: PreviewProvider {
    @State static var selectedIndex = 0
    @State static var isFullScreen: ImageItem? = nil

    static var previews: some View {
        let sampleWordData = WordData(
            word: "Example",
            translation: "例",
            pronunciation: "ɪɡˈzæmpəl",
            sentences: [
                Sentence(english: "This is an example sentence.", japanese: "これは例文です。"),
                Sentence(english: "Another example sentence.", japanese: "もう一つの例文です。")
            ]
        )

        let wordsData = Array(repeating: sampleWordData, count: 5) // 同じデータを5回繰り返し

        return FullScreenBlueView(
            wordsData: wordsData,
            selectedIndex: $selectedIndex,
            isFullScreen: $isFullScreen
        )
        .previewDevice("iPhone 12") // iPhone 12でのプレビュー
        .previewDisplayName("Full Screen Blue View with 5 WordData")
    }
}
