import SwiftUI

struct BottomButtonsView: View {
    @Binding var isLocked: Bool
    @Binding var hideButtonsForScreenshot: Bool
    var captureScreenshot: () -> Void
    @Binding var tapGestureEnabled: Bool

    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    isLocked = true
                    tapGestureEnabled = true
                }
            }) {
                Image(systemName: "lock.iphone")
                    .font(.title)
                    .padding()
            }
            .foregroundColor(.white)
            Spacer()
            Button(action: {
                hideButtonsForScreenshot = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    captureScreenshot()
                    hideButtonsForScreenshot = false
                }
            }) {
                Image(systemName: "square.and.arrow.down")
                    .font(.title)
                    .padding()
            }
            .foregroundColor(.white)
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 20) // Bottom padding for better spacing
    }
}
