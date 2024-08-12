import SwiftUI

struct BottomButtonsView: View {
    @Binding var isLocked: Bool
    @Binding var hideButtonsForScreenshot: Bool
    var captureScreenshot: () -> Void
    @Binding var tapGestureEnabled: Bool
    @Binding var areControlButtonsHidden: Bool

    var body: some View {
        HStack {
            if !areControlButtonsHidden {
                Button(action: {
                    isLocked = true
                    areControlButtonsHidden = true
                    tapGestureEnabled = true
                }) {
                    Image(systemName: "lock.iphone")
                        .font(.title)
                        .padding()
                }
                .foregroundColor(.white)
            }
            Spacer()
            if !areControlButtonsHidden {
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
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 20)
    }
}
