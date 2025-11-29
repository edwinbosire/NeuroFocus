import SwiftUI

struct ScreeningResultView: View {
	@Environment(\.dismiss) private var dismiss
	@ObservedObject var viewModel: AssessmentViewModel

	var body: some View {
		let result = viewModel.getResult()

		ScrollView {
			VStack(spacing: 30) {
				VStack(spacing: 10) {
					ZStack {
						Circle().fill(result.color.opacity(0.2)).frame(width: 100, height: 100)
						Image(systemName: "brain").font(.system(size: 40)).foregroundColor(result.color)
					}
					.padding(.top, 20)
					Text(result.category)
						.font(.title)
						.fontWeight(.heavy)
						.foregroundColor(result.color)
						.frame(maxWidth: .infinity, alignment: .center)
				}

				VStack(alignment: .leading, spacing: 12) {
					Text("Analysis")
						.font(.headline)
					Text(result.description)
						.font(.subheadline)
						.foregroundColor(.secondary)
						.frame(maxWidth: .infinity, alignment: .leading)
				}
				.padding()
				.background(Color(UIColor.tertiarySystemBackground))
				.cornerRadius(16)
				.padding(.horizontal)

				VStack(alignment: .leading, spacing: 20) {
					Text("Domain Breakdown").font(.title3).fontWeight(.bold)
					ForEach(result.insights) { insight in
						VStack(alignment: .leading, spacing: 8) {
							HStack {
								Text(insight.category.rawValue).font(.headline)
								Spacer()
								Text("\(insight.score)/\(insight.maxScore)").font(.caption).fontWeight(.bold).foregroundColor(.secondary)
							}
							ProgressBar(value: CGFloat(insight.score) / CGFloat(insight.maxScore), color: result.color).frame(height: 6)
							VStack(alignment: .leading, spacing: 4) {
								Text(insight.insightText).font(.subheadline).fontWeight(.medium)
								Text(insight.clinicianNote).font(.caption).italic().foregroundColor(.secondary).padding(.top, 2)
							}
							.padding(.top, 4)
						}
						.padding().background(Color(UIColor.systemBackground)).cornerRadius(12).shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
					}
				}
				.padding().background(Color(UIColor.tertiarySystemBackground).opacity(0.5)).cornerRadius(16)

				VStack {
					PrimaryButton(title: "Export Clinical Report (PDF)", color: .green, icon: "doc.text.fill") { viewModel.generatePDF() }

					Button(action: {
						dismiss()
						viewModel.reset()

					}) {
						HStack {
							Image(systemName: "gobackward")
							Text("Take Another Assessment").fontWeight(.bold)
						}
						.font(.subheadline)
						.frame(maxWidth: .infinity)
						.padding()
					}
				}
				.padding(.horizontal)
			}
		}
		.background(result.color.opacity(0.1).ignoresSafeArea())
		.sheet(isPresented: $viewModel.showShareSheet) {
			if let data = viewModel.reportData { ShareSheet(items: [data]) }
		}
		.toolbar(.hidden, for: .tabBar)
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button(action: { viewModel.generatePDF() }) { Image(systemName: "square.and.arrow.up") }
			}
		}
	}
}


#Preview {
	@Previewable @State var viewModel = AssessmentViewModel(assessment: availableAssessments[0])
	NavigationStack {
		ScreeningResultView(viewModel: PreviewData.results)
	}
}

@MainActor
struct PreviewData {
	static var results: AssessmentViewModel {
		let viewModel = AssessmentViewModel(assessment: availableAssessments[0])

		for question in viewModel.questions {
			let value = Int.random(in: 0..<question.answerOptions.count)
			viewModel.scores[viewModel.questions[viewModel.currentStep].id] = value
			viewModel.currentStep += 1
		}

		viewModel.appState = .result
		return viewModel
	}
}
