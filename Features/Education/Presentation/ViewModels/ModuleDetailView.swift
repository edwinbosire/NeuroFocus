//
//  EducationViewModel.swift
//  NeuroFocus
//
//  Created by Edwin Bosire on 26/11/2025.
//

import SwiftUI

struct ModuleDetailView: View {
	let module: EducationModule
	var animation: Namespace.ID

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 1) {
				VStack {
					Circle()
						.fill(module.color.opacity(0.15))
						.frame(width: 60, height: 60)
						.overlay {
							Image(systemName: module.icon)
								.font(.title)
								.foregroundColor(module.color)
						}

					VStack(alignment: .leading) {
						Text(module.title)
							.font(.title2)
							.fontWeight(.bold)
							.frame(maxWidth: .infinity, alignment: .center)
						if let tag = module.tag {
							Text(tag.uppercased())
								.font(.caption)
								.fontWeight(.bold)
								.foregroundColor(.secondary)
								.frame(maxWidth: .infinity, alignment: .center)
						}
					}
				}
				.padding()
				.ignoresSafeArea(.container, edges: .top)

				Text(formattedContent)
					.font(.body)
					.lineSpacing(6)
					.padding(.bottom, 40)
					.padding(.top, 30)
					.padding(.horizontal, 20)
					.background {
						UnevenRoundedRectangle(cornerRadii: .init(topLeading: 20, topTrailing: 20))
							.fill(Color(UIColor.systemBackground))
					}

			}
			.navigationTitle(module.title)
			.ignoresSafeArea(.all)
			.background(module.color.opacity(0.2))
			.navigationTransition(.zoom(sourceID: module.id, in: animation))
		}
		.toolbar(.hidden, for: .tabBar)
		.navigationBarTitleDisplayMode(.inline)
		.background(module.color.opacity(0.15))
	}

	var formattedContent: AttributedString {
		guard let markdown = try? AttributedString(markdown: module.content, options: .init(allowsExtendedAttributes: true, interpretedSyntax: .inlineOnlyPreservingWhitespace, failurePolicy: .returnPartiallyParsedIfPossible, languageCode: "en-GB")) else {
			return "Error parsing content"
		}
		return markdown
	}
}

#Preview {
	@Previewable @Namespace var animation: Namespace.ID
	let module = EducationModule(
		title: "The Assessment Process",
		subtitle: "What actually happens in the room?",
		icon: "clipboard.fill",
		content:
  """
  A formal ADHD assessment is rarely just a questionnaire. It is a clinical interview that typically involves:
    
  **1. Developmental History:** \nThe clinician will ask about your childhood. Evidence of symptoms before age 12 is a key diagnostic criteria.
  
  **2. The Clinical Interview:** \n A deep dive into your current life—work, relationships, and daily struggles. They aren't just checking boxes; they are looking for impairment in multiple settings.
  
  **3. Collateral Information:** \n They may ask for school reports or to speak with a partner or parent to get an outside perspective.
  
  > **Tip:** Be honest about your *"worst days."* High-functioning adults often downplay their struggles because they have developed coping mechanisms that hide the struggle.
  """,
		color: .blue,
		tag: "Recommended"
	)

	NavigationStack {
		ModuleDetailView(module: module, animation: animation)
	}
}
