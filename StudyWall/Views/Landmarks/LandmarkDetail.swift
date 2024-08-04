import SwiftUI

struct LandmarkDetail: View {
    @Environment(ModelData.self) var modelData
    var landmark: Landmark
    @State private var selectedImageItem: ImageItem? = nil
    @Namespace private var namespace

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

                    VStack {
                        HStack {
                            ImageThumbnail(image: Image("wallPaper"), selectedImageItem: $selectedImageItem, namespace: namespace)
                            ImageThumbnail(image: Image("wallPaper"), selectedImageItem: $selectedImageItem, namespace: namespace)
                        }
                        HStack {
                            ImageThumbnail(image: Image("wallPaper"), selectedImageItem: $selectedImageItem, namespace: namespace)
                            ImageThumbnail(image: Image("wallPaper"), selectedImageItem: $selectedImageItem, namespace: namespace)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(landmark.name)
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(item: $selectedImageItem) { imageItem in
                FullScreenImageDisplay(image: imageItem.image, selectedImageItem: $selectedImageItem, namespace: namespace)
            }
        }
    }
}

struct ImageThumbnail: View {
    var image: Image
    @Binding var selectedImageItem: ImageItem?
    var namespace: Namespace.ID

    var body: some View {
        image
            .resizable()
            .scaledToFit()
//            .frame(height: 100)
            .cornerRadius(10)
            .shadow(radius: 5)
//            .padding()
            .matchedGeometryEffect(id: UUID(), in: namespace)
            .onTapGesture {
                withAnimation(.spring()) {
                    selectedImageItem = ImageItem(id: UUID(), image: image)
                }
            }
    }
}

struct FullScreenImageDisplay: View {
    var image: Image
    @Binding var selectedImageItem: ImageItem?
    var namespace: Namespace.ID

    var body: some View {
        ZStack(alignment: .topTrailing) {
            image
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .matchedGeometryEffect(id: UUID(), in: namespace)
               

            Button(action: {
                withAnimation(.spring()) {
                    selectedImageItem = nil
                }
            }) {
                Image(systemName: "xmark")
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .padding()
            }
        }
    }
}

struct ImageItem: Identifiable {
    let id: UUID
    let image: Image
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkDetail(landmark: ModelData().landmarks[0])
            .environment(ModelData())
    }
}
