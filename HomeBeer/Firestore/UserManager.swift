import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    let userId: String
    let name: String
    let active: Bool
    let email: String?
    let dateCreated: Date?

    init(auth: AuthResultModel, name: String) {
        self.userId = auth.uid
        self.name = name
        self.active = true
        self.email = auth.email
        self.dateCreated = Date()
    }
    
    init(
        userId: String,
        name: String,
        active: Bool,
        email: String? = nil,
        dateCreated: Date? = nil
    ) {
        self.userId = userId
        self.name = name
        self.active = active
        self.email = email
        self.dateCreated = dateCreated
    }
    
    init() {
        self.userId = ""
        self.name = ""
        self.active = true
        self.email = ""
        self.dateCreated = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case name = "name"
        case active = "active"
        case email = "email"
        case dateCreated = "date_created"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.name = try container.decode(String.self, forKey: .name)
        self.active = try container.decode(Bool.self, forKey: .active)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.active, forKey: .active)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
    }
}

final class UserManager {
    static let shared = UserManager()
    
    private let usersCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        usersCollection.document(userId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()

    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
    
    func createUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false, encoder: encoder)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self, decoder: decoder)
    }
    
    func removeUser(userId: String) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.active.rawValue: false
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
}
