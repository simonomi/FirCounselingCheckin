import Foundation
import SwiftData
import SwiftUI

final class Therapist: Identifiable, ObservableObject, Codable {
	@Published var id: ID
	
	@Published var name: String
	@Published var userToken: String
	
	@Published var imageData: Data?
	
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
	
	init() {
		id = ID()
		
		name = "New Therapist"
		userToken = ""
		imageData = nil
	}
	
#if DEBUG
	static var preview: Therapist { Therapist() }
#endif
	
	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		id = try container.decode(Therapist.ID.self, forKey: .id)
		name = try container.decode(String.self, forKey: .name)
		userToken = try container.decode(String.self, forKey: .userToken)
		imageData = try container.decodeIfPresent(Data.self, forKey: .imageData)
	}
	
	enum CodingKeys: CodingKey {
		case id, name, userToken, imageData
	}
	
	func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(id, forKey: .id)
		try container.encode(name, forKey: .name)
		try container.encode(userToken, forKey: .userToken)
		try container.encodeIfPresent(imageData, forKey: .imageData)
	}
}
