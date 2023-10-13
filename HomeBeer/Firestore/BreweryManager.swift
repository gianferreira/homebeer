import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Brewery: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let title: String
    let description: String
    let logo: String
    let image: String
    let address: String
    let rating: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case logo
        case image
        case address
        case rating
    }
    
    static func ==(lhs: Brewery, rhs: Brewery) -> Bool {
        return lhs.id == rhs.id
    }
}

final class BreweryManager {
    static let shared = BreweryManager()
    
    private let breweriesCollection = Firestore.firestore().collection("breweries")
    
    private func breweryDocument(breweryId: String) -> DocumentReference {
        breweriesCollection.document(breweryId)
    }
    
    func getAllBreweries() async throws -> [Brewery] {
        let snapshot = try await breweriesCollection.getDocuments()
        
        var breweries: [Brewery] = []
        
        for brewery in snapshot.documents {
            let brewery = try brewery.data(as: Brewery.self)
            breweries.append(brewery)
        }
        
        return breweries
    }

}
