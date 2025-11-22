import SwiftUI

struct ScreeningAnalyzingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView().scaleEffect(1.5).progressViewStyle(CircularProgressViewStyle(tint: .blue))
            Text("Analyzing responses...").font(.headline).foregroundColor(.secondary)
        }
    }
}
