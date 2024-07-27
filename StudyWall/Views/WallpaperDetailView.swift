import SwiftUI

struct WallpaperDetailView: View {
    var wallpaper: Wallpaper
    
    var body: some View {
        VStack {
            Image(wallpaper.imageName)
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

struct WallpaperDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WallpaperDetailView(wallpaper: Wallpaper(imageName: "wallpaper1", title: "Sample", category: "Sample"))
    }
}
