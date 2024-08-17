import SwiftUI

struct CheckboxStyle: ToggleStyle {
    let scalingFactor: CGFloat // 追加


    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 20 * scalingFactor, height: 20 * scalingFactor)
                .foregroundColor(configuration.isOn ? .blue : .gray)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
}
