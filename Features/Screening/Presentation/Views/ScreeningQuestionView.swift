import SwiftUI

struct ScreeningQuestionView: View {
	@ObservedObject var viewModel: AssessmentViewModel

	@State private var currentQuestion: UUID?

	// Stops user interaction if selection is in progress, avoids double selection
	@State private var selectionInProgress: Bool = false
	var body: some View {
		VStack {
			ProgressBar(value: viewModel.progress, color: viewModel.color)
			.padding()

				TabView(selection: $currentQuestion) {
					ForEach(viewModel.questions)  { question in
						QuestionView(question: question, tint: assessmentTheme) { selectedAnser in
							Task {
								await viewModel.answerQuestion(value: selectedAnser)
							}
						}
						.tag(question.id)
						.gesture(DragGesture())
					}
				}
				.tabViewStyle(.page(indexDisplayMode: .never))
				.animation(.easeInOut, value: currentQuestion)
				.disabled(selectionInProgress)

		}
		.background(Color(UIColor.systemBackground))
		.onChange(of: viewModel.currentStep) { oldValue, newValue in
			if viewModel.currentStep < viewModel.questions.count - 1 {
				Task {
					selectionInProgress = true
					try? await Task.sleep(nanoseconds: 500_000_000)
					currentQuestion = viewModel.questions[viewModel.currentStep].id
					selectionInProgress = false
				}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.toolbar {
			HeaderControlsToolbar(viewModel: viewModel)
		}
	}

	var assessmentTheme: Color {
		viewModel.color
	}
}

private struct HeaderControlsToolbar: ToolbarContent {
	@Environment(\.dismiss) var dismiss
	@ObservedObject var viewModel: AssessmentViewModel
	var body: some ToolbarContent {

		ToolbarItem(placement: .topBarLeading) {
			Button {
				dismiss()
				viewModel.reset()
			} label: {
				Image(systemName: "xmark")
					.font(.headline)
					.padding(8)
					.background(Color(UIColor.systemGray6), in: Circle())
			}
		}

		ToolbarItem(placement: .principal) {
			Text(viewModel.title)
				.font(.headline)
				.frame(maxWidth: .infinity, alignment: .leading)
		}

		ToolbarItem(placement: .topBarTrailing) {
			Text("\(viewModel.currentStep + 1)/\(viewModel.questions.count)")
				.font(.caption)
				.fontWeight(.bold)
				.foregroundColor(.secondary)
				.padding(8)
				.background(Color(UIColor.secondarySystemBackground), in: Capsule())
		}
	}
}

struct QuestionView: View {
	let question: Question
	let tint: Color
	let didSelectAnswer: (Int) -> Void

	var body: some View {
		VStack(alignment: .leading, spacing: 24) {
			Spacer()
			VStack(alignment: .leading, spacing: 8) {
				Text(question.category.rawValue)
					.font(.caption)
					.fontWeight(.bold)
					.foregroundColor(tint)
					.textCase(.uppercase)
					.padding(.vertical, 4)
					.padding(.horizontal, 8)
					.background(categoryColor, in: Capsule())

				Text(question.text)
					.font(.title)
			}
			.padding()
			Spacer()
			VStack(spacing: 8) {
				Text("Choose One Answer")
					.font(.footnote)
					.foregroundStyle(.secondary)
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.leading, 8)
					.padding(.vertical, 4.0)
				List {
					ForEach(0..<question.answerOptions.count, id: \.self) { index in
						OptionButton(title: question.answerOptions[index], tint: tint) {
							Task {
								didSelectAnswer(index)
							}
						}
						.id(question.id)
						.listRowInsets(.init())
						.listRowBackground(Color(UIColor.tertiarySystemGroupedBackground))
					}
				}
				.listStyle(.plain)
				.frame(maxHeight: CGFloat(question.answerOptions.count) * 44.0 - (CGFloat(question.answerOptions.count)) * 2)
			}
		}
	}

	var categoryColor: Color {
		tint.opacity(0.1)
	}
}
#Preview {
	@Previewable @State var viewModel = AssessmentViewModel(assessment: availableAssessments[0])
	NavigationStack {
		ScreeningQuestionView(viewModel: viewModel)
	}
}
