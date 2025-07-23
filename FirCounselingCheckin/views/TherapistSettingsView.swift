import SwiftUI

struct TherapistSettingsView: View {
	var body: some View {
		HStack {
			Image(systemName: "person.circle.fill")
				.resizable()
				.frame(width: 50, height: 50)
				.foregroundStyle(.cyan)
			
			VStack(alignment: .leading) {
				TextField("Name", text: .constant("Jen Pond"))
					.textFieldStyle(.roundedBorder)
				
				TextField("api key", text: .constant("fjnsjdhbfa"))
					.textFieldStyle(.roundedBorder)
			}
		}
		.contextMenu {
			// edit profile picture
			
			Button(role: .destructive) {
				print("delete me")
			} label: {
				Label("Delete", systemImage: "trash")
			}
		}
	}
}

#Preview {
	TherapistSettingsView()
}
