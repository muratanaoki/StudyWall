import SwiftUI

// 壁紙詳細画面のビュー
struct WallpaperDetailView: View {
    var wallpaper: Wallpaper

    var body: some View {
        VStack {
            Image(systemName: wallpaper.imageName) // システム画像を使用
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .padding()
            Text(wallpaper.title)
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .navigationTitle(wallpaper.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
