import SwiftUI

struct ScreeningAnalyzingView: View {
	@ObservedObject var viewModel: AssessmentViewModel

	@State var progress: Double = 0
	private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
		ZStack {
			Color.green.opacity(0.1)
				.ignoresSafeArea(edges: .all)

			VStack(spacing: 20) {

				Text("Great Job! We are building your custom report.")
					.font(.title)
					.frame(maxWidth: .infinity, alignment: .leading)

				Text("Sit tight whilst we compile your report customized to your needs.")
					.font(.subheadline)
					.fontWeight(.medium)

				ProgressBar(value: progress, color: Color.green, style: .inverseBar)
					.padding(.top, 50)
			}
			.padding(.horizontal)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background {
				RoundedRectangle(cornerRadius: 40, style: .circular)
					.fill(Color.white)
					.padding(.top, 200)

			}
			.ignoresSafeArea(edges: .bottom)

			Image("progress")
				.aspectRatio(contentMode: .fit)
				.alignmentGuide(VerticalAlignment.center) { dim in
					dim[VerticalAlignment.bottom] * 1.4
				}
		}
		.toolbar(.hidden, for: .tabBar)
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.onReceive(timer) { _ in
			progress += Double.random(in: 0.1...0.3)
			if progress >= 1 {
				timer.upstream.connect().cancel()
				Task {
					await viewModel.completeAnalysis()
				}
			}
		}
    }
}

#Preview {
	@Previewable @State var viewModel = AssessmentViewModel(assessment: availableAssessments[0])
	ScreeningAnalyzingView(viewModel: viewModel)
}
