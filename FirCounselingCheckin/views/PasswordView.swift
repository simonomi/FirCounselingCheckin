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
				.submitLabel(.go)
				.onSubmit(submitPassword)
				.focused($isFocused)
				.onAppear {
					withAnimation {
						isFocused = true
					}
				}
			
			if let settingsPassword {
				Text(settingsPassword)
			}
			
			Button("Submit", action: submitPassword)
			.onAppear {
				if settingsPassword == nil {
					successAction()
				}
			}
		}
	}
	
	func submitPassword() {
		if passwordInput == settingsPassword {
			successAction()
		} else {
			failureAction()
		}
		
		withAnimation {
			passwordInput = ""
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
