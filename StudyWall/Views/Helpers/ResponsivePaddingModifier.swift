//import SwiftUI
//
//struct ResponsivePaddingModifier: ViewModifier {
//    let basePadding: CGFloat
//
//    func body(content: Content) -> some View {
//        content
//            .padding(ResponsiveSettings.adjustedPadding(basePadding: basePadding, deviceWidth: UIScreen.main.bounds.width))
//    }
//}
//
//extension View {
//    func responsivePadding(basePadding: CGFloat) -> some View {
//        self.modifier(ResponsivePaddingModifier(basePadding: basePadding))
//    }
//}
