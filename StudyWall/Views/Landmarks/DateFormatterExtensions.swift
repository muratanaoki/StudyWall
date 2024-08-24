import Foundation

extension DateFormatter {
    // 日本語ロケールで日付をフォーマットする（年を除く）
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP") // 日本語ロケールを設定
        formatter.dateFormat = "M月d日 EEEE" // 月日と曜日を日本語で表示
        return formatter
    }

    // 日本語ロケールで時間をフォーマットする
    static var hhmmFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm" // 24時間表記のフォーマット
        formatter.locale = Locale(identifier: "ja_JP") // 日本語ロケール
        return formatter
    }
}
