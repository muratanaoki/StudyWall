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

    let wordsData = loadWordsData(from: "english")

    var body: some View {
        NavigationView {
            ScrollView {
                CircleImage(image: landmark.image)
                VStack(alignment: .leading) {
                    landmarkInfo
                    Divider()
                    aboutLandmark

                }
                .padding()
            }
            .navigationTitle(landmark.name)
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(item: $selectedImageItem) { _ in
                FullScreenBlueView(wordsData: wordsData, selectedIndex: $selectedIndex, isFullScreen: $selectedImageItem)
            }
        }

    }

    private var landmarkInfo: some View {
        HStack {
            Text(landmark.park)
            Spacer()
            Text(landmark.state)
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }

    private var aboutLandmark: some View {
        VStack(alignment: .leading) {
            Text("About \(landmark.name)")
                .font(.title2)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(0..<4, id: \.self) { index in
                    BlueRectangleThumbnail(index: index, selectedIndex: $selectedIndex, isFullScreen: $selectedImageItem)
                }
            }
        }
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkDetail(landmark: ModelData().landmarks[0])
            .environment(ModelData())
    }
}
