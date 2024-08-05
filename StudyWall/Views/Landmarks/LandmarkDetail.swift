import SwiftUI

struct LandmarkDetail: View {
    @Environment(ModelData.self) var modelData
    var landmark: Landmark
    @State private var selectedImageItem: ImageItem? = nil
    @State private var selectedIndex = 0
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
                FullScreenBlueView(wordsData: wordsData, isFullScreen: $selectedImageItem)
            }
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

// 青い背景の全画面モーダルビューに白いボックスを5つ表示
struct FullScreenBlueView: View {
    let wordsData: [WordData]
    @Binding var isFullScreen: ImageItem?

    var body: some View {
        ZStack(alignment: .topTrailing) { // 右上に配置を指定
            Color.blue
                .ignoresSafeArea()

            VStack(spacing: 10) {
                ForEach(0..<min(5, wordsData.count), id: \.self) { index in
                    VStack(alignment: .leading, spacing: 6) {
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
                        .padding(.bottom, 5)

                        Divider()
                            .background(Color.gray)

                        ForEach(wordsData[index].sentences) { sentence in
                            VStack(alignment: .leading, spacing: 3) {
                                Text(sentence.english)
                                    .font(.caption)
                                Text(sentence.japanese)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal, 10)
                }
            }
            .padding(.top, 20)
            .frame(maxHeight: .infinity)

            Button(action: {
                isFullScreen = nil
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .padding()
            }
            .foregroundColor(.white)
            .padding(.top, 0
            )
            .padding(.trailing, 10)
        }
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
