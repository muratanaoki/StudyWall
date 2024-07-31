/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Storage for model data.
*/

import Foundation

// ModelDataクラスは、アプリケーション全体で共有されるデータを管理します。
// @Observable属性は、SwiftUIなどでデータの変更を監視できるようにします。
@Observable
class ModelData {
    // landmarksはLandmark型の配列で、landmarkData.jsonから読み込まれます。
    var landmarks: [Landmark] = load("landmarkData.json")

    // hikesはHike型の配列で、hikeData.jsonから読み込まれます。
    var hikes: [Hike] = load("hikeData.json")

    // profileはユーザーのプロファイルデータを保持します。デフォルト値が設定されています。
    var profile = Profile.default

    // featuresは、特集されているランドマークだけを含む配列です。
    var features: [Landmark] {
        landmarks.filter { $0.isFeatured }
    }

    // categoriesは、ランドマークをそのカテゴリごとにグループ化したディクショナリです。
    var categories: [String: [Landmark]] {
        Dictionary(
            grouping: landmarks,
            by: { $0.category.rawValue }
        )
    }
}

// load関数は、指定されたファイル名のJSONデータを読み込み、デコードして返します。
// ジェネリック型を使って、任意のDecodable型のデータを読み込むことができます。
func load<T: Decodable>(_ filename: String) -> T {
    // データを読み込むための変数
    let data: Data

    // バンドル内にある指定されたファイルのURLを取得します。
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            // ファイルが見つからなかった場合、プログラムをクラッシュさせます。
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        // ファイルからデータを読み込みます。
        data = try Data(contentsOf: file)
    } catch {
        // データの読み込みに失敗した場合、プログラムをクラッシュさせます。
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        // JSONデコーダーを使ってデータをデコードします。
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        // デコードに失敗した場合、プログラムをクラッシュさせます。
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
