import SwiftUI

// アプリのエントリーポイントであるContentView。
// このビューでは、ナビゲーションを提供するためにNavigationViewを使用し、ImageGalleryを表示します。
struct Test: View {
    var body: some View {
        NavigationView {
            ImageGallery()
        }
    }
}

// 画像のギャラリーを表示するビュー。
// 画像のサムネイルをリストで表示し、選択された画像をフルスクリーンで表示します。
struct ImageGallery: View {
    // 表示する画像のリスト（画像名）
    let images = ["wallPaper", "wallPaper", "wallPaper", "wallPaper"]
    // 現在選択されている画像のID（UUID）
    @State private var selectedImage: UUID?
    // 画像間のアニメーションを可能にするためのNamespace
    @Namespace private var namespace

    var body: some View {
        ZStack {
            // スクロール可能なビューで、サムネイルを縦に並べて表示します。
            ScrollView {
                VStack {
                    // 画像のリストを表示するForEachループ
                    ForEach(images, id: \.self) { imageName in
                        // 各画像に対して一意のID（UUID）を生成
                        let imageID = UUID()
                        // サムネイル画像ビューを表示
                        ThumbnailImageView(image: Image(imageName), imageID: imageID, selectedImageID: $selectedImage, namespace: namespace)
                    }
                }
            }
            .navigationTitle("Image Gallery") // ナビゲーションバーにタイトルを設定

            // 画像が選択されている場合、フルスクリーンで画像を表示
            if let selectedImage = selectedImage {
                FullScreenImageContainer(image: Image(images.first!), id: selectedImage, selectedImageID: $selectedImage, namespace: namespace)
                    .zIndex(1) // フルスクリーンビューを最前面に配置
            }
        }
    }
}

// サムネイル画像を表示するビュー。
// 画像をタップすると、その画像が選択され、フルスクリーン表示に切り替わります。
struct ThumbnailImageView: View {
    var image: Image
    var imageID: UUID
    @Binding var selectedImageID: UUID?
    var namespace: Namespace.ID

    var body: some View {
        image
            .resizable() // 画像サイズの調整
            .scaledToFit() // 画像がビューに収まるようにスケール
//            .frame(height: 100) // サムネイルの高さを設定
            .cornerRadius(10) // サムネイルの角を丸める
            .shadow(radius: 5) // 影をつけて立体感を出す
            .padding() // サムネイル周囲に余白を追加
            .onTapGesture {
                // 画像をタップしたときのアクション
                withAnimation(.spring()) {
                    selectedImageID = imageID // 選択された画像IDを更新
                }
            }
            .matchedGeometryEffect(id: imageID, in: namespace) // アニメーションのための効果
    }
}

// フルスクリーンで画像を表示するためのコンテナビュー。
// このビューに入ると、ナビゲーションバーが非表示になります。
struct FullScreenImageContainer: View {
    var image: Image
    var id: UUID
    @Binding var selectedImageID: UUID?
    var namespace: Namespace.ID

    var body: some View {
        FullScreenImageView1(image: image, id: id, selectedImageID: $selectedImageID, namespace: namespace)
            .navigationBarHidden(true) // ナビゲーションバーを非表示に設定
    }
}

// フルスクリーンで画像を表示するビュー。
// 背景を暗くし、画像を拡大表示します。タップすると閉じます。
struct FullScreenImageView1: View {
    var image: Image
    var id: UUID
    @Binding var selectedImageID: UUID?
    var namespace: Namespace.ID

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // 背景を黒くして画像を際立たせる
            Color.black.opacity(0.5)
                .ignoresSafeArea() // セーフエリアを無視する

            // 画像をフルスクリーンで表示
            image
                .resizable()
//                .scaledToFit() // 画像のアスペクト比を保持
                .ignoresSafeArea() // セーフエリアを無視する
                .onTapGesture {
                    // 画像をタップして閉じるアクション
                    withAnimation(.spring()) {
                        selectedImageID = nil
                    }
                }
                .matchedGeometryEffect(id: id, in: namespace) // アニメーションのための効果

            // 閉じるボタン（右上に表示）
            Button(action: {
                withAnimation(.spring()) {
                    selectedImageID = nil // 選択状態を解除してフルスクリーン表示を閉じる
                }
            }) {
                Image(systemName: "xmark") // 閉じるアイコン
                    .padding()
                    .background(Color.black.opacity(0.6)) // ボタン背景
                    .foregroundColor(.white) // アイコンの色
                    .clipShape(Circle()) // ボタンの形を円形に
                    .padding()
            }
        }
    }
}

// プレビュー用のコード。Xcodeでのプレビュー表示に使用される。
#Preview {
    Test()
}
