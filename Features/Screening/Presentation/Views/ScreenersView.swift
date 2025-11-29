import SwiftUI

// SelectionView scaffold — shows available assessments

struct ScreenersView: View {
	@State private var viewModel = ScreenersViewModel()
	@Namespace private var animation

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 24) {
				VStack(alignment: .leading) {
					Text("Assessments").font(.largeTitle).fontWeight(.bold)
					Text("Choose a screening tool to begin.").font(.body).foregroundColor(.secondary)
				}
				.padding(.top, 20)

				ForEach(viewModel.assessments) { assessment in
					NavigationLink(destination: AssessmentLandingPage(viewModel: assessment, animation: animation)) {
						AssessmentCard(assessment: assessment)
							.matchedTransitionSource(id: assessment.id, in: animation)
					}
				}

				Spacer()
			}
			.padding()
		}
	}
}

struct AssessmentCard: View {
	let assessment: AssessmentViewModel

	var body: some View {
		VStack {
			VStack(alignment: .leading, spacing: 16) {
				HStack {
					Circle()
						.fill(assessment.color.opacity(0.15))
						.frame(width: 50, height: 50)
						.overlay {
							Circle()
								.stroke(assessment.color.opacity(0.3), style: StrokeStyle(lineWidth: 1))
						}
						.overlay {
							Image(systemName: "doc.text.fill")
								.font(.title2)
								.foregroundColor(assessment.color)
						}

					VStack(alignment: .leading, spacing: 4) {
						Text(assessment.title)
							.font(.headline)
							.foregroundColor(.primary)
							.frame(maxWidth: .infinity, alignment: .leading)
						Text(assessment.subtitle)
							.font(.caption)
							.fontWeight(.bold)
							.foregroundColor(.secondary)
					}
				}

				Text(assessment.description)
					.font(.subheadline)
					.foregroundColor(.secondary)
					.fixedSize(horizontal: false, vertical: true)
					.lineLimit(3)
					.multilineTextAlignment(.leading)

				HStack {
					Label("\(assessment.questions.count) Questions", systemImage: "list.bullet")
						.font(.caption)
						.foregroundColor(.gray)
					Spacer()
					Text("Start")
						.font(.subheadline)
						.fontWeight(.bold)
						.foregroundColor(assessment.color)
					Image(systemName: "arrow.right")
						.font(.caption)
						.foregroundColor(assessment.color)
				}
				.padding(.top, 8)
			}
			.padding()
			.background(assessment.color.opacity(0.09).gradient, in: RoundedRectangle(cornerRadius: 12))
			.background(alignment: .trailing) {
				Text("\(assessment.index)")
					.font(.system(size: 150))
					.fontWeight(.bold)
					.foregroundColor(.gray.opacity(0.1))
			}
		}
		.overlay(alignment: .topTrailing) {
			if let badge = assessment.badge {
				Text(badge.uppercased())
					.font(.caption)
					.fontWeight(.bold)
					.padding(.horizontal, 8)
					.padding(.vertical, 4)
					.foregroundColor(assessment.color)
					.background(assessment.color.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
					.alignmentGuide(.top) { dim in
						-10 * dim.height / 2
					}
					.alignmentGuide(.trailing) { dim in
						-10 * dim.width / 2
					}

			}
		}
	}
}

#Preview {
	ScreenersView()
}
