import Foundation
import SwiftUI

/// Concrete ScreeningRepository that persists results as JSON using FileStore.
final class ScreeningRepository: ScreeningRepositoryProtocol {
	func saveResult(_ result: DiagnosisResult) async throws {

	}
	
	func loadResults() async throws -> [DiagnosisResult] {
		return []
	}
	
    private let store: FileStore
    private let filename = "screening_results.json"

    init(store: FileStore = FileStore()) {
        self.store = store
    }

    // DTOs used for persistence
    private struct InsightDTO: Codable {
        let category: String
        let score: Int
        let maxScore: Int
        let insightText: String
        let clinicianNote: String
    }

    private struct QuestionResponseDTO: Codable {
        let index: Int
        let text: String
        let answer: String
    }

    private struct ScreenerRecord: Codable {
        let id: UUID
        let date: Date
        let assessmentTitle: String
        let score: Int
        let category: String
        let description: String
        let insights: [InsightDTO]
        let questions: [QuestionResponseDTO]
    }

    func saveResult(_ result: DiagnosisResult, transcript: [(index: Int, text: String, answer: String)]? = nil) async throws {
        // Map DiagnosisResult -> ScreenerRecord (best-effort)
        let insights = result.insights.map { insight in
            InsightDTO(category: insight.category.rawValue, score: insight.score, maxScore: insight.maxScore, insightText: insight.insightText, clinicianNote: insight.clinicianNote)
        }

        let questions: [QuestionResponseDTO]
        if let transcript = transcript {
            questions = transcript.map { QuestionResponseDTO(index: $0.index, text: $0.text, answer: $0.answer) }
        } else {
            questions = []
        }

        let record = ScreenerRecord(id: UUID(), date: Date(), assessmentTitle: result.category, score: result.score, category: result.category, description: result.description, insights: insights, questions: questions)

        // Load existing records, append, and save
        var existing: [ScreenerRecord] = []
        if let loaded: [ScreenerRecord] = try store.load([ScreenerRecord].self, from: filename) {
            existing = loaded
        }
        existing.append(record)
        try store.save(existing, to: filename)
    }

    struct LoadedResult {
        let id: UUID
        let date: Date
        let assessmentTitle: String
        let diagnosis: DiagnosisResult
        let transcript: [(index: Int, text: String, answer: String)]
    }

    func loadResultsWithTranscripts() async throws -> [LoadedResult] {
        guard let records: [ScreenerRecord] = try store.load([ScreenerRecord].self, from: filename) else { return [] }

        return records.map { record in
            let insights = record.insights.map { dto in
                let category = Question.Category(rawValue: dto.category) ?? .generalAttention
                return CategoryInsight(category: category, score: dto.score, maxScore: dto.maxScore, insightText: dto.insightText, clinicianNote: dto.clinicianNote)
            }
            let diagnosis = DiagnosisResult(score: record.score, category: record.category, description: record.description, color: .blue, insights: insights)
            let transcript = record.questions.map { (index: $0.index, text: $0.text, answer: $0.answer) }
            return LoadedResult(id: record.id, date: record.date, assessmentTitle: record.assessmentTitle, diagnosis: diagnosis, transcript: transcript)
        }
    }
}
