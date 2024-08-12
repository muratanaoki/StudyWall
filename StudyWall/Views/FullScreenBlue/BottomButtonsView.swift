import SwiftUI

struct BottomButtonsView: View {
    @Binding var isLocked: Bool
    @Binding var hideButtonsForScreenshot: Bool
    var captureScreenshot: () -> Void
    @Binding var tapGestureEnabled: Bool
@Binding var areControlButtonsHidden: Bool  // 追加

    var body: some View {
        HStack {
            if !areControlButtonsHidden {  // コントロールボタンが非表示でない場合にのみ表示
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
            }
            Spacer()
            if !areControlButtonsHidden {  // コントロールボタンが非表示でない場合にのみ表示
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
        .padding(.bottom, 20) // Bottom padding for better spacing
    }
}
