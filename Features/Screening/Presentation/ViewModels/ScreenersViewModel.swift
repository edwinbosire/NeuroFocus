//
//  ScreenersViewModel.swift
//  NeuroFocus
//
//  Created by Edwin Bosire on 29/11/2025.
//

import Foundation
import Observation

@MainActor @Observable
final class ScreenersViewModel {
	let assessments: [AssessmentViewModel]

	init() {
		self.assessments = availableAssessments.map {
			AssessmentViewModel(assessment: $0)
		}
	}
}


let availableAssessments: [AssessmentProfile] = [
	AssessmentProfile(
		index: 1,
		title: "NHS Adult Screener",
		subtitle: "ASRS v1.1 Part A",
		description: "The standard 6-question screener used by GPs in the UK as an initial step for referral.",
		badge: "Recommended Start",
		color: .blue,
		questions: nhsScreenerQuestions
	),
	AssessmentProfile(
		index: 2,
		title: "Deep Dive Assessment",
		subtitle: "Multi-Domain Analysis",
		description: "A detailed 10-question breakdown covering emotional regulation, memory, and executive function.",
		badge: "Detailed Insights",
		color: .purple,
		questions: detailedQuestions
	)
]
