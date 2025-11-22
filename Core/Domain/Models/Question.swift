import Foundation
import SwiftUI

// Migrated model: Question
// Source: NeuroFocus/NeuroFocus/ContentView.swift

public struct Question: Identifiable, Hashable {
    public let id = UUID()
    public let text: String
    public let category: Category

    public enum Category: String, CaseIterable {
        case executiveFunction = "Executive Function"
        case workingMemory = "Working Memory"
        case impulsivity = "Impulsivity"
        case emotionalRegulation = "Emotional Regulation"
        case organization = "Organization Skills"
        case generalAttention = "Inattention"
        case hyperactivity = "Hyperactivity"
    }
}
