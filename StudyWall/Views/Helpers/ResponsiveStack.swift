//import SwiftUI
//
//struct ResponsiveStack<Content: View>: View {
//    let content: Content
//
//    init(@ViewBuilder content: () -> Content) {
//        self.content = content()
//    }
//
//    var body: some View {
//        GeometryReader { geometry in
//            if ResponsiveSettings.isLandscape() {
//                HStack { content }
//            } else {
//                VStack { content }
//            }
//        }
//    }
//}
