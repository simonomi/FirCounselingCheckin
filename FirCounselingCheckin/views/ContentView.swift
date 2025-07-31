import SwiftUI
import SwiftData

struct ContentView: View {
	@State private var clientName = ""
	@State private var selectedTherapist: Therapist.ID? = nil
	@State private var checkedInAlert = false
	@State private var inSettings = false
	
	@Query(sort: \Therapist.sortIndex, animation: .default) private var therapists: [Therapist]
	
	var body: some View {
		NavigationStack {
			Form {
				TextField("Name (optional)", text: $clientName)
				
				Picker("Therapist", selection: $selectedTherapist) {
					Text("No selection")
						.foregroundStyle(.secondary)
						.tag(nil as Therapist.ID?)
					
					ForEach(therapists) { therapist in
						HStack {
							TherapistImageView(therapist: therapist)
							
							Text(therapist.name)
						}
						.tag(therapist.id)
					}
				}
				.pickerStyle(.inline)
				
				Section {
					Button("Check in") {
						print("TODO: actually check in")
						
						checkedInAlert = true
					}
					.font(.title)
					.buttonStyle(.borderedProminent)
					.frame(maxWidth: .infinity)
					.listRowBackground(EmptyView())
					.disabled(selectedTherapist == nil)
				}
			}
			.navigationTitle("Check in")
			.alert("You have been checked in", isPresented: $checkedInAlert) {
				Button("Ok") {
					withAnimation {
						clientName = ""
						selectedTherapist = nil
						checkedInAlert = false
					}
				}
			}
			.toolbar {
				ToolbarItem {
					Button {
						withAnimation {
							inSettings = true
						}
					} label: {
						Label("Settings", systemImage: "gear")
					}
				}
			}
			.sheet(isPresented: $inSettings) {
				SettingsSheet(isPresented: $inSettings)
			}
		}
	}
}

#Preview {
	ContentView()
}
