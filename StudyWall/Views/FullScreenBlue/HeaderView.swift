import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack() {
            Text("単語")
                .font(.headline)
            Spacer()
            Text("|") .font(.headline)
            Text("復習")
                .font(.headline)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .background(.white)
        .cornerRadius(10)
        .padding(.horizontal, 8)
    }
}
