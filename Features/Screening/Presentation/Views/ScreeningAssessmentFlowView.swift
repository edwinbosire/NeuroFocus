import SwiftUI

struct AssessmentLandingPage: View {
	@ObservedObject var viewModel: AssessmentViewModel
	var animation: Namespace.ID

	var body: some View {
		switch viewModel.appState {
			case .assessment:
				ScreeningQuestionView(viewModel: viewModel)
					.transition(.move(edge: .bottom).combined(with: .opacity))
			case .analyzing:
				ScreeningAnalyzingView(viewModel: viewModel)
					.transition(.opacity.combined(with: .scale))
			case .result:
				ScreeningResultView(viewModel: viewModel)
					.transition(.opacity.combined(with: .scale))
		}
	}
}

struct AssessmentFlowProgressView: View {
	var body: some View {
		ZStack {
			Color.gray.opacity(0.15).edgesIgnoringSafeArea(.all)
			ProgressView {
				Text("Loading assessment...")
					.font(.headline)
			}
		}
	}
}

struct QuestionViewContainerView: View {
	var body: some View {
		Text("Hello, world!")
	}
}

#Preview {
	@Previewable @State var viewModel = AssessmentViewModel(assessment: availableAssessments[0])
	@Previewable @Namespace var animation
	NavigationStack {
		AssessmentLandingPage(viewModel: viewModel, animation: animation)
	}
}
