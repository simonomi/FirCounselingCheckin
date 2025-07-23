import SwiftUI

struct PasswordView: View {
	@AppStorage("settingsPassword") private var settingsPassword: String?
	
	@State private var passwordInput = ""
	@FocusState private var isFocused: Bool
	
	var successAction: () -> Void
	var failureAction: () -> Void
	
	init(
		onSuccess successAction: @escaping () -> Void,
		onFailure failureAction: @escaping () -> Void
	) {
		self.successAction = successAction
		self.failureAction = failureAction
	}
	
	var body: some View {
		Form {
			TextField("Password", text: $passwordInput)
				.focused($isFocused)
				.onAppear {
					withAnimation {
						isFocused = true
					}
				}
			
			Button("Submit") {
				if passwordInput == settingsPassword {
					successAction()
				} else {
					failureAction()
				}
				
				withAnimation {
					passwordInput = ""
				}
			}
			.onAppear {
				if settingsPassword == nil {
					successAction()
				}
			}
		}
	}
}

#Preview {
	Text("hi")
		.sheet(isPresented: .constant(true)) {
			PasswordView {
				print("success")
			} onFailure: {
				print("failure")
			}
		}
}
