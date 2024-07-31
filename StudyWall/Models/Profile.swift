/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A representation of user profile data.
*/

import Foundation

// Profile構造体は、ユーザーのプロファイルデータを定義します。
struct Profile {
    var username: String               // ユーザーの名前を保持します。
    var prefersNotifications = true    // 通知のオン/オフの設定。デフォルトはtrue。
    var seasonalPhoto = Season.winter  // ユーザーが好む季節の写真。デフォルトは冬。
    var goalDate = Date()              // ユーザーが設定した目標日。デフォルトは現在の日付。

    // Profile構造体のデフォルトのインスタンスを提供します。
    // ユーザー名は "g_kumar" に設定されています。
    static let `default` = Profile(username: "g_kumar")

    // Season列挙型は、ユーザーが好む季節を表現します。
    // Stringを基底型とし、すべてのケースを列挙可能にし、識別可能にします。
    enum Season: String, CaseIterable, Identifiable {
        case spring = "🌷"  // 春
        case summer = "🌞"  // 夏
        case autumn = "🍂"  // 秋
        case winter = "☃️"  // 冬

        // Identifiableプロトコルの要件を満たすために、idプロパティを定義します。
        // idは季節を表す絵文字（rawValue）になります。
        var id: String { rawValue }
    }
}
