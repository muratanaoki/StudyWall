import SwiftUI

struct LandmarkDetail: View {
    @Environment(ModelData.self) var modelData
    var landmark: Landmark
    @State private var selectedImageItem: ImageItem? = nil
    @State private var selectedIndex = 0
    @Namespace private var namespace

    // 表示する画像のリスト
    let images = ["wallPaper", "wallPaper", "wallPaper", "wallPaper"]

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

                    // 2列のグリッドで画像を表示
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(0..<images.count, id: \.self) { index in
                            ImageThumbnail(imageName: images[index], index: index, selectedIndex: $selectedIndex, isFullScreen: $selectedImageItem)
                        }
                    }

                    Divider()

                    // WordDataの表示セクション
                    Text("Word Data")
                        .font(.title2)
                        .padding(.top)

                    ForEach(wordsData) { word in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(word.word)
                                .font(.headline)
                            Text(word.translation)
                                .font(.subheadline)
                            Text(word.pronunciation)
                                .font(.caption)
                            ForEach(word.sentences) { sentence in
                                VStack(alignment: .leading) {
                                    Text(sentence.english)
                                    Text(sentence.japanese)
                                        .foregroundColor(.gray)
                                }
                                .padding(.top, 4)
                            }
                        }
                        .padding(.vertical)
                    }
                }
                .padding()
            }
            .navigationTitle(landmark.name)
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(item: $selectedImageItem) { imageItem in
                FullScreenSlideView(images: images, currentIndex: $selectedIndex, isFullScreen: $selectedImageItem)
            }
        }
    }
}

struct ImageThumbnail: View {
    var imageName: String
    var index: Int
    @Binding var selectedIndex: Int
    @Binding var isFullScreen: ImageItem?

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .cornerRadius(10)
            .shadow(radius: 5)
            .onTapGesture {
                withAnimation(.spring()) {
                    selectedIndex = index
                    isFullScreen = ImageItem(id: UUID(), imageName: imageName)
                }
            }
    }
}

struct FullScreenSlideView: View {
    let images: [String]
    @Binding var currentIndex: Int
    @Binding var isFullScreen: ImageItem?

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(0..<images.count, id: \.self) { index in
                Image(images[index])
                    .resizable()
                    .tag(index)
                    .ignoresSafeArea()
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .ignoresSafeArea()
        .overlay(
            Button(action: {
                isFullScreen = nil
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .padding()
            }
            .foregroundColor(.white)
            .padding(),
            alignment: .topTrailing
        )
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
