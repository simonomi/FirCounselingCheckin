import Foundation

struct PushoverErrorResponse: Decodable {
	var status: Int
	var request: UUID
	var errors: [String]
}
