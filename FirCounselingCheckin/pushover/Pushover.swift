import Foundation

fileprivate let apiToken = "ajr9bs6njouwuzwjp9qjgttgb6jhp4"
fileprivate let pushoverURL = URL(string: "https://api.pushover.net/1/messages.json")!

@discardableResult
func sendPushNotification(to therapist: Therapist, title: String, message: String) async throws(PushoverError) -> PushoverResponse {
	var request = URLRequest(url: pushoverURL)
	
	let userToken = therapist.userToken.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
	let title = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
	let message = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
	
	request.httpMethod = "POST"
	request.httpBody = "token=\(apiToken)&user=\(userToken)&title=\(title)&message=\(message)".data(using: .utf8)
	
	let (data, response): (Data, URLResponse)
	do {
		(data, response) = try await URLSession.shared.data(for: request)
	} catch {
		throw .network
	}
	
	guard let httpResponse = response as? HTTPURLResponse else {
		throw .network
	}
	
	switch httpResponse.statusCode {
		case 200:
			do {
				return try JSONDecoder().decode(PushoverResponse.self, from: data)
			} catch {
				throw .decoding(String(data: data, encoding: .utf8))
			}
		case 500..<600:
			throw .server
		default:
			let pushoverErrorResponse: PushoverErrorResponse
			do {
				pushoverErrorResponse = try JSONDecoder().decode(PushoverErrorResponse.self, from: data)
			} catch {
				throw .decoding(String(data: data, encoding: .utf8))
			}
			
			throw .invalidRequest(pushoverErrorResponse.errors)
	}
}
