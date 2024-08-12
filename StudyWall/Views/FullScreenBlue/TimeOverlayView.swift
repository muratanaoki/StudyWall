import SwiftUI

struct TimeOverlayView: View {
    let currentTime: Date

    var body: some View {
        VStack {
            Text("\(currentTime, formatter: DateFormatter.dateFormatter)")
                .font(.system(size: 18))
                .foregroundColor(.white)
                .padding(.top, 10)
            Text("\(currentTime, formatter: DateFormatter.hhmmFormatter)")
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, -10)
                .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 10)
    }
}
