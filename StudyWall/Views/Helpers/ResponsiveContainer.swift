import SwiftUI

struct ResponsiveContainer<Content: View>: View {
    let content: (CGFloat) -> Content

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let scalingFactor = ResponsiveSettings.calculateScalingFactor(deviceWidth: width, deviceHeight: height)
            content(scalingFactor)
        }
    }
}
