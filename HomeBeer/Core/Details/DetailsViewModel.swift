import Foundation

@MainActor
final class DetailsViewModel: ObservableObject {
    @Published private(set) var comments: [Comment] = []
    
    func loadComments(breweryId: String, userId: String) async throws {
        self.comments = try await CommentManager.shared.getCommentsFiltered(breweryId: breweryId, userId: userId)
    }
}
