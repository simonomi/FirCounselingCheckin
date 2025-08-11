import SwiftUI

struct SettingsSheet: View {
	@Binding var therapists: [Therapist]
	@Binding var isPresented: Bool
	
	@State private var isAuthenticated = false
	
	var body: some View {
		NavigationStack {
			Group {
				if isAuthenticated {
					SettingsView(therapists: $therapists)
				} else {
					PasswordView {
						withAnimation {
							isAuthenticated = true
						}
					} onFailure: {
						withAnimation {
							isPresented = false
						}
					}
				}
			}
			.navigationTitle("Settings")
		}
	}
}

#Preview {
	Text("hi")
		.sheet(isPresented: .constant(true)) {
			SettingsSheet(therapists: .constant([]), isPresented: .constant(true))
		}
}
