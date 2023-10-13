import Foundation

@MainActor
final class BreweryViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    @Published private(set) var breweries: [Brewery] = []
    
    func loadCurrentUser() async throws {
        let authResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authResult.uid)
    }
    
    func loadAllBreweries() async throws {
        self.breweries = try await BreweryManager.shared.getAllBreweries()
    }
}
