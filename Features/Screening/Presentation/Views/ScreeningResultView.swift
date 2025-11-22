import SwiftUI

struct ScreeningResultView: View {
    @ObservedObject var viewModel: AssessmentViewModel

    var body: some View {
        let result = viewModel.getResult()

        ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 10) {
                    ZStack {
                        Circle().fill(result.color.opacity(0.2)).frame(width: 100, height: 100)
                        Image(systemName: "brain").font(.system(size: 40)).foregroundColor(result.color)
                    }
                    .padding(.top, 20)
                    Text(result.category).font(.title).fontWeight(.heavy).foregroundColor(result.color)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Analysis").font(.headline)
                    Text(result.description).font(.subheadline).foregroundColor(.secondary)
                }
                .padding().background(Color(UIColor.secondarySystemBackground)).cornerRadius(16)

                VStack(alignment: .leading, spacing: 20) {
                    Text("Domain Breakdown").font(.title3).fontWeight(.bold)
                    ForEach(result.insights) { insight in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(insight.category.rawValue).font(.headline)
                                Spacer()
                                Text("\(insight.score)/\(insight.maxScore)").font(.caption).fontWeight(.bold).foregroundColor(.secondary)
                            }
                            ProgressBar(value: CGFloat(insight.score) / CGFloat(insight.maxScore), color: result.color).frame(height: 6)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(insight.insightText).font(.subheadline).fontWeight(.medium)
                                Text(insight.clinicianNote).font(.caption).italic().foregroundColor(.secondary).padding(.top, 2)
                            }
                            .padding(.top, 4)
                        }
                        .padding().background(Color(UIColor.systemBackground)).cornerRadius(12).shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                }
                .padding().background(Color(UIColor.secondarySystemBackground).opacity(0.5)).cornerRadius(16)

                PrimaryButton(title: "Export Clinical Report (PDF)", action: { viewModel.generatePDF() }, color: .green, icon: "doc.text.fill")
                Spacer(minLength: 20)
                Button("Take Another Assessment") { viewModel.reset() }.font(.subheadline).foregroundColor(.secondary).padding(.bottom)
            }
            .padding(24)
        }
        .sheet(isPresented: $viewModel.showShareSheet) {
            if let data = viewModel.reportData { ShareSheet(items: [data]) }
        }
    }
}
