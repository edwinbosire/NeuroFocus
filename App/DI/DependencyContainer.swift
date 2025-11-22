// DependencyContainer.swift
// Lightweight DI container for initial wiring. Keep simple and test-friendly.

import Foundation

final class DependencyContainer {
    static let shared = DependencyContainer()

    // Singletons (simple DI)
    public var screeningRepository: any ScreeningRepositoryProtocol
    public var pdfService: PDFServiceProtocol

    private init() {
        // Default registrations for early migration
        self.screeningRepository = MockScreeningRepository()
        self.pdfService = PDFRenderer()
    }
}
