import SwiftUI

struct DetailsView: View {
    var brewery: Brewery
    var user: DBUser
    
    @StateObject private var viewModel = DetailsViewModel()
    @State private var showFullDescription: Bool = false
    
    let homeBeerYellow: Color = Color(red: 249 / 255, green: 208 / 255, blue: 148 / 255)
    let homeBeerBrown: Color = Color(red: 23 / 255, green: 21 / 255, blue: 18 / 255)
    
    var body: some View {
        NavigationView{
            ScrollView {
                LazyVStack(alignment: .center, pinnedViews: .sectionHeaders) {
                    
                    AsyncImage(url: URL(string: brewery.image)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(24)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 320, height: 320)
                    .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 1)
                    .padding()
                    
                    VStack {
                        Text(brewery.description)
                            .foregroundColor(homeBeerBrown)
                            .background(homeBeerYellow)
                            .fontWeight(.heavy)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        Text(brewery.address)
                            .foregroundColor(homeBeerBrown)
                            .background(homeBeerYellow)
                            .fontWeight(.heavy)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 8)
                    }.background(homeBeerYellow)
                        .frame(width: 320, alignment: .topTrailing)
                        .cornerRadius(16)
                        .padding()
                    
                    Divider()
                    
                    if !viewModel.comments.isEmpty {
                        Text("Experiências: ")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(alignment: .leading)
                            .padding()
                    } else {
                        Text("Adicione a sua primeira experiência aqui! ")
                            .font(.headline)
                            .fontWeight(.bold)
                            .frame(alignment: .leading)
                            .padding()
                    }
                    
                    Section {
                        ForEach(viewModel.comments) { comment in
                            CommentItemView(comment: comment)
                        }
                    } header: {
                    }
                }.task {
                    try? await viewModel.loadComments(breweryId: brewery.id, userId: user.userId)
                }
            }
        }.navigationTitle(brewery.title)
        
        .navigationBarItems(
            leading: EditButton(),
            trailing:
                NavigationLink("Adicionar", destination: AddCommentView(
                    brewery: brewery, user: user
                ))
            )
    }
}
