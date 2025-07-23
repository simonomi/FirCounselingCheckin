import SwiftUI
import SwiftData

@main
struct FirCounselingCheckinApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
		}
		.modelContainer(for: Therapist.self)
	}
}
