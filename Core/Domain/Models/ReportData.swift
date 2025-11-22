import Foundation
import SwiftUI

/// Lightweight report DTO used to generate PDFs without depending on feature types.
public struct ReportQuestion: Codable {
    public let index: Int
    public let text: String
    public let answer: String
}

public struct ReportData: Codable {
    public let title: String
    public let subtitle: String
    public let resultCategory: String
    public let resultDescription: String
    public let insights: [String]
    public let questions: [ReportQuestion]
    public let disclaimer: String
}
