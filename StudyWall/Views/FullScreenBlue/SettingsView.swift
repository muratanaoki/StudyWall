import SwiftUI

struct SettingsView: View {
    // グリッドの列を定義（2列）
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    // 長方形の色を定義
    let colors: [Color] = [.red, .green, .blue, .orange]

    // 選択されたインデックスを追跡するための状態
    @State private var selectedIndex: Int? = nil

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(0..<colors.count, id: \.self) { index in
                        LockScreenRectangle(
                            color: colors[index],
                            isSelected: selectedIndex == index,
                            onSelect: {
                                selectedIndex = index
                            }
                        )
                    }
                }
                .padding()
            }
            .navigationBarTitle("設定", displayMode: .inline)
            .navigationBarItems(trailing: Button("閉じる") {
                // シートを閉じる処理（実際のアプリではシートを閉じる処理を実装）
            })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .previewDevice("iPhone 12") // プレビューするデバイスを指定
    }
}
