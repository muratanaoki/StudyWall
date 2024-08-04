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
                    .scaledToFill()
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
