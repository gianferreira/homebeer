import Foundation
import CoreData
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Comment: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let breweryId: String
    let userId: String
    let text: String
    let date: Date
    let remote: Bool
    
    init(
        id: String,
        breweryId: String,
        userId: String,
        text: String,
        date: Date,
        remote: Bool
    ) {
        self.id = id
        self.breweryId = breweryId
        self.userId = userId
        self.text = text
        self.date = date
        self.remote = remote
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case breweryId = "brewery_Id"
        case userId = "user_Id"
        case text = "text"
        case date = "date"
        case remote = "remote"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.breweryId = try container.decode(String.self, forKey: .breweryId)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.text = try container.decode(String.self, forKey: .text)
        self.date = try container.decode(Date.self, forKey: .date)
        self.remote = try container.decode(Bool.self, forKey: .remote)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.breweryId, forKey: .breweryId)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.text, forKey: .text)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.remote, forKey: .remote)
    }
        
    static func ==(lhs: Comment, rhs: Comment) -> Bool {
        return lhs.id == rhs.id
    }
}

final class CommentManager {
    static let shared = CommentManager()
    
    private let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "CommentsContainer")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Erro ao carregar dados locais \(error)")
            } else {
                print("Dados locais carregados com sucesso")
            }
        }
    }
    
    func createLocalComment(comment: Comment) async throws {
        let newComment = CommentEntity(context: container.viewContext)
        newComment.id = comment.id
        newComment.userId = comment.userId
        newComment.breweryId = comment.breweryId
        newComment.text = comment.text
        newComment.date = comment.date
        newComment.remote = false
        
        try container.viewContext.save()
    }
    
    private func fetchLocalComments() -> [CommentEntity] {
        var comments: [CommentEntity]  = []
        
        let request = NSFetchRequest<CommentEntity>(entityName: "CommentEntity")
        
        do {
            comments = try container.viewContext.fetch(request)
        } catch let error {
            print("Erro ao realizar o fetch de dados do container \(error)")
        }
        
        return comments
    }
    
    func uploadLocalComments() async throws {
        let localComments = fetchLocalComments()
        
        for comment in localComments {
            let formattedComment = Comment(
                id: comment.id!,
                breweryId: comment.breweryId!,
                userId: comment.userId!,
                text: comment.text!,
                date: comment.date!,
                remote: true)
            
            try await createRemoteComment(comment: formattedComment)
            container.viewContext.delete(comment)
        }
        
        try container.viewContext.save()
    }
    
    private let commentsCollection = Firestore.firestore().collection("comments")
    
    private func commentDocument(commentId: String) -> DocumentReference {
        commentsCollection.document(commentId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()

    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
    
    private func createRemoteComment(comment: Comment) async throws {
        try commentDocument(commentId: comment.id)
            .setData(from: comment, merge: false, encoder: encoder)
    }
    
    func getCommentsFiltered(breweryId: String, userId: String) async throws -> [Comment] {
        var comments: [Comment] = []
        
        let snapshot = try await commentsCollection
            .whereField("brewery_Id", isEqualTo: breweryId)
            .whereField("user_Id", isEqualTo: userId)
            .getDocuments()
        
        for comment in snapshot.documents {
            let comment = try comment.data(as: Comment.self)
            comments.append(comment)
        }
        
        let localComments = fetchLocalComments()
        
        for comment in localComments {
            if(comment.breweryId == breweryId && comment.userId == userId) {
                let formattedComment = Comment(
                    id: comment.id!,
                    breweryId: comment.breweryId!,
                    userId: comment.userId!,
                    text: comment.text!,
                    date: comment.date!,
                    remote: comment.remote)
                
                comments.append(formattedComment)
            }
        }
        
        let sortedComments = comments.sorted {
            $0.date > $1.date
        }
        
        return sortedComments
    }
}
