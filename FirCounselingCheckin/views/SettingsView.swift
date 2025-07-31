import SwiftUI
import SwiftData

struct SettingsView: View {
	@Environment(\.modelContext) private var modelContext
	@AppStorage("settingsPassword") private var settingsPassword: String = ""
	
	@State private var editingPassword = false
	
	@Query(sort: \Therapist.sortIndex, animation: .default) private var therapists: [Therapist]
	
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
					TherapistSettingsView(therapist: therapist)
				}
				.onMove { sources, destination in
					// this is NOT an efficient way to implement this... but who cares
					var therapistsCopy = therapists
					therapistsCopy.move(fromOffsets: sources, toOffset: destination)
					
					withAnimation {
						for (index, therapist) in therapistsCopy.enumerated() {
							therapist.sortIndex = index
						}
					}
				}
				.onDelete { indices in
					withAnimation {
						for index in indices {
							modelContext.delete(therapists[index])
						}
					}
				}
				
				Button {
					let newTherapist = Therapist(after: therapists.last)
					
					withAnimation {
						modelContext.insert(newTherapist)
					}
				} label: {
					Label("Add therapist", systemImage: "plus")
				}
			}
		}
	}
}

#Preview {
	SettingsView()
		.modelContainer(for: Therapist.self, inMemory: true)
}
