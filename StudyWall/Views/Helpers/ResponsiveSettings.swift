import SwiftUI

struct ResponsiveSettings {

    // 基準となるデバイスの幅と高さ（例: iPhone 12）
    static let baseWidth: CGFloat = 390 // iPhone 12の幅
    static let baseHeight: CGFloat = 844 // iPhone 12の高さ

    /// 縦横の比率に基づいてスケーリングファクターを計算する関数
    static func calculateScalingFactor(deviceWidth: CGFloat, deviceHeight: CGFloat) -> CGFloat {
        let widthRatio = deviceWidth / baseWidth
        let heightRatio = deviceHeight / baseHeight
        return min(widthRatio, heightRatio)
    }

    /// フォントサイズを縦横のスケーリングファクターに基づいて調整する関数
    static func adjustedFontSize(baseSize: CGFloat, deviceWidth: CGFloat, deviceHeight: CGFloat) -> CGFloat {
        let scalingFactor = calculateScalingFactor(deviceWidth: deviceWidth, deviceHeight: deviceHeight)
        return baseSize * scalingFactor
    }

    /// 現在のデバイスの寸法に基づいて、調整されたフォントサイズを返す関数
    static func scaledFontSize(for baseSize: CGFloat) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return adjustedFontSize(baseSize: baseSize, deviceWidth: screenWidth, deviceHeight: screenHeight)
    }

    /// スペーシングやパディングを縦横のスケーリングファクターに基づいて調整する関数
    static func adjustedPadding(basePadding: CGFloat, deviceWidth: CGFloat, deviceHeight: CGFloat) -> CGFloat {
        let scalingFactor = calculateScalingFactor(deviceWidth: deviceWidth, deviceHeight: deviceHeight)
        return basePadding * scalingFactor
    }

    /// 現在のデバイスの寸法に基づいて、調整されたパディングを返す関数
    static func scaledPadding(for basePadding: CGFloat) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return adjustedPadding(basePadding: basePadding, deviceWidth: screenWidth, deviceHeight: screenHeight)
    }
}
