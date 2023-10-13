import SwiftUI

struct BreweryView: View {
    @StateObject private var viewModel = BreweryViewModel()
    @Binding var showSignInView: Bool
    
    let homeBeerYellow: Color = Color(red: 249 / 255, green: 208 / 255, blue: 148 / 255)
    let homeBeerBrown: Color = Color(red: 23 / 255, green: 21 / 255, blue: 18 / 255)
    
    var body: some View {
        List {
            ForEach(viewModel.breweries) { brewery in
                BreweryItemView(brewery: brewery, user: viewModel.user ?? DBUser())
            }
        }
        .navigationTitle("Cervejarias")
        .task {
            try? await viewModel.loadCurrentUser()
            try? await viewModel.loadAllBreweries()
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                NavigationLink {
                    WelcomeView(
                        showSignInView: $showSignInView
                    )
                } label: {
                    Text("Sua àrea")
                }
            }
        }
    }
}
