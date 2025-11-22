import Foundation

// Simple in-memory mock repository for tests and early migration.

final class MockScreeningRepository: ScreeningRepositoryProtocol {
    private var store: [DiagnosisResult] = []

    func saveResult(_ result: DiagnosisResult) async throws {
        store.append(result)
    }

    func loadResults() async throws -> [DiagnosisResult] { store }
}
