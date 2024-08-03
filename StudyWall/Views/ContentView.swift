import SwiftUI

struct ContentView: View {

    @State private var selection: Tab = .featured

    enum Tab {
        case featured // 特集タブ
        case list     // リストタブ
    }

    var body: some View {

            Home()
                .tabItem {
                    Label("Featured", systemImage: "star") // タブに表示されるラベルとアイコン
                }
                .tag(Tab.featured) // タブの選択状態を管理するためのタグ
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}
