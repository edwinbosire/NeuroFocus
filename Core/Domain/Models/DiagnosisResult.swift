import Foundation
import SwiftUI

// DiagnosisResult / ScreenerResult scaffold

public struct CategoryInsight: Identifiable {
    public let id = UUID()
    public let category: Question.Category
    public let score: Int
    public let maxScore: Int
    public let insightText: String
    public let clinicianNote: String
}

public struct DiagnosisResult {
    public let score: Int
    public let category: String
    public let description: String
    public let color: Color
    public let insights: [CategoryInsight]
}
