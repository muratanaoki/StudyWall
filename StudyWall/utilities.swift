import SwiftUI

// WordData構造体を定義
struct WordData: Identifiable, Codable {
    let id = UUID()
    let word: String
    let translation: String
    let pronunciation: String
    let sentences: [Sentence]
}

// Sentence構造体を定義
struct Sentence: Identifiable, Codable {
    let id = UUID()
    let english: String
    let japanese: String
}

// JSONファイルからデータを読み込む関数
func loadWordsData(from fileName: String) -> [WordData] {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let decodedData = try? JSONDecoder().decode([WordData].self, from: data) else {
        return []
    }
    return decodedData
}
