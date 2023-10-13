import Foundation

final class WelcomeViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil

    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func uploadDocuments() async throws {
        try await CommentManager.shared.uploadLocalComments()
    }
    
    func deleteUser() async throws {
        let authResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authResult.uid)
        
        try await UserManager.shared.removeUser(userId: self.user!.userId)
        try await AuthenticationManager.shared.deleteUser()
    }
}
