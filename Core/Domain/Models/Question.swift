import Foundation
import SwiftUI

// Migrated model: Question
// Source: NeuroFocus/NeuroFocus/ContentView.swift

public struct Question: Identifiable, Hashable {
    public let id = UUID()
    public let text: String
    public let category: Category
	public let answerOptions = ["Never","Rarely","Sometimes","Often","Very Often"]

    public enum Category: String, CaseIterable, Codable {
        case executiveFunction = "Executive Function"
        case workingMemory = "Working Memory"
        case impulsivity = "Impulsivity"
        case emotionalRegulation = "Emotional Regulation"
        case organization = "Organization Skills"
        case generalAttention = "Inattention"
        case hyperactivity = "Hyperactivity"

        public var description: String {
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

	static let empty: Question = .init(text: "", category: .executiveFunction)
}

