import SwiftUI

struct LandmarkDetail: View {
    @Environment(ModelData.self) var modelData
    var landmark: Landmark
    @State private var selectedImageID: UUID?
    @Namespace private var namespace

    var landmarkIndex: Int {
        modelData.landmarks.firstIndex(where: { $0.id == landmark.id })!
    }

    var body: some View {
        ZStack {
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
                                ImageThumbnail(image: Image("wallPaper"), id: UUID(), selectedImageID: $selectedImageID, namespace: namespace)
                                ImageThumbnail(image: Image("wallPaper"), id: UUID(), selectedImageID: $selectedImageID, namespace: namespace)
                            }
                            HStack {
                                ImageThumbnail(image: Image("wallPaper"), id: UUID(), selectedImageID: $selectedImageID, namespace: namespace)
                                ImageThumbnail(image: Image("wallPaper"), id: UUID(), selectedImageID: $selectedImageID, namespace: namespace)
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle(landmark.name)
                .navigationBarTitleDisplayMode(.inline)
            }
            .zIndex(1) // NavigationViewを下に配置

            if let selectedImageID = selectedImageID {
                FullScreenImageDisplay(image: Image("wallPaper"), id: selectedImageID, selectedImageID: $selectedImageID, namespace: namespace)
                    .zIndex(2) // フルスクリーンビューを上に配置
                    .ignoresSafeArea()
            }
        }
    }
}

struct ImageThumbnail: View {
    var image: Image
    var id: UUID
    @Binding var selectedImageID: UUID?
    var namespace: Namespace.ID

    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .onTapGesture {
                withAnimation(.spring()) {
                    selectedImageID = id
                }
            }
            .matchedGeometryEffect(id: id, in: namespace)
    }
}

struct FullScreenImageDisplay: View {
    var image: Image
    var id: UUID
    @Binding var selectedImageID: UUID?
    var namespace: Namespace.ID

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    withAnimation(.spring()) {
                        selectedImageID = nil
                    }
                }
                .matchedGeometryEffect(id: id, in: namespace)

            Button(action: {
                withAnimation(.spring()) {
                    selectedImageID = nil
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

#Preview {
    let modelData = ModelData()
    return LandmarkDetail(landmark: modelData.landmarks[0])
        .environment(modelData)
}
