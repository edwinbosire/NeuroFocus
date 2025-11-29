import SwiftUI

// Education hub scaffold

struct EducationHubView: View {
	let moduleCardViewHeight: CGFloat = 220
	let columns = [GridItem](repeating: GridItem(.adaptive(minimum: 200, maximum: 350), spacing: 10.0), count: 2)
	@Namespace var animation
	var body: some View {
		NavigationStack {
			ScrollView {
				headingView
				LazyVGrid(columns: columns, spacing: 10.0) {
					ForEach(educationModules) { module in
						NavigationLink(destination: ModuleDetailView(module: module, animation: animation)) {
							moduleCardView(module)
								.frame(height: moduleCardViewHeight)
						}
					}
				}
				.padding(.horizontal)
				VStack(alignment: .leading, spacing: 20) {
					headingView
					ForEach(educationModules) { module in
						subjectRowView(module)

					}
				}
				.padding(.horizontal)
			}
			.navigationTitle("Education")
			.navigationBarTitleDisplayMode(.inline)
		}
	}

	var headingView: some View {
		VStack(alignment: .leading) {
			Text("Learn & Prepare")
				.font(.title2)
				.fontWeight(.bold)
				.padding(.top)

			Text("Understand the process and language to advocate for yourself.")
				.font(.subheadline)
				.foregroundColor(.secondary)
		}
	}

	func moduleCardView(_ module: EducationModule) -> some View {
		VStack(spacing: 16) {
			Circle()
				.fill(module.color.opacity(0.15))
				.frame(width: 50, height: 50)
				.overlay {
					Circle()
						.stroke(module.color.opacity(0.3), style: StrokeStyle(lineWidth: 1))
				}
				.overlay {
					Image(systemName: module.icon)
						.font(.title2)
						.foregroundColor(module.color)
				}

			VStack(spacing: 4) {
				Text(module.title)
					.font(.headline)
					.foregroundColor(.primary)
					.multilineTextAlignment(.center)


				Text(module.subtitle)
					.font(.subheadline)
					.foregroundColor(.secondary)
					.multilineTextAlignment(.leading)
			}
		}
		.padding(.horizontal, 8.0)
		.padding(.vertical)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(module.color.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
		.matchedTransitionSource(id: module.id, in: animation)
		.overlay(alignment: .top) {
			if let tag = module.tag {
				Text(tag)
					.font(.caption2)
					.fontWeight(.bold)
					.foregroundStyle(Color.white)
					.padding(.horizontal, 8)
					.padding(.vertical, 2)
					.background(module.color, in: Capsule())
					.cornerRadius(4)
					.foregroundColor(.primary)
					.padding(.trailing, 8.0)
					.padding(.top, -8.0)
			}
		}
	}
	func subjectRowView(_ module: EducationModule) -> some View {
		NavigationLink(destination: ModuleDetailView(module: module, animation: animation)) {
			HStack(spacing: 16) {
				ZStack {
					Circle()
						.fill(module.color.opacity(0.15))
						.frame(width: 50, height: 50)
						.overlay {
							Circle()
								.stroke(module.color, style: StrokeStyle(lineWidth: 1))
						}

					Image(systemName: module.icon)
						.font(.system(size: 24))
						.foregroundColor(module.color)
				}

				VStack(alignment: .leading, spacing: 4) {
						Text(module.title)
							.font(.headline)
							.foregroundColor(.primary)
							.frame(maxWidth: .infinity, alignment: .leading)


					Text(module.subtitle)
						.font(.subheadline)
						.foregroundColor(.secondary)
						.multilineTextAlignment(.leading)
				}
				Image(systemName: "chevron.right")
					.foregroundColor(.gray.opacity(0.5))
			}
			.padding()
			.background(Color(UIColor.secondarySystemBackground))
			.cornerRadius(16)
			.overlay(alignment: .topTrailing) {
				if let tag = module.tag {
					Text(tag)
						.font(.caption2)
						.fontWeight(.bold)
						.foregroundStyle(Color.white)
						.padding(.horizontal, 8)
						.padding(.vertical, 2)
						.background(module.color, in: Capsule())
						.cornerRadius(4)
						.foregroundColor(.primary)
						.padding(.trailing, 8.0)
						.padding(.top, -8.0)
				}
			}
			.matchedTransitionSource(id: module.id, in: animation)
		}

	}
}

#Preview {
	EducationHubView()
}

let educationModules: [EducationModule] = [
	EducationModule(
		title: "The Assessment Process",
		subtitle: "What actually happens in the room?",
		icon: "clipboard.fill",
		content: """
		A formal ADHD assessment is rarely just a questionnaire. It is a clinical interview that typically involves:
		
		
		**1. Developmental History:** \nThe clinician will ask about your childhood. Evidence of symptoms before age 12 is a key diagnostic criteria.
		
		**2. The Clinical Interview:** \n A deep dive into your current life—work, relationships, and daily struggles. They aren't just checking boxes; they are looking for impairment in multiple settings.
		
		**3. Collateral Information:** \n They may ask for school reports or to speak with a partner or parent to get an outside perspective.
		
		> **Tip:** Be honest about your *"worst days."* High-functioning adults often downplay their struggles because they have developed coping mechanisms that hide the struggle.
		""",
		color: .blue,
		tag: nil
	),
	EducationModule(
		title: "ADHD in Women",
		subtitle: "Why it is commonly missed",
		icon: "person.fill.questionmark",
		content:
  """
  ADHD presentation in women often differs from the hyperactive "naughty boy" stereotype, leading to missed diagnoses.
  
  Common Internalized Symptoms: \n
  - Daydreaming rather than disrupting class.
  - Chronic anxiety and perfectionism as coping mechanisms.
  - "The Swan Effect": Looking calm on the surface but paddling frantically underneath.
  - Emotional dysregulation often misdiagnosed as BPD or Anxiety.
  - Social masking (mimicking peers to fit in).
  
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
