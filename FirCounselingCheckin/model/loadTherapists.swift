import Foundation

fileprivate let therapistsPath = URL.documentsDirectory.appending(component: "therapists.json")
fileprivate let logPath = URL.documentsDirectory.appending(component: "logs.txt")

struct LoadingError: Error {}

func loadTherapists() throws(LoadingError) -> [Therapist] {
	// if this fails, its probably because the file doesn't exist,
	// so just start with nothing
	guard let data = try? Data(contentsOf: therapistsPath) else {
		return []
	}
	
	do {
		return try JSONDecoder().decode([Therapist].self, from: data)
	} catch {
		log(error)
		throw LoadingError()
	}
}

struct SavingError: Error {}

func saveTherapists(_ therapists: [Therapist]) throws(SavingError) {
	do {
		let data = try JSONEncoder().encode(therapists)
		try data.write(to: therapistsPath)
	} catch {
		log(error)
		throw SavingError()
	}
}

fileprivate func log(_ error: some Error) {
	let errorMessage = String(describing: error)
	
	let existingLogs = try? String(contentsOf: logPath)
	
	let newLogs = existingLogs.map { $0 + errorMessage } ?? errorMessage
	
	try? Data(newLogs.utf8).write(to: logPath)
}
