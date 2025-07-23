import Foundation
import SwiftData

@Model
final class Therapist {
	var name: String
	var image: Data
	
	init(name: String, image: Data) {
		self.name = name
		self.image = image
	}
}
