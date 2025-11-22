import SwiftUI

/// OptionButton migrated from ContentView.swift
struct OptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(Color.primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.blue)
                } else {
                    Image(systemName: "circle").foregroundColor(.gray.opacity(0.5))
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
        }
    }
}
