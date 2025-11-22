import Foundation

import Foundation

public protocol PDFServiceProtocol {
    /// Create a PDF report from the provided ReportData and return Data.
    func createPDF(from report: ReportData) -> Data
}
