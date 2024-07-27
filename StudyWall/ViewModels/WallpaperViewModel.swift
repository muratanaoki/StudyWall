import Foundation

class WallpaperViewModel: ObservableObject {
    @Published var wallpapers: [Wallpaper] = [
        Wallpaper(imageName: "wallpaper1", title: "Vocabulary 1", category: "Vocabulary"),
        Wallpaper(imageName: "wallpaper2", title: "Vocabulary 2", category: "Vocabulary"),
        Wallpaper(imageName: "wallpaper3", title: "Phrases 1", category: "Phrases"),
        Wallpaper(imageName: "wallpaper4", title: "Phrases 2", category: "Phrases")
    ]
}
