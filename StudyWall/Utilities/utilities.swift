import SwiftUI

// JSONファイルからデータを読み込む関数
func loadWordsData(from fileName: String) -> [WordData] {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let decodedData = try? JSONDecoder().decode([WordData].self, from: data) else {
        return []
    }
    return decodedData
}
