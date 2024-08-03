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

            if let selectedImageID = selectedImageID {
                FullScreenImageView(image: Image("wallPaper"), id: selectedImageID, selectedImageID: $selectedImageID, namespace: namespace)
                    .zIndex(2) // FullScreenImageViewを最前面に配置
                    .ignoresSafeArea() // Safe Areaを無視してフルスクリーンにする
            }
        }
        .navigationTitle(landmark.name)
        .navigationBarTitleDisplayMode(.inline)
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

struct FullScreenImageView: View {
    var image: Image
    var id: UUID
    @Binding var selectedImageID: UUID?
    var namespace: Namespace.ID

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.opacity(0.5)
                .ignoresSafeArea() // 背景を半透明にする

            image
                .resizable()
                .scaledToFit()
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
    return NavigationView {
        LandmarkDetail(landmark: modelData.landmarks[0])
            .environment(modelData)
    }
}
