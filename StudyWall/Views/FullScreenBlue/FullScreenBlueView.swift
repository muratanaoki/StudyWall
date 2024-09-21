import SwiftUI

/// `FullScreenBlueView` はフルスクリーンで単語データを表示するためのビューです。
struct FullScreenBlueView: View {
    let wordsData: [WordData]  // 表示する単語データのリスト
    @Binding var selectedIndex: Int  // 選択されている単語のインデックスを管理するバインディング
    @Binding var isFullScreen: ImageItem?  // フルスクリーン表示かどうかを管理するバインディング
    @StateObject private var viewModel = FullScreenBlueViewModel()  // ビューの状態管理を行うViewModel

    var body: some View {
        // 上位で一度だけResponsiveContainerを使用してスケーリングファクターを取得する
        ResponsiveContainer { scalingFactor in
            FullScreenContentView(
                wordsData: wordsData,
                selectedIndex: $selectedIndex,
                isFullScreen: $isFullScreen,
                viewModel: viewModel,
                scalingFactor: scalingFactor // スケーリングファクターを渡す
            )
        }
    }
}

/// `FullScreenContentView` はフルスクリーン表示の具体的なコンテンツを管理するビューです。
struct FullScreenContentView: View {
    let wordsData: [WordData]  // 表示する単語データのリスト
    @Binding var selectedIndex: Int  // 選択されている単語のインデックスを管理するバインディング
    @Binding var isFullScreen: ImageItem?  // フルスクリーン表示かどうかを管理するバインディング
    @ObservedObject var viewModel: FullScreenBlueViewModel  // ビューの状態管理を行うViewModel
    let scalingFactor: CGFloat  // デバイスのスケーリングファクター


    @State private var showSettingsSheet = false


    var body: some View {
        ZStack(alignment: .topTrailing) {
            viewModel.selectedColor
                .ignoresSafeArea()  // 背景色を全画面に適用する

            overlayContent(scalingFactor: scalingFactor)
        }
        .onAppear {
            viewModel.startClock()  // ビューが表示されたときにクロックを開始
        }
        // シートを表示するための修飾子を追加
            .sheet(isPresented: $showSettingsSheet) {
                SettingsView()
            }
    }

    /// オーバーレイコンテンツを条件に基づいて表示する関数
    @ViewBuilder
    private func overlayContent(scalingFactor: CGFloat) -> some View {

        if viewModel.isScreenShot {
            screenView(scalingFactor: scalingFactor)
        } else if viewModel.isLocked {
            lockedView(scalingFactor: scalingFactor)
        } else if viewModel.isEyeOpen {
            unlockedViewEyeOpen(scalingFactor: scalingFactor)
        } else {
            unlockedViewEyeClosed(scalingFactor: scalingFactor)
        }

        if viewModel.tapGestureEnabled {
            lockToggleOverlay()
        }
    }


    /// ロックされた状態のビューを表示する関数
    private func screenView(scalingFactor: CGFloat) -> some View {
        VStack(spacing: 10) {
            ForEach(0..<min(5, wordsData.count), id: \.self) { index in
                ScreenShotWordItemView(wordData: wordsData[index], scalingFactor: scalingFactor)
            }
        }
    }

    /// ロックされた状態のビューを表示する関数
    private func lockedView(scalingFactor: CGFloat) -> some View {
        VStack(spacing: 10) {
            TimeOverlayView(currentTime: viewModel.currentTime, scalingFactor: scalingFactor)
            ForEach(0..<min(5, wordsData.count), id: \.self) { index in
                ScreenShotWordItemView(wordData: wordsData[index], scalingFactor: scalingFactor)
            }
            ControlIconsView(scalingFactor: scalingFactor)
        }
    }

    /// ロック解除された状態で目が開いている状態のビューを表示する関数
    private func unlockedViewEyeOpen(scalingFactor: CGFloat) -> some View {
        VStack {
            TopButtonsView(isFullScreen: $isFullScreen, scalingFactor: scalingFactor)
            HeaderView(scalingFactor: scalingFactor)
            WordSwipeView(wordsData: wordsData, scalingFactor: scalingFactor, viewModel: viewModel)
                .frame(maxHeight: .infinity)
                .alert(isPresented: $viewModel.alertData.isPresented) {
                    Alert(
                        title: Text(viewModel.alertData.title),
                        message: Text(viewModel.alertData.message),
                        dismissButton: .default(Text("OK"))
                    )
                }
            BottomButtonsView(
                isLocked: $viewModel.isLocked,
                hideButtonsForScreenshot: $viewModel.hideButtonsForScreenshot,
                captureScreenshot: {
                    viewModel.captureScreenshot()
                },
                tapGestureEnabled: $viewModel.tapGestureEnabled,
                selectedColor: $viewModel.selectedColor,
                viewModel: viewModel,
                scalingFactor: scalingFactor,
                showSettingsSheet:$showSettingsSheet
            )
        }
    }

    /// ロック解除された状態で目が閉じている状態のビューを表示する関数
    private func unlockedViewEyeClosed(scalingFactor: CGFloat) -> some View {
        VStack() {
            TopButtonsView(isFullScreen: $isFullScreen, scalingFactor: scalingFactor)
            HeaderView(scalingFactor: scalingFactor)
            HideWordSwipeView(wordsData: wordsData, scalingFactor: scalingFactor, viewModel: viewModel)
                .frame(maxHeight: .infinity, alignment: .top)
                .alert(isPresented: $viewModel.alertData.isPresented) {
                    Alert(
                        title: Text(viewModel.alertData.title),
                        message: Text(viewModel.alertData.message),
                        dismissButton: .default(Text("OK"))
                    )
                }
            BottomButtonsView(
                isLocked: $viewModel.isLocked,
                hideButtonsForScreenshot: $viewModel.hideButtonsForScreenshot,
                captureScreenshot: {
                    viewModel.captureScreenshot()
                },
                tapGestureEnabled: $viewModel.tapGestureEnabled,
                selectedColor: $viewModel.selectedColor,
                viewModel: viewModel,
                scalingFactor: scalingFactor,
                showSettingsSheet:$showSettingsSheet
            )
        }
    }

    /// ロックのトグル用オーバーレイを表示する関数
    private func lockToggleOverlay() -> some View {
        Color.clear
            .contentShape(Rectangle())
            .onTapGesture { viewModel.toggleLock() }
    }
}

/// 単語をスワイプして表示するビュー
struct WordSwipeView: View {
    let wordsData: [WordData]
    let scalingFactor: CGFloat
    @ObservedObject var viewModel: FullScreenBlueViewModel

    var body: some View {
        TabView {
            ForEach(0..<5, id: \.self) { _ in
                VStack {
                    displayWordItems()
                    Spacer()
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }

    @ViewBuilder
    private func displayWordItems() -> some View {
        ForEach(0..<min(5, wordsData.count), id: \.self) { index in
            WordItemView(
                wordData: wordsData[index],
                speechSynthesizer: viewModel.speechSynthesizer,

                scalingFactor: scalingFactor
            )
        }
    }
}

/// 隠された単語をスワイプして表示するビュー
struct HideWordSwipeView: View {
    let wordsData: [WordData]
    let scalingFactor: CGFloat
    @ObservedObject var viewModel: FullScreenBlueViewModel

    var body: some View {
        TabView {
            ForEach(0..<5, id: \.self) { _ in
                VStack { displayWordItems()
                    Spacer()
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }

    @ViewBuilder
    private func displayWordItems() -> some View {
        ForEach(0..<min(5, wordsData.count), id: \.self) { index in
            HideWordItemView(
                wordData: wordsData[index],
                speechSynthesizer: viewModel.speechSynthesizer,
                scalingFactor: scalingFactor
            )
        }
    }
}

/// プレビュー用の構造体。iPhone 12デバイスでのプレビューを提供。
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

        let wordsData = Array(repeating: sampleWordData, count: 5)

        return FullScreenBlueView(
            wordsData: wordsData,
            selectedIndex: $selectedIndex,
            isFullScreen: $isFullScreen
        )
        .previewDevice("iPhone 12")
        .previewDisplayName("Full Screen Blue View with 5 WordData")
    }
}
