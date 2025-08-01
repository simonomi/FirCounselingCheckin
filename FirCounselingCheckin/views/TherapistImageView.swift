import SwiftUI

struct TherapistImageView: View {
	var therapist: Therapist
	
	var body: some View {
		Group {
			if let image = therapist.image {
				image
					.resizable()
					.clipShape(.circle)
			} else {
				Image(systemName: "person.circle.fill")
					.resizable()
					.foregroundStyle(.cyan)
			}
		}
		.frame(width: 50, height: 50)
	}
}

#if DEBUG
#Preview {
	TherapistImageView(therapist: .preview)
}
#endif
