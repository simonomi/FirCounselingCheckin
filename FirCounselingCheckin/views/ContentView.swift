import SwiftUI
import SwiftData

struct ContentView: View {
	@State private var clientName = ""
	@State private var selectedTherapist: Therapist.ID? = nil
	
	@State private var checkingIn = false
	@State private var askForName = false
	@State private var checkedInAlert = false
	
	@State private var errorAlert = false
	@State private var errorMessage: String?
	
	@State private var inSettings = false
	
	@Binding var therapists: [Therapist]
	
	var body: some View {
		NavigationStack {
			Form {
				Section {
					Text(
						"""
						Welcome!
						Please select your therapist below to check in
						"""
					)
					.font(.largeTitle)
					.bold()
					.frame(maxWidth: .infinity)
					
					Spacer()
					
					Text(
						"""
						Bienvenido!
						Seleccione su terapeuta para registrarse
						"""
					)
					.font(.largeTitle)
					.frame(maxWidth: .infinity)
				}
				.multilineTextAlignment(.center)
				.listRowInsets(EdgeInsets())
				.listRowBackground(EmptyView())
				.listRowSeparator(.hidden)
				
				Picker("", selection: $selectedTherapist) {
					Text("No selection")
						.foregroundStyle(.secondary)
						.tag(nil as Therapist.ID?)
					
					ForEach(therapists) { therapist in
						TherapistRow(therapist: therapist)
					}
				}
				.pickerStyle(.inline)
				
				Section {
					Group {
						if checkingIn {
							ProgressView()
								.id(UUID())
						} else {
							Button("Check in", action: beginCheckIn)
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
			.alert("Name (optional)", isPresented: $askForName) {
				TextField("Client", text: $clientName)
				Button("Cancel", action: resetForm)
				Button("OK", action: checkIn)
			}
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
				SettingsSheet(therapists: $therapists, isPresented: $inSettings)
			}
		}
	}
	
	func beginCheckIn() {
		checkingIn = true
		askForName = true
	}
	
	func checkIn() {
		guard let selectedTherapist,
			  let therapist = therapists.first(where: { $0.id == selectedTherapist })
		else {
			resetForm()
			return
		}
		
		Task {
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
	ContentView(therapists: .constant([]))
}
