import SwiftUI
import SwiftData

// TODO: add a way to see logs

struct SettingsView: View {
	@AppStorage("settingsPassword") private var settingsPassword: String = ""
	
	@State private var editingPassword = false
	
	@State private var savingError = false
	
	@Binding var therapists: [Therapist]
	
	var setPasswordLabel: String {
		if settingsPassword.isEmpty {
			"Set password"
		} else {
			"Change password"
		}
	}
	
	var body: some View {
		Form {
			Button(setPasswordLabel) {
				editingPassword = true
			}
			.alert("Settings password", isPresented: $editingPassword) {
				TextField("Password", text: $settingsPassword)
					.textInputAutocapitalization(.never)
					.submitLabel(.go)
			}
			
			Section("Therapists") {
				ForEach(therapists) { therapist in
					TherapistSettingsView(therapists: $therapists, therapist: therapist)
				}
				.onMove { sources, destination in
					therapists.move(fromOffsets: sources, toOffset: destination)
					
					do {
						try saveTherapists(therapists)
					} catch {
						savingError = true
					}
				}
				.onDelete { indices in
					withAnimation {
						therapists.remove(atOffsets: indices)
						
						do {
							try saveTherapists(therapists)
						} catch {
							savingError = true
						}
					}
				}
				.alert("Uh oh! Saving therapists failed!", isPresented: $savingError) {}
				
				Button {
					withAnimation {
						therapists.append(Therapist())
					}
				} label: {
					Label("Add therapist", systemImage: "plus")
				}
			}
		}
	}
}

#Preview {
	SettingsView(therapists: .constant([]))
}
