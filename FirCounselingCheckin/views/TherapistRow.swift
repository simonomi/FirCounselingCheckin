import SwiftUI

struct TherapistRow: View {
	@ObservedObject
	var therapist: Therapist
	
	var body: some View {
		HStack {
			TherapistImageView(therapist: therapist)
			
			Text(therapist.name)
			
			if therapist.userToken.isEmpty {
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
