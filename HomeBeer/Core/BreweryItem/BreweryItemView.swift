import SwiftUI

struct BreweryItemView: View {
    var brewery: Brewery
    var user: DBUser
    
    var body: some View {
        NavigationLink(destination: DetailsView(
            brewery: brewery,
            user: user
        ), label: {
        VStack(alignment: .center, spacing: 36) {
            AsyncImage(url: URL(string: brewery.logo)) { logo in
                logo
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(24)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 180, height: 180)
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 1)
            .padding(.top)

            VStack(alignment: .leading, spacing: 4) {
                Text((brewery.title))
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text((brewery.address))
                    .font(.headline)
                    .foregroundColor(Color.gray)
             }
            .font(.callout)
            .foregroundColor(.secondary)
            
            Divider()
        }
        })
    }
}
