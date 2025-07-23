import SwiftUI

struct SettingsView: View {
	@AppStorage("settingsPassword") private var settingsPassword: String?
	
	var setPasswordLabel: String {
		if settingsPassword == nil {
			"Set password"
		} else {
			"Change password"
		}
	}
	
	var body: some View {
		Form {
			Button(setPasswordLabel) {
				print("set password")
			}
			
			Section("Therapists") {
				ForEach(0..<3) { _ in
					TherapistSettingsView()
				}
				.onDelete { indices in
					print("delete \(indices)")
				}
				
				Button {
					
				} label: {
					Label("Add therapist", systemImage: "plus")
				}
			}
		}
	}
}

#Preview {
	SettingsView()
}
