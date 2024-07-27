import SwiftUI

struct ContentView: View {
    let wallpapers = [
        Wallpaper(imageName: "wallpaper1", title: "Vocabulary 1", category: "Vocabulary"),
        Wallpaper(imageName: "wallpaper2", title: "Vocabulary 2", category: "Vocabulary"),
        Wallpaper(imageName: "wallpaper3", title: "Phrases 1", category: "Phrases"),
        Wallpaper(imageName: "wallpaper4", title: "Phrases 2", category: "Phrases")
    ]
    
    var categories: [String: [Wallpaper]] {
        Dictionary(grouping: wallpapers, by: { $0.category })
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(categories.keys.sorted(), id: \.self) { key in
                    Section(header: Text(key)
                                .font(.headline)
                                .padding(.leading, 15)
                                .padding(.top, 10)) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(categories[key]!) { wallpaper in
                                    NavigationLink(destination: WallpaperDetailView(wallpaper: wallpaper)) {
                                        VStack {
                                            Image(wallpaper.imageName)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 150, height: 150)
                                                .clipped()
                                                .cornerRadius(10)
                                            Text(wallpaper.title)
                                                .font(.caption)
                                                .padding(.top, 5)
                                        }
                                        .padding(.leading, 15)
                                    }
                                }
                            }
                        }
                        .frame(height: 200)
                    }
                }
            }
            .navigationTitle("Study Wall")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
