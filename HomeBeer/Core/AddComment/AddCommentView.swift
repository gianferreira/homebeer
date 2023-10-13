import SwiftUI

struct AddCommentView: View {
    
    var brewery: Brewery
    var user: DBUser
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = AddCommentViewModel()
    
    @State var userName: String  = ""
    @State var breweryTitle: String  = ""
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    let homeBeerYellow: Color = Color(red: 249 / 255, green: 208 / 255, blue: 148 / 255)
    let homeBeerBrown: Color = Color(red: 46 / 255, green: 42 / 255, blue: 36 / 255)
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Homebeer")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(homeBeerYellow)
                    .padding(.bottom)
                
                VStack {
                    Text("IMPORTANTE: Cada nova experiência adicionada é salva no armazenamento local do seu idispositivo.")
                        .foregroundColor(homeBeerBrown)
                        .background(homeBeerYellow)
                        .fontWeight(.heavy)
                        .padding()
                        .frame(maxWidth: .infinity)
                    Text("Para upar para o banco de dados, acessar Sua Área > Gerenciamento de Conta > Sincronizar experiências")
                        .foregroundColor(homeBeerBrown)
                        .background(homeBeerYellow)
                        .fontWeight(.heavy)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 8)
                }.background(homeBeerYellow)
                    .frame(alignment: .topTrailing)
                    .cornerRadius(16)
                    .padding()
                
                Spacer()
                
                Text("Descreva sua experiência na " + brewery.title + ": ")
                    .fontWeight(.heavy)
                    .foregroundColor(homeBeerYellow)
                    .padding(.bottom)
                
                TextField("Descreva sua experiência...", text: $viewModel.text)
                    .padding(.horizontal)
                    .fontWeight(.heavy)
                    .frame(height: 55)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                
                TextField(user.name, text: $userName)
                    .padding()
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    .disabled(true)
                
                TextField(brewery.title, text: $breweryTitle)
                    .padding()
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    .disabled(true)
                
                Button {
                    Task {
                        do {
                            try await viewModel.createComment(userId: user.userId, breweryId: brewery.id)
                            presentationMode.wrappedValue.dismiss()
                            return;
                        } catch {
                            showAlert.toggle()
                            self.alertTitle = "Ocorreu um erro ao tentar adicionar a sua experiência."
                        }
                    }
                } label: {
                    Text("Entrar")
                        .font(.headline)
                        .foregroundColor(homeBeerBrown)
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                        .background(homeBeerYellow)
                        .cornerRadius(12)
                }            }
            .padding(14)
        }
        .alert(isPresented: $showAlert, content: getAlert)
        .background(homeBeerBrown)
    }

    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
    
}

