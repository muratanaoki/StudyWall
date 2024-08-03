import SwiftUI

struct ContentView: View {

    @State private var selection: Tab = .featured

    enum Tab {
        case featured // 特集タブ
        case list     // リストタブ
    }

    var body: some View {
        // TabViewはタブバーを作成し、異なるビューを切り替えるために使用します。
        TabView(selection: $selection) {
            // CategoryHomeビューは、特集ランドマークを表示するためのビューです。
            Home()
                .tabItem {
                    Label("Featured", systemImage: "star") // タブに表示されるラベルとアイコン
                }
                .tag(Tab.featured) // タブの選択状態を管理するためのタグ

            // LandmarkListビューは、すべてのランドマークをリスト表示するビューです。
            Favorite()
                .tabItem {
                    Label("List", systemImage: "list.bullet") // タブに表示されるラベルとアイコン
                }
                .tag(Tab.list) // タブの選択状態を管理するためのタグ
        }
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}
