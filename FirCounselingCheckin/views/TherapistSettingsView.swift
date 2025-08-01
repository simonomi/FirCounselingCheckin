import SwiftUI
import PhotosUI

struct TherapistSettingsView: View {
	@State private var selectedPhoto: PhotosPickerItem? = nil
	
	var therapist: Therapist
	
	var body: some View {
		@Bindable var therapist = therapist
		
		HStack {
			PhotosPicker(selection: $selectedPhoto) {
				TherapistImageView(therapist: therapist)
			}
			.photosPickerStyle(.presentation)
			.buttonStyle(.borderless)
			.onChange(of: selectedPhoto) { _, newValue in
				guard let newValue else { return }
				Task {
					therapist.imageData = try! await newValue.loadTransferable(type: Data.self)
				}
			}
			
			VStack(alignment: .leading) {
				TextField("Name", text: $therapist.name)
					.textFieldStyle(.roundedBorder)
				
				TextField("Pushover user key", text: $therapist.userToken)
					.textInputAutocapitalization(.never)
					.textFieldStyle(.roundedBorder)
			}
		}
	}
}

#if DEBUG
#Preview {
	TherapistSettingsView(therapist: .preview)
}
#endif
