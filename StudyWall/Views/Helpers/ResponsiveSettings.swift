import SwiftUI

/// `ResponsiveSettings` 構造体は、デバイスの画面サイズに応じてフォントサイズやパディングを動的に調整するための設定を提供します。
struct ResponsiveSettings {

    // 基準となるデバイスの幅と高さ（iPhone 12の寸法を使用）
    static let baseWidth: CGFloat = 390  // iPhone 12の幅
    static let baseHeight: CGFloat = 844 // iPhone 12の高さ

    /**
     デバイスの幅と高さに基づいて、スケーリングファクターを計算します。

     - Parameters:
       - deviceWidth: 対象デバイスの幅
       - deviceHeight: 対象デバイスの高さ
     - Returns: 幅と高さの比率に基づいた最小スケーリングファクター
     */
    static func calculateScalingFactor(deviceWidth: CGFloat, deviceHeight: CGFloat) -> CGFloat {
        let widthRatio = deviceWidth / baseWidth
        let heightRatio = deviceHeight / baseHeight
        return min(widthRatio, heightRatio)
    }

    /**
     基準フォントサイズとデバイスの寸法に基づいて調整されたフォントサイズを計算します。

     - Parameters:
       - baseSize: 基準となるフォントサイズ
       - deviceWidth: 対象デバイスの幅
       - deviceHeight: 対象デバイスの高さ
     - Returns: 調整されたフォントサイズ
     */
    static func adjustedFontSize(baseSize: CGFloat, deviceWidth: CGFloat, deviceHeight: CGFloat) -> CGFloat {
        let scalingFactor = calculateScalingFactor(deviceWidth: deviceWidth, deviceHeight: deviceHeight)
        return baseSize * scalingFactor
    }

    /**
     現在のデバイスの画面寸法に基づいて、基準フォントサイズを調整します。

     - Parameter baseSize: 基準となるフォントサイズ
     - Returns: 調整されたフォントサイズ
     */
    static func scaledFontSize(for baseSize: CGFloat) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return adjustedFontSize(baseSize: baseSize, deviceWidth: screenWidth, deviceHeight: screenHeight)
    }

    /**
     基準パディングとデバイスの寸法に基づいて調整されたパディングを計算します。

     - Parameters:
       - basePadding: 基準となるパディングの大きさ
       - deviceWidth: 対象デバイスの幅
       - deviceHeight: 対象デバイスの高さ
     - Returns: 調整されたパディングの大きさ
     */
    static func adjustedPadding(basePadding: CGFloat, deviceWidth: CGFloat, deviceHeight: CGFloat) -> CGFloat {
        let scalingFactor = calculateScalingFactor(deviceWidth: deviceWidth, deviceHeight: deviceHeight)
        return basePadding * scalingFactor
    }

    /**
     現在のデバイスの画面寸法に基づいて、基準パディングを調整します。

     - Parameter basePadding: 基準となるパディングの大きさ
     - Returns: 調整されたパディングの大きさ
     */
    static func scaledPadding(for basePadding: CGFloat) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return adjustedPadding(basePadding: basePadding, deviceWidth: screenWidth, deviceHeight: screenHeight)
    }
}
