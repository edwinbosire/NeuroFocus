import SwiftUI

/// OptionButton migrated from ContentView.swift
struct OptionButton: View {
    let title: String
	let tint: Color
    let action: () -> Void
	@State private var isSelected: Bool

	init(title: String, isSelected: Bool = false, tint: Color, action: @escaping () -> Void) {
		self.title = title
		self.isSelected = isSelected
		self.tint = tint
		self.action = action
	}

	var body: some View {
		Button(action: {
			isSelected.toggle()
			action()
		}) {
			HStack {
				Text(title)
					.font(.body)
					.fontWeight(.medium)
					.foregroundColor(Color.primary)
					.frame(maxWidth: .infinity, alignment: .leading)

				Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
					.foregroundColor(isSelected ? tint : .gray.opacity(0.5))
					.contentTransition(.symbolEffect(.replace))
			}
            .padding()
			.frame(maxHeight: .infinity)
//            .background(Color(UIColor.secondarySystemBackground))
        }
    }
}
