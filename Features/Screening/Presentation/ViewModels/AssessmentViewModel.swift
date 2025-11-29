import Foundation
import SwiftUI

@MainActor
final class AssessmentViewModel: ObservableObject, Identifiable {
    @Published var currentStep: Int = 0
	@Published var scores: [UUID :Int] = [:]
    @Published var appState: AppState = .assessment

    // Sheet State
    @Published var showShareSheet = false
    @Published var reportData: Data? = nil
    @Published var previousResults: [ScreeningRepository.LoadedResult] = []

	enum AppState: String {
        case assessment, analyzing, result
    }

	let id: UUID
	private let profile: AssessmentProfile
    private let repo: any ScreeningRepositoryProtocol
    private let pdfService: PDFServiceProtocol

	public init(assessment: AssessmentProfile, repo: any ScreeningRepositoryProtocol = DependencyContainer.shared.screeningRepository,
                pdfService: PDFServiceProtocol = DependencyContainer.shared.pdfService) {
		self.id = assessment.id
		self.profile = assessment
        self.repo = repo
        self.pdfService = pdfService
    }


	// MARK: AssessmentProfile
	var index: Int {
		profile.index
	}
	var title: String {
		profile.title
	}
	var subtitle: String {
		profile.subtitle
	}
	var description: String {
		profile.description
	}
	var badge: String? {
		profile.badge
	}
	var color: Color {
		profile.color
	}
	var questions: [Question] {
		profile.questions
	}


    var progress: CGFloat {
        CGFloat(currentStep) / CGFloat(questions.count)
    }

	func answerQuestion(value: Int) async {
		guard currentStep < questions.count - 2 else {
			await completeAssessment()
			return
		}
		scores[questions[currentStep].id] = value
		currentStep += 1
	}

	func completeAssessment() async {
		appState = .analyzing
	}

	func completeAnalysis() async {
		self.appState = .result
		// Persist diagnosis result and transcript to repo (fire-and-forget)
		Task {
			do {
				let result = self.getResult()
				let transcript: [(index: Int, text: String, answer: String)] = {
					let answerOptions = ["Never","Rarely","Sometimes","Often","Very Often"]
					return questions.enumerated().map { (index, question) in
						let answerIndex = scores[question.id] ?? 0
						let answer = answerOptions[min(answerIndex, answerOptions.count - 1)]
						return (index: index + 1, text: question.text, answer: answer)
					}
				}()
				if let repo = self.repo as? ScreeningRepository {
					try await repo.saveResult(result, transcript: transcript)
				} else {
					// fallback for protocol
					try await self.repo.saveResult(result)
				}
			} catch {
				// ignore for MVP
			}
		}
	}

	func getResult() -> DiagnosisResult {
		let totalScore = Array(scores.values).reduce(0, +)
        let maxPossible = questions.count * 4
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
		guard questions.count > 0 else { return [] }
		let questions = questions
        var insights: [CategoryInsight] = []

        let presentCategories = Set(questions.map { $0.category })
        for category in presentCategories {
            let categoryIndices = questions.indices.filter { questions[$0].category == category }
			let categoryScores = categoryIndices.map { scores[questions[$0].id] ?? 0 }
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
		let assessment = profile

        var rdQuestions: [ReportQuestion] = []
        for (index, question) in assessment.questions.enumerated() {
			let answerIndex = scores[question.id] ?? 0
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
            appState = .assessment
            currentStep = 0
			scores = [:]
            reportData = nil
            showShareSheet = false
        }
    }

    func loadPreviousResults() async {
        guard let repo = self.repo as? ScreeningRepository else { return }
        do {
            let results = try await repo.loadResultsWithTranscripts()
            Task {@MainActor in
                self.previousResults = results
            }
        } catch {
            // ignore for MVP
        }
    }
}

// MARK: - DATA

// 1. The Detailed Assessment (Original)
let detailedQuestions: [Question] = [
	Question(text: "When you have a task that requires a lot of thought, how often do you avoid or delay getting started?", category: .executiveFunction),
	Question(text: "How often do you have trouble keeping your attention on repetitive work?", category: .executiveFunction),
	Question(text: "How often do you have difficulty getting things in order when you have to do a task that requires organization?", category: .organization),
	Question(text: "How often do you have trouble wrapping up the final details of a project, once the challenging parts have been done?", category: .organization),
	Question(text: "How often do you have problems remembering appointments or obligations?", category: .workingMemory),
	Question(text: "Do you often find yourself entering a room and forgetting why you went there?", category: .workingMemory),
	Question(text: "How often do you fidget or squirm with your hands or feet when you have to sit down for a long time?", category: .impulsivity),
	Question(text: "How often do you feel overly active and compelled to do things, like you were driven by a motor?", category: .impulsivity),
	Question(text: "How often do you feel easily frustrated by small annoyances?", category: .emotionalRegulation),
	Question(text: "Do you experience rapid shifts in mood that seem out of proportion to events?", category: .emotionalRegulation)
]

// 2. The NHS / ASRS v1.1 Part A Screener
let nhsScreenerQuestions: [Question] = [
	Question(text: "How often do you have trouble wrapping up the final details of a project, once the challenging parts have been done?", category: .generalAttention),
	Question(text: "How often do you have difficulty getting things in order when you have to do a task that requires organization?", category: .organization),
	Question(text: "How often do you have problems remembering appointments or obligations?", category: .workingMemory),
	Question(text: "When you have a task that requires a lot of thought, how often do you avoid or delay getting started?", category: .executiveFunction),
	Question(text: "How often do you fidget or squirm with your hands or feet when you have to sit down for a long time?", category: .hyperactivity),
	Question(text: "How often do you feel overly active and compelled to do things, like you were driven by a motor?", category: .hyperactivity)
]


