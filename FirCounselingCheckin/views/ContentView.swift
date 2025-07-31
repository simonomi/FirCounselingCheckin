import SwiftUI
import SwiftData

struct ContentView: View {
	@Environment(\.modelContext) private var modelContext
	
	@State private var clientName = ""
	@State private var selectedTherapist: Therapist.ID? = nil
	
	@State private var checkingIn = false
	@State private var checkedInAlert = false
	
	@State private var errorAlert = false
	@State private var errorMessage: String?
	
	@State private var inSettings = false
	
	@Query(sort: \Therapist.sortIndex, animation: .default) private var therapists: [Therapist]
	
	var body: some View {
		NavigationStack {
			Form {
				Section {
					TextField("Name (optional)", text: $clientName)
				}
				
				Picker("Therapist", selection: $selectedTherapist) {
					Text("No selection")
						.foregroundStyle(.secondary)
						.tag(nil as Therapist.ID?)
					
					ForEach(therapists) { therapist in
						HStack {
							TherapistImageView(therapist: therapist)
							
							Text(therapist.name)
							
							if therapist.userToken == "" {
								Label("NO USER KEY", systemImage: "exclamationmark.triangle.fill")
									.foregroundStyle(.white)
									.padding(7)
									.background(.red)
									.clipShape(RoundedRectangle(cornerRadius: 15))
									.frame(maxWidth: .infinity, alignment: .trailing)
							}
						}
						.tag(therapist.id)
					}
				}
				.pickerStyle(.inline)
				
				Section {
					Group {
						if checkingIn {
							ProgressView()
								.id(UUID())
						} else {
							Button("Check in", action: checkIn)
							.font(.title)
							.buttonStyle(.borderedProminent)
							.disabled(selectedTherapist == nil)
							.animation(.snappy, value: selectedTherapist)
						}
					}
					.frame(maxWidth: .infinity)
					.listRowBackground(EmptyView())
				}
			}
			.navigationTitle("Check in")
			.alert("You have been checked in", isPresented: $checkedInAlert) {
				Button("OK", action: resetForm)
			}
			.alert(
				errorMessage ?? "An unknown error has occured, please try again later",
				isPresented: $errorAlert
			) {
				Button("OK") {
					checkingIn = false
					errorMessage = nil
					errorAlert = false
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
	
	func checkIn() {
		guard let selectedTherapist,
			  let therapist = modelContext.model(for: selectedTherapist)
		else {
			return
		}
		
		Task {
			checkingIn = true
			
			let clientName = if clientName.isEmpty {
				"Your next client"
			} else {
				clientName
			}
			
			do throws(PushoverError) {
				try await sendPushNotification(
					to: therapist,
					title: "Fir Check-in",
					message: "\(clientName) is here"
				)
				
				checkedInAlert = true
			} catch {
				errorMessage = error.description
				errorAlert = true
			}
		}
	}
	
	func resetForm() {
		withAnimation(.snappy) {
			checkingIn = false
			clientName = ""
			selectedTherapist = nil
			checkedInAlert = false
		}
	}
}

#Preview {
	ContentView()
}
