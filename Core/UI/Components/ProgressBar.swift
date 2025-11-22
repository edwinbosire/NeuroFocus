import SwiftUI

struct ProgressBar: View {
    var value: CGFloat
    var color: Color = .blue

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height: 6).opacity(0.3).foregroundColor(Color(UIColor.systemGray4))
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: 6).foregroundColor(color)
            }
            .cornerRadius(45.0)
        }
    }
}
