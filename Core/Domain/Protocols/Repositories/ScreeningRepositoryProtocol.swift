import Foundation

// ScreeningRepository protocol

public protocol ScreeningRepositoryProtocol {
    func saveResult(_ result: DiagnosisResult) async throws
    func loadResults() async throws -> [DiagnosisResult]
}
