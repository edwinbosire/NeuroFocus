import Foundation

/// Simple file-based JSON store for the app Documents directory.
final class FileStore {
    private let directory: URL

    init(directory: URL? = nil) {
        if let directory = directory {
            self.directory = directory
        } else {
            self.directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
    }

    private func fileURL(for filename: String) -> URL {
        return directory.appendingPathComponent(filename)
    }

    /// Save any Codable value to a file (overwrites existing file).
    func save<T: Codable>(_ value: T, to filename: String) throws {
        let url = fileURL(for: filename)
        let data = try JSONEncoder().encode(value)
        try data.write(to: url, options: [.atomic])
    }

    /// Load a Codable value from a file.
    func load<T: Codable>(_ type: T.Type, from filename: String) throws -> T? {
        let url = fileURL(for: filename)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        let data = try Data(contentsOf: url)
        let value = try JSONDecoder().decode(T.self, from: data)
        return value
    }
}
