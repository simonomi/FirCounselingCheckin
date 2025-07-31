import Foundation

struct PushoverResponse: Decodable {
	var status: Int
	var request: UUID
}
