/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view showing featured landmarks above a list of landmarks grouped by category.
*/

import SwiftUI

// CategoryHome構造体は、特集されたランドマークとカテゴリごとに分けられたランドマークのリストを表示するビューを定義します。
struct Home: View {
    // @Environmentプロパティラッパーを使用して、環境からModelDataオブジェクトを取得します。
    // これにより、アプリ全体で共有されているデータを使用できます。
    @Environment(ModelData.self) var modelData

    // @Stateプロパティラッパーは、ビューのローカルな状態を管理します。
    // showingProfileは、プロフィール画面が表示されているかどうかを示すブール値です。
    @State private var showingProfile = false

    var body: some View {
        // NavigationSplitViewは、ナビゲーションと詳細ビューを分割して表示するためのコンテナです。
        NavigationSplitView {
            // Listは、複数の要素を縦に並べるためのビューです。
            List {
                // 最初の項目として、特集されたランドマークの画像を表示します。
                modelData.features[0].image
                    .resizable()          // 画像のサイズを変更できるようにします。
                    .scaledToFill()       // 画像をフレームいっぱいに表示し、余分な部分を切り取ります。
                    .frame(height: 200)   // 画像の高さを200ポイントに設定します。
                    .clipped()            // 画像がフレームを超えた部分を切り取ります。
                    .listRowInsets(EdgeInsets()) // リスト行のインセットを取り除きます。

                // カテゴリごとにランドマークを表示する行を作成します。
                // modelData.categoriesのキーをソートし、それぞれのカテゴリについて行を生成します。
                ForEach(modelData.categories.keys.sorted(), id: \.self) { key in
                    // CategoryRowは、カテゴリ名とそのカテゴリに属するランドマークのリストを表示するカスタムビューです。
                    CategoryRow(categoryName: key, items: modelData.categories[key]!)
                }
                .listRowInsets(EdgeInsets()) // リスト行のインセットを取り除きます。
            }
            .listStyle(.inset)  // リストのスタイルをインセットスタイルに設定します。
            .navigationTitle("test") // ナビゲーションバーのタイトルを「Featured」に設定します。

            // ナビゲーションバーの右側にプロフィール表示ボタンを追加します。
            .toolbar {
                Button {
                    showingProfile.toggle() // showingProfileの値を反転させてプロフィール画面の表示/非表示を切り替えます。
                } label: {
                    Label("User Profile", systemImage: "person.crop.circle") // ボタンにラベルとアイコンを設定します。
                }
            }
            // showingProfileがtrueのときにプロフィール画面をモーダル表示します。
            .sheet(isPresented: $showingProfile) {
                ProfileHost() // プロフィール画面のコンテンツを表示します。
                    .environment(modelData) // プロフィール画面にもModelDataを渡します。
            }
        } detail: {
            // 詳細ビューが選択されていない場合に表示するテキスト。
            Text("Select a Landmark")
        }
    }
}

// SwiftUIのプレビューでCategoryHomeビューを表示するための設定です。
// Xcodeのプレビュー機能を使用して、リアルタイムでビューの見た目を確認できます。
#Preview {
    Home()
        .environment(ModelData()) // プレビュー用にModelDataのインスタンスを提供します。
}
