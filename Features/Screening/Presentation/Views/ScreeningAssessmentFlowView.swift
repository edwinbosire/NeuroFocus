import SwiftUI

struct ScreeningAssessmentFlowView: View {
    @StateObject private var viewModel = AssessmentViewModel()

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)

            switch viewModel.appState {
            case .selection:
                // For now render a simple list using original availableAssessments from ContentView.swift
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Assessments").font(.largeTitle).fontWeight(.bold)
                        Text("Choose a screening tool to begin.").font(.body).foregroundColor(.secondary)
                    }
                    .padding(.top, 20)

                    // Fallback: use in-process availableAssessments var from global scope in ContentView.swift
                    if let mirror = Mirror(reflecting: availableAssessments).children.first {
                        // not used; keep placeholder until screener loader is implemented
                    }

                    ForEach(availableAssessments) { profile in
                        AssessmentCard(profile: profile) {
                            viewModel.selectAssessment(profile)
                        }
                    }

                    Spacer()
                }
                .padding()

            case .assessment:
                ScreeningQuestionView(viewModel: viewModel)

            case .analyzing:
                ScreeningAnalyzingView()

            case .result:
                ScreeningResultView(viewModel: viewModel)
            }
        }
        .animation(.default, value: viewModel.appState)
    }
}
