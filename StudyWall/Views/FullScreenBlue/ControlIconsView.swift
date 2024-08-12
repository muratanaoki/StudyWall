import SwiftUI

struct ControlIconsView: View {
    var body: some View {
        HStack {
            IconButton(imageName: "flashlight.on.fill")
            Spacer()
            IconButton(imageName: "camera.fill")
        }
        .padding(.bottom, 20)
        .padding(.horizontal, 60)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}
