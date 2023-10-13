import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""

    func signUp() async throws {
        let authResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        
        let user = DBUser.init(auth: authResult, name: name)
        try await UserManager.shared.createUser(user: user)
    }
    
    func signIn() async throws {
        try await AuthenticationManager.shared.signIn(email: email, password: password)
    }
    
    func emailIsEmpty() -> Bool {
        return self.email.isEmpty
    }
    
    func passwordIsEmpty() -> Bool {
        return self.password.isEmpty
    }
    
    func nameIsEmpty() -> Bool {
        return self.name.isEmpty
    }
}
