import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack() {
            Text("単語")
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
            Text("|") .font(.headline)
                .foregroundColor(.white)
            Text("復習")
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .background(Color(red: 0.0, green: 0.0, blue: 0.5))
        .cornerRadius(10)
        .padding(.horizontal, 8)
    }
}
