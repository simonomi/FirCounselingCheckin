import SwiftUI
import PhotosUI

struct TherapistSettingsView: View {
	@State private var selectedPhoto: PhotosPickerItem? = nil
	
	@Binding var therapists: [Therapist]
	
	@ObservedObject
	var therapist: Therapist
	
	var body: some View {
		HStack {
			PhotosPicker(selection: $selectedPhoto) {
				TherapistImageView(therapist: therapist)
			}
//			.photosPickerStyle(.presentation) // only available >=iOS 17
			.buttonStyle(.borderless)
			.onChange(of: selectedPhoto) { newValue in
				guard let newValue else { return }
				Task {
					therapist.imageData = try! await newValue.loadTransferable(type: Data.self)
					try! saveTherapists(therapists)
				}
			}
			
			VStack(alignment: .leading) {
				TextField("Name", text: $therapist.name)
					.textFieldStyle(.roundedBorder)
					.onChange(of: therapist.name) { _ in
						try! saveTherapists(therapists)
					}
				
				TextField("Pushover user key", text: $therapist.userToken)
					.textInputAutocapitalization(.never)
					.textFieldStyle(.roundedBorder)
					.onChange(of: therapist.userToken) { _ in
						try! saveTherapists(therapists)
					}
			}
		}
	}
}
