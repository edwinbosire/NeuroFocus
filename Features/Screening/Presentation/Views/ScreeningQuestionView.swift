import SwiftUI

struct ScreeningQuestionView: View {
    @ObservedObject var viewModel: AssessmentViewModel

    let answerOptions = ["Never","Rarely","Sometimes","Often","Very Often"]

    var body: some View {
        VStack {
            HStack {
                Button(action: { viewModel.reset() }) {
                    Image(systemName: "xmark").foregroundColor(.primary).padding(10).background(Circle().fill(Color(UIColor.secondarySystemBackground)))
                }
                Spacer()

                if let questions = viewModel.currentAssessment?.questions {
                    Text("\(viewModel.currentStep + 1)/\(questions.count)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding(8)
                        .background(Capsule().fill(Color(UIColor.secondarySystemBackground)))
                }
            }
            .padding()

            ProgressBar(value: viewModel.progress, color: viewModel.currentAssessment?.color ?? .blue)
                .frame(height: 6)
                .padding(.horizontal)

            if let question = viewModel.currentAssessment?.questions[viewModel.currentStep] {
                VStack(alignment: .leading, spacing: 24) {
                    Spacer()
                    VStack(alignment: .leading, spacing: 8) {
                        Text(question.category.rawValue)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(viewModel.currentAssessment?.color ?? .blue)
                            .textCase(.uppercase)

                        Text(question.text)
                            .font(.title2)
                            .fontWeight(.bold)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(spacing: 12) {
                        ForEach(0..<answerOptions.count, id: \.self) { index in
                            OptionButton(title: answerOptions[index], isSelected: false) {
                                viewModel.answerQuestion(value: index)
                            }
                        }
                    }
                    Spacer()
                }
                .padding(24)
            }
        }
    }
}
