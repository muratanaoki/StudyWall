import SwiftUI

struct LandmarkDetail: View {
    @Environment(ModelData.self) var modelData
    var landmark: Landmark
    @State private var selectedImageItem: ImageItem? = nil
    @State private var selectedIndex = 0
    @State private var showAlert = false
    @Namespace private var namespace

    var landmarkIndex: Int {
        modelData.landmarks.firstIndex(where: { $0.id == landmark.id })!
    }

    // JSONから読み込んだ単語データ
    let wordsData = loadWordsData(from: "english")

    var body: some View {
        NavigationView {
            ScrollView {
                CircleImage(image: landmark.image)

                VStack(alignment: .leading) {
                    HStack {
                        Text(landmark.park)
                        Spacer()
                        Text(landmark.state)
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                    Divider()

                    Text("About \(landmark.name)")
                        .font(.title2)

                    // 2列のグリッドで青い四角形を表示
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(0..<4, id: \.self) { index in
                            BlueRectangleThumbnail(index: index, selectedIndex: $selectedIndex, isFullScreen: $selectedImageItem)
                        }
                    }

                    Divider()

                    // WordDataの表示セクション
                    Text("Word Data")
                        .font(.title2)
                        .padding(.top)
                }
                .padding()
            }
            .navigationTitle(landmark.name)
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(item: $selectedImageItem) { _ in
                FullScreenBlueView(wordsData: wordsData, selectedIndex: $selectedIndex, isFullScreen: $selectedImageItem, showAlert: $showAlert)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("スクリーンショット"), message: Text("スクリーンショットが保存されました"), dismissButton: .default(Text("OK")))
        }
    }
}

// 青い四角形のサムネイルビュー
struct BlueRectangleThumbnail: View {
    var index: Int
    @Binding var selectedIndex: Int
    @Binding var isFullScreen: ImageItem?

    var body: some View {
        Color.blue
            .frame(height: 100)
            .cornerRadius(10)
            .shadow(radius: 5)
            .onTapGesture {
                withAnimation(.spring()) {
                    selectedIndex = index
                    isFullScreen = ImageItem(id: UUID(), imageName: "")
                }
            }
    }
}

struct FullScreenBlueView: View {
    let wordsData: [WordData]
    @Binding var selectedIndex: Int
    @Binding var isFullScreen: ImageItem?
    @Binding var showAlert: Bool
    @State private var currentTime: Date = Date()
    @State private var isLocked: Bool = true
    @State private var showButtons: Bool = true

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.blue
                .ignoresSafeArea()

            VStack(spacing: 5) {
                TabView {
                    ForEach(0..<5, id: \.self) { _ in
                        VStack {
                            ForEach(0..<min(5, wordsData.count), id: \.self) { index in
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(wordsData[index].word)
                                            .font(.subheadline)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(wordsData[index].pronunciation)
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(wordsData[index].translation)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.bottom, 3)

                                    Divider()
                                        .background(Color.gray)

                                    ForEach(wordsData[index].sentences) { sentence in
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(sentence.english)
                                                .font(.caption)
                                            Text(sentence.japanese)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .padding(8)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding(.horizontal, 8)
                            }
                        }
                        .padding(.top, 20)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .frame(maxHeight: .infinity)

            // 時計と日付のオーバーレイ
            if !isLocked {
                VStack {
                    Text("\(currentTime, formatter: DateFormatter.dateFormatter)")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    Text("\(currentTime, formatter: DateFormatter.hhmmFormatter)")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, -10)
                        .padding(.bottom, 50)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 10)
            }

            // 下部にライトとカメラのアイコンを円形で配置
            if !isLocked {
                HStack {
                    Button(action: {
                        // ライトのアクション
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 60, height: 60)
                            Image(systemName: "flashlight.on.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        }
                    }
                    Spacer()
                    Button(action: {
                        // カメラのアクション
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 60, height: 60)
                            Image(systemName: "camera.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 60)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }

            // ロック、ダウンロード、閉じるボタンをHStackで配置
            if showButtons {
                HStack {
                    // ロックのアイコンボタン
                    Button(action: {
                        isLocked.toggle()
                    }) {
                        Image(systemName: isLocked ? "lock.iphone" : "iphone")
                            .font(.title)
                            .padding()
                    }
                    .foregroundColor(.white)

                    Spacer()

                    // ダウンロードボタン
                    Button(action: {
                        showButtons = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            captureScreenshot()
                            showButtons = true
                        }
                    }) {
                        Image(systemName: "square.and.arrow.down")
                            .font(.title)
                            .padding()
                    }
                    .foregroundColor(.white)

                    Spacer()

                    // 閉じるボタン
                    Button(action: {
                        isFullScreen = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .padding()
                    }
                    .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
                .padding(.top, 0)
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                currentTime = Date()
            }
        }
    }

    // 画面のキャプチャを行い、保存する関数
    func captureScreenshot() {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        let screenBounds = window?.bounds ?? .zero
        UIGraphicsBeginImageContextWithOptions(screenBounds.size, false, 0)
        window?.drawHierarchy(in: screenBounds, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let screenshot = screenshot {
            UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
        }
    }
}

// DateFormatterを拡張してカスタムフォーマッタを追加
extension DateFormatter {
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        formatter.timeZone = .current
        return formatter
    }

    static var hhmmFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        formatter.timeZone = .current
        return formatter
    }
}

struct ImageItem: Identifiable {
    let id: UUID
    let imageName: String
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkDetail(landmark: ModelData().landmarks[0])
            .environment(ModelData())
    }
}
