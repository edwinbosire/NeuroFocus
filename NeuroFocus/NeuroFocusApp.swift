//
//  NeuroFocusApp.swift
//  NeuroFocus
//
//  Created by Edwin Bosire on 21/11/2025.
//

import SwiftUI

@main
struct NeuroFocusApp: App {
    var body: some Scene {
        WindowGroup {
			ADHDAssessmentView()
        }
    }
}

struct ADHDAssessmentView: View {
	var body: some View {
		NavigationStack {
			TabView {
				ScreenersView()
					.tabItem { Label("Assessment", systemImage: "checklist") }

				EducationHubView()
					.tabItem { Label("Learn", systemImage: "book.fill") }
			}
			.accentColor(.blue)
		}
	}
}
