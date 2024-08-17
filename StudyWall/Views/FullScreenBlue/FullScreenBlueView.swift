import SwiftUI

struct FullScreenBlueView: View {
    let wordsData: [WordData]
    @Binding var selectedIndex: Int
    @Binding var isFullScreen: ImageItem?
    @StateObject private var viewModel = FullScreenBlueViewModel()

    var body: some View {
        ResponsiveContainer { scalingFactor in
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

                                if viewModel.isEyeOpen {
                                    ForEach(0..<min(5, wordsData.count), id: \.self) { index in
                                        WordItemView(
                                            wordData: wordsData[index],
                                            speechSynthesizer: viewModel.speechSynthesizer,
                                            areControlButtonsHidden: $viewModel.areControlButtonsHidden,
                                            scalingFactor: scalingFactor
                                        )
                                    }
                                } else {
                                    ForEach(0..<min(5, wordsData.count), id: \.self) { index in
                                        HideWordItemView(
                                            wordData: wordsData[index],
                                            speechSynthesizer: viewModel.speechSynthesizer,
                                            areControlButtonsHidden: $viewModel.areControlButtonsHidden,
                                            scalingFactor: scalingFactor
                                        )
                                    }
                                }
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

                overlayViews(scalingFactor:scalingFactor)
            }
            .onAppear {
                viewModel.startClock()
            }
        }
    }

    @ViewBuilder
    private func overlayViews(scalingFactor:CGFloat) -> some View {

        if viewModel.tapGestureEnabled {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.unlock()
                }
        }

        if viewModel.isLocked {
            TimeOverlayView(currentTime: viewModel.currentTime)
            ControlIconsView()
        }

        if shouldShowControlButtons() {
            TopButtonsView(isFullScreen: $isFullScreen, scalingFactor: scalingFactor)
            VStack {
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
                    viewModel: viewModel, scalingFactor: scalingFactor
                )
            }
        }
    }

    private func shouldShowHeaderView() -> Bool {
        return !viewModel.isLocked && !viewModel.hideButtonsForScreenshot && !viewModel.areControlButtonsHidden
    }

    private func shouldShowControlButtons() -> Bool {
        return shouldShowHeaderView()
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
