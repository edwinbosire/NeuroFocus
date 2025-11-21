import SwiftUI
import PDFKit
import Observation

// MARK: - MODELS

struct Question: Identifiable, Hashable {
	let id = UUID()
	let text: String
	let category: Category

	enum Category: String, CaseIterable {
		case executiveFunction = "Executive Function"
		case workingMemory = "Working Memory"
		case impulsivity = "Impulsivity"
		case emotionalRegulation = "Emotional Regulation"
		case organization = "Organization Skills"
		case generalAttention = "Inattention" // Added for general screener mapping
		case hyperactivity = "Hyperactivity" // Added for general screener mapping

		var description: String {
			switch self {
			case .executiveFunction: return "Ability to plan, focus, and initiate tasks."
			case .workingMemory: return "Holding information in mind to complete tasks."
			case .impulsivity: return "Acting without thinking or interrupting."
			case .emotionalRegulation: return "Managing frustration and mood stability."
			case .organization: return "Keeping track of time and physical items."
			case .generalAttention: return "Sustaining focus on tasks."
			case .hyperactivity: return "Physical restlessness and need for movement."
			}
		}
	}
}

struct AssessmentProfile: Identifiable {
	let id = UUID()
	let title: String
	let subtitle: String
	let description: String
	let badge: String?
	let color: Color
	let questions: [Question]
}

struct CategoryInsight: Identifiable {
	let id = UUID()
	let category: Question.Category
	let score: Int
	let maxScore: Int
	let insightText: String
	let clinicianNote: String
}

struct DiagnosisResult {
	let score: Int
	let category: String
	let description: String
	let color: Color
	let insights: [CategoryInsight]
}

struct EducationModule: Identifiable {
	let id = UUID()
	let title: String
	let subtitle: String
	let icon: String
	let content: String
	let color: Color
	let tag: String?
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

let availableAssessments: [AssessmentProfile] = [
	AssessmentProfile(
		title: "NHS Adult Screener",
		subtitle: "ASRS v1.1 Part A",
		description: "The standard 6-question screener used by GPs in the UK as an initial step for referral.",
		badge: "Recommended Start",
		color: .blue,
		questions: nhsScreenerQuestions
	),
	AssessmentProfile(
		title: "Deep Dive Assessment",
		subtitle: "Multi-Domain Analysis",
		description: "A detailed 10-question breakdown covering emotional regulation, memory, and executive function.",
		badge: "Detailed Insights",
		color: .purple,
		questions: detailedQuestions
	)
]

let educationModules: [EducationModule] = [
	EducationModule(
		title: "The Assessment Process",
		subtitle: "What actually happens in the room?",
		icon: "clipboard.fill",
		content: """
		A formal ADHD assessment is rarely just a questionnaire. It is a clinical interview that typically involves:

		1. Developmental History: The clinician will ask about your childhood. Evidence of symptoms before age 12 is a key diagnostic criteria.
		
		2. The Clinical Interview: A deep dive into your current life—work, relationships, and daily struggles. They aren't just checking boxes; they are looking for impairment in multiple settings.
		
		3. Collateral Information: They may ask for school reports or to speak with a partner or parent to get an outside perspective.
		
		Tip: Be honest about your "worst days." High-functioning adults often downplay their struggles because they have developed coping mechanisms that hide the struggle.
		""",
		color: .blue,
		tag: nil
	),
	EducationModule(
		title: "ADHD in Women",
		subtitle: "Why it is commonly missed",
		icon: "person.fill.questionmark",
		content: """
		ADHD presentation in women often differs from the hyperactive "naughty boy" stereotype, leading to missed diagnoses.
		
		Common Internalized Symptoms:
		• Daydreaming rather than disrupting class.
		• Chronic anxiety and perfectionism as coping mechanisms.
		• "The Swan Effect": Looking calm on the surface but paddling frantically underneath.
		• Emotional dysregulation often misdiagnosed as BPD or Anxiety.
		• Social masking (mimicking peers to fit in).
		
		If you feel exhausted from "holding it together," mention this specifically to your clinician.
		""",
		color: .purple,
		tag: "Must Read"
	),
	EducationModule(
		title: "High-Achieving Adults",
		subtitle: "Success doesn't rule out ADHD",
		icon: "star.fill",
		content: """
		You can have a PhD, a high-paying job, and a clean house, and still have ADHD. This is often called "High-Functioning ADHD."
		
		The Cost of Coping:
		High achievers often compensate with high intelligence or extreme anxiety (fear of failure). You might get the work done, but it takes you 3x the energy it takes others, leaving you burnt out.
		
		Clinicians look for the "GAP" between your potential and your performance, or the emotional cost required to maintain your standard of living.
		""",
		color: .orange,
		tag: nil
	),
	EducationModule(
		title: "UK Pathways: Right to Choose",
		subtitle: "Navigating the NHS and Private",
		icon: "map.fill",
		content: """
		In the UK, you have specific legal rights regarding your healthcare.
		
		1. Standard NHS Route:
		   Visit GP -> Referral to local ADHD service -> Waitlist (often 2-5 years depending on area).
		
		2. Right to Choose (RTC):
		   Under NHS England rules, if you are referred by a GP for a specialized service, you have the legal right to choose which provider you see, provided they have an NHS contract.
		   
		   How to use RTC:
		   • Research providers (e.g., Psychiatry-UK, ADHD 360).
		   • Download their specific "RTC letter" template.
		   • Take it to your GP and ask specifically for a "Right to Choose referral."
		   • This can reduce wait times from years to months.
		
		3. Private Route:
		   Fastest (weeks), but expensive. Ensure your GP accepts "Shared Care Agreements" before paying, otherwise, you may have to pay for medication privately forever.
		""",
		color: .indigo,
		tag: "UK Specific"
	)
]

let answerOptions = ["Never", "Rarely", "Sometimes", "Often", "Very Often"]

// MARK: - VIEW MODEL

@Observable
class AssessmentViewModel {
	var currentAssessment: AssessmentProfile? = nil
	var currentStep: Int = 0
	var scores: [Int] = []
	var appState: AppState = .selection

	// Sheet State
	var showShareSheet = false
	var reportData: Data? = nil

	enum AppState {
		case selection
		case assessment
		case analyzing
		case result
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
		DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
			withAnimation {
				self.appState = .result
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

		// Scoring logic thresholds (simplified for prototype)
		// NHS Screener (6 questions, max 24) - Cutoff is generally ~13-14 score-wise in this simple sum model

		if percentage >= 0.6 { // Approx >14/24 for NHS or >24/40 for Detailed
			return DiagnosisResult(
				score: totalScore,
				category: "High Likelihood",
				description: "Your responses suggest a strong alignment with ADHD traits. In the context of the \(currentAssessment.title), this indicates a referral is likely warranted.",
				color: .orange,
				insights: categoryInsights
			)
		} else if percentage >= 0.35 {
			return DiagnosisResult(
				score: totalScore,
				category: "Possible Indications",
				description: "You show some signs that may be related to attention deficits. While you might not meet the full threshold, specific areas (see below) may still cause impairment.",
				color: .yellow,
				insights: categoryInsights
			)
		} else {
			return DiagnosisResult(
				score: totalScore,
				category: "Unlikely",
				description: "Your responses do not currently suggest significant ADHD symptoms based on the \(currentAssessment.title) criteria.",
				color: .green,
				insights: categoryInsights
			)
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

			insights.append(CategoryInsight(
				category: category,
				score: total,
				maxScore: max,
				insightText: text,
				clinicianNote: note
			))
		}
		return insights.sorted { $0.category.rawValue < $1.category.rawValue }
	}

	func generatePDF() {
		let generator = ReportGenerator()
		let data = generator.createPDF(viewModel: self)
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

// MARK: - PDF GENERATOR

class ReportGenerator {
	func createPDF(viewModel: AssessmentViewModel) -> Data {
		let format = UIGraphicsPDFRendererFormat()
		format.documentInfo = [kCGPDFContextTitle: "ADHD Assessment", kCGPDFContextAuthor: "Focus Check"] as [String: Any]
		let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792), format: format)

		return renderer.pdfData { context in
			context.beginPage()
			let titleAttr: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 22)]
			let bodyAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 11)]
			let boldAttr: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 11)]

			"Focus Check Clinical Report".draw(at: CGPoint(x: 50, y: 50), withAttributes: titleAttr)

			guard let assessment = viewModel.currentAssessment else { return }

			var yOffset = 90.0

			"Screener Used: \(assessment.title) (\(assessment.subtitle))".draw(at: CGPoint(x: 50, y: yOffset), withAttributes: boldAttr)
			yOffset += 30

			let result = viewModel.getResult()
			"Result Category: \(result.category)".draw(at: CGPoint(x: 50, y: yOffset), withAttributes: boldAttr)
			yOffset += 20

			result.description.draw(in: CGRect(x: 50, y: yOffset, width: 500, height: 40), withAttributes: bodyAttr)
			yOffset += 50

			"Domain Breakdown:".draw(at: CGPoint(x: 50, y: yOffset), withAttributes: boldAttr)
			yOffset += 20

			for insight in result.insights {
				let line = "\(insight.category.rawValue): \(insight.score)/\(insight.maxScore) - \(insight.insightText)"
				line.draw(at: CGPoint(x: 50, y: yOffset), withAttributes: bodyAttr)
				yOffset += 20
			}

			yOffset += 30
			"Response Transcript:".draw(at: CGPoint(x: 50, y: yOffset), withAttributes: boldAttr)
			yOffset += 20

			for (index, question) in assessment.questions.enumerated() {
				if index < viewModel.scores.count {
					 // Simple page break check logic would go here for a real app
					let answer = answerOptions[viewModel.scores[index]]
					let qLine = "\(index + 1). \(question.text)"
					let aLine = "   Response: \(answer)"

					qLine.draw(at: CGPoint(x: 50, y: yOffset), withAttributes: bodyAttr)
					yOffset += 15
					aLine.draw(at: CGPoint(x: 50, y: yOffset), withAttributes: [
						.font: UIFont.italicSystemFont(ofSize: 10), .foregroundColor: UIColor.darkGray
					])
					yOffset += 25
				}
			}

			// Footer
			let disclaimer = "Disclaimer: This report is generated by a prototype tool and is not a formal medical diagnosis."
			disclaimer.draw(at: CGPoint(x: 50, y: 750), withAttributes: [
				.font: UIFont.italicSystemFont(ofSize: 9), .foregroundColor: UIColor.gray
			])
		}
	}
}

// MARK: - COMPONENT VIEWS

struct PrimaryButton: View {
	let title: String
	let action: () -> Void
	var color: Color = .blue
	var icon: String? = nil

	var body: some View {
		Button(action: action) {
			HStack {
				if let icon = icon { Image(systemName: icon) }
				Text(title).fontWeight(.bold)
			}
			.font(.headline)
			.foregroundColor(.white)
			.frame(maxWidth: .infinity)
			.padding()
			.background(color)
			.cornerRadius(16)
			.shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
		}
	}
}

struct OptionButton: View {
	let title: String
	let isSelected: Bool
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			HStack {
				Text(title)
					.font(.body)
					.fontWeight(.medium)
					.foregroundColor(Color.primary)
				Spacer()
				if isSelected {
					Image(systemName: "checkmark.circle.fill").foregroundColor(.blue)
				} else {
					Image(systemName: "circle").foregroundColor(.gray.opacity(0.5))
				}
			}
			.padding()
			.background(Color(UIColor.secondarySystemBackground))
			.cornerRadius(12)
			.overlay(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2))
		}
		.scaleEffect(isSelected ? 1.02 : 1.0)
		.animation(.spring(response: 0.3), value: isSelected)
	}
}

struct ProgressBar: View {
	var value: CGFloat
	var color: Color = .blue

	var body: some View {
		GeometryReader { geometry in
			ZStack(alignment: .leading) {
				Rectangle().frame(width: geometry.size.width, height: 6).opacity(0.3).foregroundColor(Color(UIColor.systemGray4))
				Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: 6).foregroundColor(color)
					.animation(.linear, value: value)
			}
			.cornerRadius(45.0)
		}
	}
}

struct AssessmentCard: View {
	let profile: AssessmentProfile
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			VStack(alignment: .leading, spacing: 16) {
				HStack {
					ZStack {
						Circle()
							.fill(profile.color.opacity(0.2))
							.frame(width: 50, height: 50)
						Image(systemName: "doc.text.fill")
							.foregroundColor(profile.color)
							.font(.title3)
					}

					VStack(alignment: .leading, spacing: 4) {
						Text(profile.title)
							.font(.headline)
							.foregroundColor(.primary)
						Text(profile.subtitle)
							.font(.caption)
							.fontWeight(.bold)
							.foregroundColor(.secondary)
					}
					Spacer()
					if let badge = profile.badge {
						Text(badge.uppercased())
							.font(.system(size: 10, weight: .bold))
							.padding(.horizontal, 8)
							.padding(.vertical, 4)
							.background(profile.color.opacity(0.1))
							.foregroundColor(profile.color)
							.cornerRadius(8)
					}
				}

				Text(profile.description)
					.font(.subheadline)
					.foregroundColor(.secondary)
					.fixedSize(horizontal: false, vertical: true)
					.lineLimit(3)
					.multilineTextAlignment(.leading)

				HStack {
					Label("\(profile.questions.count) Questions", systemImage: "list.bullet")
						.font(.caption)
						.foregroundColor(.gray)
					Spacer()
					Text("Start")
						.font(.subheadline)
						.fontWeight(.bold)
						.foregroundColor(profile.color)
					Image(systemName: "arrow.right")
						.font(.caption)
						.foregroundColor(profile.color)
				}
				.padding(.top, 8)
			}
			.padding()
			.background(Color(UIColor.secondarySystemBackground))
			.cornerRadius(20)
		}
		.buttonStyle(PlainButtonStyle())
	}
}

// MARK: - MAIN VIEWS

struct AssessmentFlowView: View {
	@State private var viewModel = AssessmentViewModel()

	var body: some View {
		ZStack {
			Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)

			switch viewModel.appState {
			case .selection:
				SelectionView(viewModel: viewModel)
					.transition(.opacity)
			case .assessment:
				QuestionView(viewModel: viewModel)
					.transition(.asymmetric(insertion: .opacity, removal: .scale))
			case .analyzing:
				AnalyzingView()
					.transition(.opacity)
			case .result:
				ResultView(viewModel: viewModel)
					.transition(.move(edge: .bottom))
			}
		}
		.animation(.default, value: viewModel.appState)
	}
}

struct SelectionView: View {
	var viewModel: AssessmentViewModel

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 24) {
				VStack(alignment: .leading, spacing: 8) {
					Text("Assessments")
						.font(.largeTitle)
						.fontWeight(.bold)
					Text("Choose a screening tool to begin.")
						.font(.body)
						.foregroundColor(.secondary)
				}
				.padding(.top, 20)

				ForEach(availableAssessments) { profile in
					AssessmentCard(profile: profile) {
						viewModel.selectAssessment(profile)
					}
				}

				VStack(spacing: 12) {
					Image(systemName: "lock.shield.fill")
						.font(.title2)
						.foregroundColor(.green)
					Text("Private & Secure")
						.font(.headline)
					Text("Your results never leave this device unless you choose to export them.")
						.font(.caption)
						.multilineTextAlignment(.center)
						.foregroundColor(.secondary)
						.padding(.horizontal)
				}
				.padding(.top, 40)
				.frame(maxWidth: .infinity)
			}
			.padding()
		}
	}
}

struct QuestionView: View {
	var viewModel: AssessmentViewModel

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
							.id("QuestionTitle\(viewModel.currentStep)")
							.transition(.opacity.combined(with: .move(edge: .trailing)))
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

struct AnalyzingView: View {
	var body: some View {
		VStack(spacing: 20) {
			ProgressView().scaleEffect(1.5).progressViewStyle(CircularProgressViewStyle(tint: .blue))
			Text("Analyzing responses...").font(.headline).foregroundColor(.secondary)
		}
	}
}

struct ResultView: View {
	var viewModel: AssessmentViewModel

	var body: some View {
		@Bindable var viewModel = viewModel
		let result = viewModel.getResult()

		ScrollView {
			VStack(spacing: 30) {
				VStack(spacing: 10) {
					ZStack {
						Circle().fill(result.color.opacity(0.2)).frame(width: 100, height: 100)
						Image(systemName: "brain").font(.system(size: 40)).foregroundColor(result.color)
					}
					.padding(.top, 20)
					Text(result.category).font(.title).fontWeight(.heavy).foregroundColor(result.color)
				}

				VStack(alignment: .leading, spacing: 12) {
					Text("Analysis").font(.headline)
					Text(result.description).font(.subheadline).foregroundColor(.secondary)
				}
				.padding().background(Color(UIColor.secondarySystemBackground)).cornerRadius(16)

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
				.padding().background(Color(UIColor.secondarySystemBackground).opacity(0.5)).cornerRadius(16)

				PrimaryButton(title: "Export Clinical Report (PDF)", action: { viewModel.generatePDF() }, color: .green, icon: "doc.text.fill")
				Spacer(minLength: 20)
				Button("Take Another Assessment") { viewModel.reset() }.font(.subheadline).foregroundColor(.secondary).padding(.bottom)
			}
			.padding(24)
		}
		.sheet(isPresented: $viewModel.showShareSheet) {
			if let data = viewModel.reportData { ShareSheet(items: [data]) }
		}
	}
}

struct EducationHubView: View {
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(alignment: .leading, spacing: 20) {
					Text("Learn & Prepare")
						.font(.title2)
						.fontWeight(.bold)
						.padding(.horizontal)
						.padding(.top)

					Text("Understand the process and language to advocate for yourself.")
						.font(.subheadline)
						.foregroundColor(.secondary)
						.padding(.horizontal)

					ForEach(educationModules) { module in
						NavigationLink(destination: ModuleDetailView(module: module)) {
							HStack(spacing: 16) {
								ZStack {
									Circle()
										.fill(module.color.opacity(0.15))
										.frame(width: 50, height: 50)

									Image(systemName: module.icon)
										.font(.system(size: 24))
										.foregroundColor(module.color)
								}

								VStack(alignment: .leading, spacing: 4) {
									HStack {
										Text(module.title)
											.font(.headline)
											.foregroundColor(.primary)

										if let tag = module.tag {
											Text(tag)
												.font(.caption2)
												.fontWeight(.bold)
												.padding(.horizontal, 6)
												.padding(.vertical, 2)
												.background(Color.primary.opacity(0.1))
												.cornerRadius(4)
												.foregroundColor(.primary)
										}
									}

									Text(module.subtitle)
										.font(.subheadline)
										.foregroundColor(.secondary)
										.multilineTextAlignment(.leading)
								}
								Spacer()
								Image(systemName: "chevron.right")
									.foregroundColor(.gray.opacity(0.5))
							}
							.padding()
							.background(Color(UIColor.secondarySystemBackground))
							.cornerRadius(16)
							.padding(.horizontal)
						}
					}
				}
				.padding(.bottom)
			}
			.navigationTitle("Education")
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}

struct ModuleDetailView: View {
	let module: EducationModule

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 24) {
				HStack {
					ZStack {
						Circle()
							.fill(module.color.opacity(0.2))
							.frame(width: 60, height: 60)
						Image(systemName: module.icon)
							.font(.title)
							.foregroundColor(module.color)
					}
					VStack(alignment: .leading) {
						Text(module.title)
							.font(.title2)
							.fontWeight(.bold)
						if let tag = module.tag {
							Text(tag.uppercased())
								.font(.caption)
								.fontWeight(.bold)
								.foregroundColor(.secondary)
						}
					}
				}
				.padding(.top)
				Divider()
				Text(module.content).font(.body).lineSpacing(6).padding(.bottom, 40)
			}
			.padding()
		}
		.navigationBarTitleDisplayMode(.inline)
	}
}

struct ShareSheet: UIViewControllerRepresentable {
	var items: [Any]
	func makeUIViewController(context: Context) -> UIActivityViewController { UIActivityViewController(activityItems: items, applicationActivities: nil) }
	func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct ADHDAssessmentView: View {
	var body: some View {
		TabView {
			AssessmentFlowView()
				.tabItem { Label("Assess", systemImage: "checklist") }

			EducationHubView()
				.tabItem { Label("Learn", systemImage: "book.fill") }
		}
	}
}

#Preview {
	ADHDAssessmentView()
}
