import Foundation
import SwiftData
import SwiftUI

@Model
final class Therapist: Identifiable {
	var id: ID
	var sortIndex: Int
	
	var name: String
	var userToken: String
	
	@Attribute(.externalStorage)
	var imageData: Data?
	
	struct ID: Hashable, Equatable, Codable {
		var uuid: UUID
		
		init() {
			uuid = UUID()
		}
	}
	
	var image: Image? {
		imageData
			.flatMap { UIImage(data: $0) }
			.map { Image(uiImage: $0) }
	}
	
	private init(sortOrder: Int) {
		id = ID()
		self.sortIndex = sortOrder
		
		name = "New Therapist"
		userToken = ""
		imageData = nil
	}
	
	convenience init(after other: Therapist?) {
		self.init(sortOrder: other.map { $0.sortIndex + 1 } ?? 0)
	}
	
#if DEBUG
	static var preview: Therapist { Therapist(after: nil) }
#endif
}
