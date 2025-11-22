import Foundation
import SwiftUI

@MainActor
final class AssessmentViewModel: ObservableObject {
    @Published var currentAssessment: AssessmentProfile? = nil
    @Published var currentStep: Int = 0
    @Published var scores: [Int] = []
    @Published var appState: AppState = .selection

    // Sheet State
    @Published var showShareSheet = false
    @Published var reportData: Data? = nil

    enum AppState {
        case selection, assessment, analyzing, result
    }

    private let repo: any ScreeningRepositoryProtocol
    private let pdfService: PDFServiceProtocol

    public init(repo: any ScreeningRepositoryProtocol = DependencyContainer.shared.screeningRepository,
                pdfService: PDFServiceProtocol = DependencyContainer.shared.pdfService) {
        self.repo = repo
        self.pdfService = pdfService
    }

    var progress: CGFloat {
        guard let questions = currentAssessment?.questions else { return 0 }
        return CGFloat(currentStep) / CGFloat(questions.count)
    }

    func selectAssessment(_ profile: AssessmentProfile) {
        self.currentAssessment = profile
        withAnimation(.spring()) {
            appState = .assessment
            currentStep = 0
            scores = []
        }
    }

    func answerQuestion(value: Int) {
        scores.append(value)

        guard let questions = currentAssessment?.questions else { return }

        if currentStep < questions.count - 1 {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                currentStep += 1
            }
        } else {
            completeAssessment()
        }
    }

    func completeAssessment() {
        withAnimation {
            appState = .analyzing
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                self.appState = .result
            }
            Task {
                // Persist a simple diagnosis result to repo (fire-and-forget)
                do {
                    let result = self.getResult()
                    try await self.repo.saveResult(result)
                } catch {
                    // ignore for MVP
                }
            }
        }
    }

    func getResult() -> DiagnosisResult {
        guard let currentAssessment = currentAssessment else {
            return DiagnosisResult(score: 0, category: "Error", description: "No assessment data", color: .gray, insights: [])
        }

        let totalScore = scores.reduce(0, +)
        let maxPossible = currentAssessment.questions.count * 4
        let percentage = Double(totalScore) / Double(maxPossible)

        let categoryInsights = generateDetailedInsights()

        if percentage >= 0.6 {
            return DiagnosisResult(score: totalScore, category: "High Likelihood", description: "Your responses suggest a strong alignment with ADHD traits. Discuss with a clinician.", color: .orange, insights: categoryInsights)
        } else if percentage >= 0.35 {
            return DiagnosisResult(score: totalScore, category: "Possible Indications", description: "You show some signs that may be related to attention deficits. Consider discussing with a clinician.", color: .yellow, insights: categoryInsights)
        } else {
            return DiagnosisResult(score: totalScore, category: "Unlikely", description: "Your responses do not currently suggest significant ADHD symptoms.", color: .green, insights: categoryInsights)
        }
    }

    private func generateDetailedInsights() -> [CategoryInsight] {
        guard let questions = currentAssessment?.questions else { return [] }
        var insights: [CategoryInsight] = []

        let presentCategories = Set(questions.map { $0.category })

        for category in presentCategories {
            let categoryIndices = questions.indices.filter { questions[$0].category == category }
            let categoryScores = categoryIndices.map { scores.indices.contains($0) ? scores[$0] : 0 }
            let total = categoryScores.reduce(0, +)
            let max = categoryIndices.count * 4
            let percentage = Double(total) / Double(max)

            var text = ""
            var note = ""

            if percentage >= 0.75 {
                text = "Significant difficulty reported."
                note = "Clinician Note: Frequent impairment in \(category.rawValue.lowercased())."
            } else if percentage >= 0.5 {
                text = "Moderate difficulty."
                note = "Clinician Note: Intermittent challenges with \(category.rawValue.lowercased())."
            } else {
                text = "Functioning well."
                note = "Clinician Note: No significant impairment reported."
            }

            insights.append(CategoryInsight(category: category, score: total, maxScore: max, insightText: text, clinicianNote: note))
        }
        return insights.sorted { $0.category.rawValue < $1.category.rawValue }
    }

    func generatePDF() {
        // Build ReportData
        guard let assessment = currentAssessment else { return }

        var rdQuestions: [ReportQuestion] = []
        for (index, question) in assessment.questions.enumerated() {
            let answerIndex = scores.indices.contains(index) ? scores[index] : 0
            let answerOptions = ["Never","Rarely","Sometimes","Often","Very Often"]
            let answer = answerOptions[min(answerIndex, answerOptions.count - 1)]
            rdQuestions.append(ReportQuestion(index: index + 1, text: question.text, answer: answer))
        }

        let result = getResult()
        let insightsText = result.insights.map { "\($0.category.rawValue): \($0.score)/\($0.maxScore) - \($0.insightText)" }

        let report = ReportData(title: assessment.title,
                                subtitle: assessment.subtitle,
                                resultCategory: result.category,
                                resultDescription: result.description + "\n\nNot a diagnosis. Only a qualified clinician can diagnose ADHD.",
                                insights: insightsText,
                                questions: rdQuestions,
                                disclaimer: "Not a diagnosis. Only a qualified clinician can diagnose ADHD.")

        let data = pdfService.createPDF(from: report)
        self.reportData = data
        self.showShareSheet = true
    }

    func reset() {
        withAnimation {
            appState = .selection
            currentStep = 0
            scores = []
            currentAssessment = nil
            reportData = nil
            showShareSheet = false
        }
    }
}
