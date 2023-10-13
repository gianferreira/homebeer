import SwiftUI

struct WelcomeView: View {
    @StateObject private var viewModel = WelcomeViewModel()
    
    @Binding var showSignInView: Bool
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    let homeBeerYellow: Color = Color(red: 249 / 255, green: 208 / 255, blue: 148 / 255)
    let homeBeerBrown: Color = Color(red: 23 / 255, green: 21 / 255, blue: 18 / 255)
    let homeBeerLightBrown: Color = Color(red: 46 / 255, green: 42 / 255, blue: 36 / 255)
    
    var body: some View {
        VStack {
            Image("hbhorizontal")
                .resizable()
                .frame(width: 360, height: 195)
                .cornerRadius(16)
                .padding([.top, .bottom], 12)
    
            VStack {
                Text("Olá, ")
                    .foregroundColor(homeBeerYellow)
                    .background(homeBeerLightBrown)
                    .fontWeight(.heavy)
                    .padding([.top, .leading, .trailing], 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("O  ̶h̶o̶m̶e̶b̶r̶e̶w̶ ̶ Homebeer é seu  ̶m̶a̶n̶a̶g̶e̶r̶ ̶ aplicativo para anotar as suas experiencias com cerveja, ou seja, a sua home das cervejas.")
                    .foregroundColor(homeBeerYellow)
                    .background(homeBeerLightBrown)
                    .fontWeight(.heavy)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 8)
            }.background(homeBeerLightBrown)
                .frame(alignment: .topTrailing)
                .cornerRadius(16)
                .padding()
            
            List {
                Section {
                    Button(role: .destructive) {
                        Task {
                            do {
                                try await viewModel.uploadDocuments()
                                
                                showAlert.toggle()
                                self.alertTitle = "Experiências devidamente sincronizadas"
                            } catch {
                                showAlert.toggle()
                                self.alertTitle = "Erro ao tentar sincronizar experiências"
                            }
                        }
                    } label: {
                        Text("Sincronizar experiências")
                            .foregroundColor(homeBeerYellow)
                            .fontWeight(.heavy)
                    }.listRowBackground(homeBeerLightBrown)
                    
                    Button() {
                        Task {
                            do {
                                try viewModel.signOut()
                                showSignInView = true
                            } catch {
                                showAlert.toggle()
                                self.alertTitle = "Erro ao tentar efetuar o logoff."
                            }
                        }
                    } label: {
                        Text("Sair")
                            .foregroundColor(homeBeerYellow)
                            .fontWeight(.heavy)
                    }.listRowBackground(homeBeerLightBrown)
                    
                    Button(role: .destructive) {
                        Task {
                            do {
                                try await viewModel.deleteUser()
                                showSignInView = true
                                
                                showAlert.toggle()
                                self.alertTitle = "Conta encerrada com sucesso."
                            } catch {
                                showAlert.toggle()
                                self.alertTitle = "Ocorreu um erro ao tentar excluir a conta."
                            }
                        }
                    } label: {
                        Text("Excluir minha conta")
                            .foregroundColor(homeBeerYellow)
                            .fontWeight(.heavy)
                    }.listRowBackground(homeBeerLightBrown)
                    
                } header: {
                    Text("Gerenciamento de conta")
                        .foregroundColor(homeBeerLightBrown)
                        .fontWeight(.heavy)
                }
            }
            .navigationBarTitle("Bem-vindo!")
            .alert(isPresented: $showAlert, content: getAlert)
        }
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
}
