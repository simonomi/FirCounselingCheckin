enum PushoverError: Error, CustomStringConvertible {
	case network, server
	case decoding(String?)
	case invalidRequest([String])
	
	var description: String {
		switch self {
			case .network:
				"Network error: check Wi-Fi connection"
			case .server:
				"Push notification servers are down, try again later"
			case .decoding(nil):
				"Server response contains invalid UTF-8, try again later"
			case .decoding(let string?):
				"Invalid server response: \(string), try again later"
			case .invalidRequest(let messages):
				"Pushover error: \(messages.map { "'\($0)'" }.joined(separator: ", "))"
		}
	}
}
