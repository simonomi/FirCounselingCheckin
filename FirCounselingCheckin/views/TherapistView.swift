import SwiftUI

struct TherapistView: View {
	var name: String
	
	let therapistImageSize: CGFloat = 50
	
	var body: some View {
		HStack {
			Image(systemName: "person.circle.fill")
				.resizable()
				.frame(width: therapistImageSize, height: therapistImageSize)
				.foregroundStyle(.cyan)
			
			Text(name)
		}
	}
}

#Preview {
	TherapistView(name: "Jen Pond")
}
