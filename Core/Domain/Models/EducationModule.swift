import Foundation
import SwiftUI

// EducationModule scaffold

public struct EducationModule: Identifiable {
    public let id = UUID()
    public let title: String
    public let subtitle: String
    public let icon: String
    public let content: String
    public let color: Color
    public let tag: String?
}
