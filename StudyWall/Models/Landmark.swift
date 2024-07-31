/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A representation of a single landmark.
*/

import Foundation
import SwiftUI
import CoreLocation

// Landmark構造体は、単一のランドマークを表現します。
struct Landmark: Hashable, Codable, Identifiable {
    var id: Int                    // ランドマークの一意の識別子
    var name: String               // ランドマークの名前
    var park: String               // ランドマークが属する公園の名前
    var state: String              // ランドマークが位置する州
    var description: String        // ランドマークの説明
    var isFavorite: Bool           // ユーザーがこのランドマークをお気に入りとしてマークしているかどうか
    var isFeatured: Bool           // ランドマークが特集されているかどうか

    var category: Category         // ランドマークのカテゴリ
    enum Category: String, CaseIterable, Codable {
        case lakes = "Lakes"       // 湖
        case rivers = "Rivers"     // 川
        case mountains = "Mountains" // 山
    }

    // プライベートなプロパティで、画像のファイル名を保持
    private var imageName: String

    // コンピューテッドプロパティで、画像を返します。
    var image: Image {
        Image(imageName)
    }

    // プライベートなプロパティで、座標を保持
    private var coordinates: Coordinates

    // コンピューテッドプロパティで、CLLocationCoordinate2Dを返します。
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }

    // Coordinates構造体は、緯度と経度を保持します。
    struct Coordinates: Hashable, Codable {
        var latitude: Double        // 緯度
        var longitude: Double       // 経度
    }
}
