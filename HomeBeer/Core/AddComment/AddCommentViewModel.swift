import Foundation

@MainActor
final class AddCommentViewModel: ObservableObject {
    @Published var text = ""

    func createComment(userId: String, breweryId: String) async throws {
        let comment = Comment.init(
            id: UUID().uuidString,
            breweryId: breweryId,
            userId: userId,
            text: text,
            date: Date(),
            remote: false)
        
        try await CommentManager.shared.createLocalComment(comment: comment)
    }
    
    func commentIsEmpty() -> Bool {
        return self.text.isEmpty
    }
}
