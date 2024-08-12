import SwiftUI

// WordData構造体を定義
struct WordData: Identifiable, Codable {
    let id = UUID()
    let word: String
    let translation: String
    let pronunciation: String
    let sentences: [Sentence]
}
