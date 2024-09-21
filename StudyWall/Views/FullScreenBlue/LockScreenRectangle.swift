import SwiftUI

struct LockScreenRectangle: View {
    let color: Color
    let isSelected: Bool
    let onSelect: () -> Void
    @State private var currentTime: String = ""
    @State private var currentDate: String = ""

    var body: some View {
        Button(action: {
            onSelect()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(color.opacity(0.8)) // 色の透明度を調整
                    .aspectRatio(3/4, contentMode: .fit) // 縦長に設定
                    .shadow(radius: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 4) // 選択状態に応じて境界線を変更
                    )
                    .blur(radius: 2) // ブラー効果を追加（オプション）

                VStack {
                    Spacer()
                    Text(currentTime)
                        .font(.system(size: 40, weight: .bold, design: .default))
                        .foregroundColor(.white)
                    Text(currentDate)
                        .font(.system(size: 20, weight: .medium, design: .default))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
            }
        }
        .buttonStyle(PlainButtonStyle()) // デフォルトのボタンスタイルを無効化
        .onAppear {
            updateTimeAndDate() // ビューが表示されたときに一度だけ時刻と日付を取得
        }
    }

    private func updateTimeAndDate() {
        let formatter = DateFormatter()

        // 時間のフォーマット
        formatter.dateFormat = "h:mm a"
        currentTime = formatter.string(from: Date())

        // 日付のフォーマット
        formatter.dateFormat = "EEEE, MMM d"
        currentDate = formatter.string(from: Date())
    }
}

struct LockScreenRectangle_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenRectangle(color: .blue, isSelected: true, onSelect: {})
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
