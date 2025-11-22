import Foundation
import UIKit

/// PDFRenderer: renders a simple clinical-style PDF from ReportData.
public final class PDFRenderer: PDFServiceProtocol {
    public init() {}

    public func createPDF(from report: ReportData) -> Data {
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = [kCGPDFContextTitle: report.title, kCGPDFContextAuthor: "NeuroFocus"] as [String: Any]
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        return renderer.pdfData { context in
            context.beginPage()
            let titleAttr: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 22)]
            let bodyAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 11)]
            let boldAttr: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 11)]

            report.title.draw(at: CGPoint(x: 50, y: 50), withAttributes: titleAttr)

            var yOffset = 90.0
            "Screener Used: \(report.title) (\(report.subtitle))".draw(at: CGPoint(x: 50, y: yOffset), withAttributes: boldAttr)
            yOffset += 30

            "Result Category: \(report.resultCategory)".draw(at: CGPoint(x: 50, y: yOffset), withAttributes: boldAttr)
            yOffset += 20

            report.resultDescription.draw(in: CGRect(x: 50, y: yOffset, width: 500, height: 40), withAttributes: bodyAttr)
            yOffset += 50

            "Domain Breakdown:".draw(at: CGPoint(x: 50, y: yOffset), withAttributes: boldAttr)
            yOffset += 20

            for line in report.insights {
                line.draw(at: CGPoint(x: 50, y: yOffset), withAttributes: bodyAttr)
                yOffset += 18
            }

            yOffset += 20
            "Response Transcript:".draw(at: CGPoint(x: 50, y: yOffset), withAttributes: boldAttr)
            yOffset += 20

            for q in report.questions {
                let qLine = "\(q.index). \(q.text)"
                let aLine = "   Response: \(q.answer)"
                qLine.draw(at: CGPoint(x: 50, y: yOffset), withAttributes: bodyAttr)
                yOffset += 15
                aLine.draw(at: CGPoint(x: 50, y: yOffset), withAttributes: [.font: UIFont.italicSystemFont(ofSize: 10), .foregroundColor: UIColor.darkGray])
                yOffset += 25
                if yOffset > Double(pageRect.height - 120) {
                    context.beginPage()
                    yOffset = 60
                }
            }

            // Footer disclaimer
            report.disclaimer.draw(at: CGPoint(x: 50, y: pageRect.height - 60), withAttributes: [.font: UIFont.italicSystemFont(ofSize: 9), .foregroundColor: UIColor.gray])
        }
    }
}
