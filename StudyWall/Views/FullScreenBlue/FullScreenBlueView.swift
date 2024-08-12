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
                            ForEach(0..<min(5, wordsData.count), id: \.self) { index in
                                WordItemView(wordData: wordsData[index], speechSynthesizer: viewModel.speechSynthesizer, isSpeakerButtonHidden: $viewModel.areControlButtonsHidden)
                            }
                        }
                        .padding(.top, 20)
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

            if viewModel.tapGestureEnabled {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.unlock()
                    }
            }

            if viewModel.isLocked { TimeOverlayView(currentTime: viewModel.currentTime) }
            if viewModel.isLocked { ControlIconsView() }

            if !viewModel.isLocked && !viewModel.hideButtonsForScreenshot && !viewModel.areControlButtonsHidden {
                TopButtonsView(isFullScreen: $isFullScreen)
            }

            if !viewModel.isLocked && !viewModel.hideButtonsForScreenshot && !viewModel.areControlButtonsHidden {
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
        .onAppear {
            viewModel.startClock()
        }
    }
}
