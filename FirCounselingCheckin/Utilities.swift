import SwiftData
import Foundation

extension ModelContext {
	func model(for id: Therapist.ID) -> Therapist? {
		let predicate = #Predicate<Therapist> { $0.id.uuid == id.uuid }
		let therapists = try! fetch(FetchDescriptor(predicate: predicate))
		
		precondition(therapists.count <= 1, "two therapists have the same UUID??")
		
		return therapists.first
	}
}
