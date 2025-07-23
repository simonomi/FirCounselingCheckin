import SwiftUI
import SwiftData

struct ContentView: View {
	@State private var clientName = ""
	@State private var therapist: Int? = nil
	@State private var checkedInAlert = false
	@State private var inSettings = false
	
	var body: some View {
		NavigationStack {
			Form {
				TextField("Name (optional)", text: $clientName)
				
				Picker("Therapist", selection: $therapist) {
					Text("No selection")
						.foregroundStyle(.secondary)
						.tag(nil as Int?)
					
					TherapistView(name: "Jen Pond").tag(1)
					TherapistView(name: "Cooler Jen Pond").tag(2)
					TherapistView(name: "Less Cool Jen Pond").tag(3)
					TherapistView(name: "Jennifer Pond").tag(4)
					TherapistView(name: "Jennifer Pondifer").tag(5)
					TherapistView(name: "867-5309/Jenny Pond").tag(6)
					TherapistView(name: "Jen Pondland").tag(7)
					TherapistView(name: "Jen Pond...?").tag(8)
					TherapistView(name: "Pond, Jen Pond").tag(9)
					TherapistView(name: "A New Jen Pond").tag(10)
					TherapistView(name: "Jen Pond Strikes Back").tag(11)
					TherapistView(name: "Jen Pond: The Squeakquel").tag(12)
					TherapistView(name: "Jen Pond: Chipwrecked").tag(12)
				}
				.pickerStyle(.inline)
				
				Section {
					Button("Check in") {
						checkedInAlert = true
					}
					.font(.title)
					.buttonStyle(.borderedProminent)
					.frame(maxWidth: .infinity)
					.listRowBackground(EmptyView())
					.disabled(therapist == 0)
				}
			}
			.navigationTitle("Check in")
			.alert("You have been checked in", isPresented: $checkedInAlert) {
				Button("Ok") {
					withAnimation {
						clientName = ""
						therapist = 0
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
