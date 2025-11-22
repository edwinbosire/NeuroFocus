import SwiftUI

/// PrimaryButton migrated from ContentView.swift
/// TODO: Extract styling into DesignSystem and reuse across features.

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var color: Color = .blue
    var icon: String? = nil

    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon { Image(systemName: icon) }
                Text(title).fontWeight(.bold)
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .cornerRadius(16)
        }
    }
}
