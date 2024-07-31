/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A representation of a hike.
*/

import Foundation

// Hike構造体は、ハイキングに関する情報を表現します。
struct Hike: Codable, Hashable, Identifiable {
    var id: Int               // ハイキングの一意の識別子
    var name: String          // ハイキングコースの名前
    var distance: Double      // ハイキングの距離（キロメートル）
    var difficulty: Int       // ハイキングの難易度（整数値）
    var observations: [Observation] // ハイキング中の観察データのリスト

    // 距離をフォーマットするためのLengthFormatterの静的インスタンス
    static var formatter = LengthFormatter()

    // コンピューテッドプロパティで、距離をフォーマットされたテキストとして返します。
    var distanceText: String {
        Hike.formatter
            .string(fromValue: distance, unit: .kilometer)
    }

    // Observation構造体は、ハイキング中の観察データを表現します。
    struct Observation: Codable, Hashable {
        var distanceFromStart: Double   // ハイキング開始からの距離

        var elevation: Range<Double>    // 標高の範囲
        var pace: Range<Double>         // ペース（速度）の範囲
        var heartRate: Range<Double>    // 心拍数の範囲
    }
}
