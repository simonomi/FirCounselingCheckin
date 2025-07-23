import SwiftUI
import SwiftData

struct ContentView: View {
	@Environment(\.modelContext) private var modelContext
	@Environment(\.colorScheme) private var colorScheme
	
	@Query private var items: [Item]
	
	let dateStyle: Date.FormatStyle = .dateTime.day().month(.wide)
	
	var defaultListRowBackground: Color {
		switch colorScheme {
			case .light:
				Color(uiColor: .systemBackground)
			case .dark:
				Color(uiColor: .secondarySystemBackground)
			@unknown default:
				Color(uiColor: .systemBackground)
		}
	}
	
	var body: some View {
		NavigationStack {
			List {
//				Section(Date.now.formatted(dateStyle)) {
//					Text("No clients yet")
//						.frame(maxWidth: .infinity)
//						.foregroundStyle(.secondary)
//				}
				
				Section(Date.now.formatted(dateStyle)) {
					listRow(for: "Eloise", secondsAgo: 0)
					
					listRow(for: "Sofia", secondsAgo: 60)
					
					listRow(for: "Bethany", secondsAgo: 300)
				}
				
				Section(Date.now.advanced(by: -86400).formatted(dateStyle)) {
					listRow(for: "August", secondsAgo: 500)
					
					listRow(for: "Penelope", secondsAgo: 2000)
				}
			}
			.listRowSpacing(8)
		}
	}
	
	func listRow(for name: String, secondsAgo: TimeInterval) -> some View {
		let background = if secondsAgo < 5 * 60 {
			defaultListRowBackground.mix(with: .green, by: 0.25)
		} else {
			defaultListRowBackground
		}
		
		return HStack {
			Text("\(name) is here")
			
			Spacer()
			
			if secondsAgo < 60 {
				Text("now")
					.foregroundStyle(.green)
			} else if secondsAgo < 5 * 60 {
				let minutesAgo = Int(secondsAgo / 60)
				Text("\(minutesAgo) minute\(minutesAgo == 1 ? "" : "s") ago")
					.foregroundStyle(.orange)
			} else {
				Text(.now.addingTimeInterval(-secondsAgo), style: .time)
					.foregroundStyle(.secondary)
			}
		}
//		.listRowBackground(background)
	}
}

#Preview {
	ContentView()
		.modelContainer(for: Item.self, inMemory: true)
}
