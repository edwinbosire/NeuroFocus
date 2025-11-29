import SwiftUI


enum ProgressViewStyle {
	case bar
	case inverseBar
}

struct ProgressBar: View {
	var value: CGFloat
	let color: Color
	let style: ProgressViewStyle

	init(value: CGFloat, color: Color = .blue, style: ProgressViewStyle = .bar) {
		self.value = max(0.0, min(value, 1.0))
		self.color = color
		self.style = style
	}

	var body: some View {
		switch style {
			case .bar:
				ProgressViewBar(value: value, color: color)
			case .inverseBar:
				ProgressViewInverseBar(value: value, color: color)
					.frame(height: 10.0)
		}
	}
}

struct ProgressViewBar: View {
	var value: CGFloat
	var color: Color = .blue

	var body: some View {
		ZStack(alignment: .leading) {
			Capsule()
				.frame(maxWidth: .infinity)
				.background(Color.gray)
				.opacity(0.1)
				.overlay(alignment: .leading) {
					RoundedRectangle(cornerRadius: 8.0)
						.foregroundStyle(color.gradient)
						.containerRelativeFrame(.horizontal, alignment: .leading) { size, axis in
							(size - 32) *  value
						}
						.animation(.bouncy, value: value)
				}
				.clipped()
		}
		.frame(height: 6.0)
	}
}

struct ProgressViewInverseBar: View {
	var value: CGFloat
	var color: Color = .blue

	var body: some View {
		ZStack(alignment: .leading) {
			Capsule()
				.frame(maxWidth: .infinity)
				.opacity(0.1)
				.frame(height: 2.0)

			Capsule()
				.foregroundStyle(color.gradient)
				.clipped()
				.containerRelativeFrame(.horizontal, alignment: .leading) { size, axis in
					(size - 32) *  value
				}
				.animation(.bouncy, value: value)
				.frame(height: 10.0)
		}

	}
}


#Preview {

	@Previewable @State var value: CGFloat = 0.1

	VStack(spacing: 20) {
		GroupBox("ProgressBar \(value * 10.0, format: .number)") {
			ProgressBar(value: value)

		}

		GroupBox("Inverse ProgressBar \(value * 10.0, format: .number)") {
			ProgressBar(value: value, color: .green, style: .inverseBar)
		}

		ProgressBar(value: value, color: .pink, style: .inverseBar)
			.padding(.horizontal)


		GroupBox {
			   HStack {
				   Button(action: {withAnimation { value -= 0.1 }}) {
					   Text("-")
						   .frame(maxWidth: .infinity)
						   .font(.headline)
						   .foregroundStyle(.white)
						   .padding(.vertical, 4)
						   .background(Color.red.gradient, in: Capsule())
				   }

				   Button(action: {withAnimation { value += 0.1 }}) {
					   Text("+")
						   .frame(maxWidth: .infinity)
						   .font(.headline)
						   .foregroundStyle(.white)
						   .padding(.vertical, 4)
						   .background(Color.blue.gradient, in: Capsule())
				   }

			   }
		   }
	}
}
