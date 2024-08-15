import SwiftUI

struct FullScreenBlueView: View {
    let wordsData: [WordData]
    @Binding var selectedIndex: Int
    @Binding var isFullScreen: ImageItem?
    @StateObject private var viewModel = FullScreenBlueViewModel()

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.blue
                .ignoresSafeArea()

            VStack(spacing: 5) {
                TabView {
                    ForEach(0..<5, id: \.self) { _ in
                        VStack {
                            if shouldShowHeaderView() {
                                HeaderView()
                            }
                            ForEach(0..<min(5, wordsData.count), id: \.self) { index in
                                WordItemView(wordData: wordsData[index], speechSynthesizer: viewModel.speechSynthesizer, areControlButtonsHidden: $viewModel.areControlButtonsHidden)
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

            overlayViews()
        }
        .onAppear {
            viewModel.startClock()
        }
    }

    @ViewBuilder
    private func overlayViews() -> some View {
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
            TopButtonsView(isFullScreen: $isFullScreen)
            VStack {
                Spacer()
                BottomButtonsView(
                    isLocked: $viewModel.isLocked,
                    hideButtonsForScreenshot: $viewModel.hideButtonsForScreenshot,
                    captureScreenshot: {
                        viewModel.captureScreenshot()
                    },
                    tapGestureEnabled: $viewModel.tapGestureEnabled,
                    areControlButtonsHidden: $viewModel.areControlButtonsHidden
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
        FullScreenBlueView(
            wordsData: [
                WordData(
                    word: "Example",
                    translation: "例",
                    pronunciation: "ɪɡˈzæmpəl",
                    sentences: [
                        Sentence(english: "This is an example sentence.", japanese: "これは例文です。"),
                        Sentence(english: "Another example sentence.", japanese: "もう一つの例文です。")
                    ]
                ),
                WordData(
                    word: "Test",
                    translation: "テスト",
                    pronunciation: "tɛst",
                    sentences: [
                        Sentence(english: "This is a test sentence.", japanese: "これはテスト文です。"),
                        Sentence(english: "Another test sentence.", japanese: "もう一つのテスト文です。")
                    ]
                )
            ],
            selectedIndex: $selectedIndex,
            isFullScreen: $isFullScreen
        )
        .previewLayout(.device)
    }
}
