import SwiftUI
import SwiftData

@main
struct FirCounselingCheckinApp: App {
	@State private var therapists: [Therapist] = []
	
	@State private var loadingError = false
	
	var body: some Scene {
		WindowGroup {
			ContentView(therapists: $therapists)
				.alert("An unexpected error has occured while trying to load therapists", isPresented: $loadingError) {}
				.onAppear {
					do {
						therapists = try loadTherapists()
					} catch {
						loadingError = true
					}
				}
		}
	}
}
