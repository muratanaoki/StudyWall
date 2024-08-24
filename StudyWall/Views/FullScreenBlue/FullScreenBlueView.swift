import SwiftUI

/// `FullScreenBlueView` はフルスクリーンで単語データを表示するためのビューです。
struct FullScreenBlueView: View {
    let wordsData: [WordData]  // 表示する単語データのリスト
    @Binding var selectedIndex: Int  // 選択されている単語のインデックス
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
    @Binding var selectedIndex: Int  // 選択されている単語のインデックス
    @Binding var isFullScreen: ImageItem?  // フルスクリーン表示かどうかを管理するバインディング
    @ObservedObject var viewModel: FullScreenBlueViewModel  // ビューの状態管理を行うViewModel
    let scalingFactor: CGFloat  // デバイスのスケーリングファクター

    var body: some View {
        ZStack(alignment: .topTrailing) {
            viewModel.selectedColor
                .ignoresSafeArea()  // 背景色を全画面に適用する

                        Image("lock")
                            .resizable()          // 画像をリサイズ可能にする
                            .frame(maxWidth: .infinity, maxHeight: .infinity)  // 画面全体に広げる
                            .clipped()            // 画面サイズを超える部分を切り取る
                            .ignoresSafeArea()    // Safe areaを無視して表示する

            VStack(spacing: 5) {
                // 単語のスワイプビューを作成
                TabView {
                    ForEach(0..<5, id: \.self) { _ in
                        VStack {
                            if shouldShowHeaderView() {
                                HeaderView(scalingFactor: scalingFactor)  // ヘッダービューを表示
                            }
                            // 単語項目を表示
                            displayWordItems(isEyeOpen: viewModel.isEyeOpen, scalingFactor: scalingFactor)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))  // ページインジケータを非表示にする
            }
            .frame(maxHeight: .infinity)  // 最大高さを設定
            .alert(isPresented: $viewModel.alertData.isPresented) {
                // アラートの表示
                Alert(
                    title: Text(viewModel.alertData.title),
                    message: Text(viewModel.alertData.message),
                    dismissButton: .default(Text("OK"))
                )
            }

            // オーバーレイビューを表示
            overlayViews(scalingFactor: scalingFactor)
        }
        .onAppear {
            viewModel.startClock()  // ビューが表示されたときにクロックを開始
        }
    }

    /// 単語項目を表示するためのビルダー関数
    @ViewBuilder
    private func displayWordItems(isEyeOpen: Bool, scalingFactor: CGFloat) -> some View {
        // 単語データをリストとして表示
        ForEach(0..<min(5, wordsData.count), id: \.self) { index in
            if isEyeOpen {
                // アイコンが開いている場合のビュー
                WordItemView(
                    wordData: wordsData[index],
                    speechSynthesizer: viewModel.speechSynthesizer,
                    areControlButtonsHidden: $viewModel.areControlButtonsHidden,
                    scalingFactor: scalingFactor
                )
            } else {
                // アイコンが閉じている場合のビュー
                HideWordItemView(
                    wordData: wordsData[index],
                    speechSynthesizer: viewModel.speechSynthesizer,
                    areControlButtonsHidden: $viewModel.areControlButtonsHidden,
                    scalingFactor: scalingFactor
                )
            }
        }
    }

    /// オーバーレイビューを表示するためのビルダー関数
    @ViewBuilder
    private func overlayViews(scalingFactor: CGFloat) -> some View {
        // タップジェスチャーが有効な場合の透明オーバーレイ
        if viewModel.tapGestureEnabled {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.toggleLock() // ロック状態の切り替え
                }
        }

        // ロック状態の時に表示するビュー
        if viewModel.isLocked {
            TimeOverlayView(currentTime: viewModel.currentTime, scalingFactor: scalingFactor)
            ControlIconsView(scalingFactor: scalingFactor)
        }

        // ヘッダービューを表示する条件が満たされている場合
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

    /// ヘッダービューを表示するかどうかの条件をチェックする関数
    private func shouldShowHeaderView() -> Bool {
        !viewModel.isLocked && !viewModel.hideButtonsForScreenshot && !viewModel.areControlButtonsHidden
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
