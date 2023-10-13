import Foundation
import FirebaseAuth

struct AuthResultModel {
    let uid: String
    let email: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}

final class AuthenticationManager {
    static let shared = AuthenticationManager();
    
    func createUser(email: String, password: String) async throws -> AuthResultModel {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthResultModel(user: authResult.user)
    }
    
    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func deleteUser() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await UserManager.shared.removeUser(userId: user.uid)
        try await user.delete()
        
        try signOut()
    }
    
    func getAuthenticatedUser() throws -> AuthResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthResultModel(user: user)
    }
}
