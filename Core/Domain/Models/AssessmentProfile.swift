import Foundation
import SwiftUI

// AssessmentProfile model (scaffold)
// TODO: move question lists into JSON screeners under Features/Screening/Data/Screeners

public struct AssessmentProfile: Identifiable {
    public let id = UUID()
    public let title: String
    public let subtitle: String
    public let description: String
    public let badge: String?
    public let color: Color
    public let questions: [Question]
}
