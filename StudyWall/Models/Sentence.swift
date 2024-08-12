import SwiftUI

// Sentence構造体を定義
struct Sentence: Identifiable, Codable {
    let id = UUID()
    let english: String
    let japanese: String
}
