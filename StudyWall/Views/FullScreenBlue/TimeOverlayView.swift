import SwiftUI

struct TimeOverlayView: View {
    let currentTime: Date
    let scalingFactor: CGFloat

    var body: some View {
        VStack(spacing: -13 * scalingFactor) {
            dateText
            timeText
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 10 * scalingFactor)
    }

    // 日付を表示するTextビュー
    private var dateText: some View {
        Text(formattedDateString)
            .font(.system(size: 22 * scalingFactor))
            .foregroundColor(.white)
    }

    // 時間を表示するTextビュー
    private var timeText: some View {
        Text(formattedTimeString)
            .font(.system(size: 108 * scalingFactor, weight: .bold, design: .rounded))
            .tracking(-3 * scalingFactor)
            .foregroundColor(.white)
    }

    // currentTimeをフォーマットして返すプロパティ（日時）
    private var formattedDateString: String {
        DateFormatter.dateFormatter.string(from: currentTime)
    }

    // currentTimeをフォーマットして返すプロパティ（時間）
    private var formattedTimeString: String {
        DateFormatter.hhmmFormatter.string(from: currentTime)
    }
}

struct TimeOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        TimeOverlayView(currentTime: Date(), scalingFactor: 1.0)
            .background(Color(.black))
    }
}
