//import SwiftUI
//import Photos
//
//struct FullScreenImageView: View {
//    var image: Image
//    @Environment(\.dismiss) var dismiss
//
//    var body: some View {
//        ZStack {
//            image
//                .resizable()
////                .scaledToFit()
//                .ignoresSafeArea()
//
//            VStack {
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        Image(systemName: "xmark")
//                            .resizable()
//                            .frame(width: 24, height: 24)
//                            .padding()
//                            .background(Color.black.opacity(0.5))
//                            .foregroundColor(.white)
//                            .clipShape(Circle())
//                    }
//                    .padding()
//                }
//                Spacer()
//            }
//        }
//    }
//}
//
//#Preview {
//    FullScreenImageView(image: Image("wallPaper"))
//}
