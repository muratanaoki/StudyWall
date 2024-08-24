import SwiftUI

struct ControlIconsView: View {
    let scalingFactor: CGFloat

    var body: some View {
        HStack {
            IconButton(imageName: "flashlight.on.fill", scalingFactor: scalingFactor)
            Spacer()
            IconButton(imageName: "camera.fill", scalingFactor: scalingFactor)
        }
        .padding(.bottom, 25 * scalingFactor)
        .padding(.horizontal, 55 * scalingFactor)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}
