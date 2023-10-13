import SwiftUI

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    @State var isSignUp: Bool = true
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    
    let homeBeerYellow: Color = Color(red: 249 / 255, green: 208 / 255, blue: 148 / 255)
    let homeBeerBrown: Color = Color(red: 46 / 255, green: 42 / 255, blue: 36 / 255)
    
    var body: some View {
        ZStack {
            homeBeerBrown.ignoresSafeArea()
            
            VStack {
                Image("homebeer")
                    .resizable()
                    .frame(width: 120, height: 180)
                    .padding(.top, 48)
                
                Text("Homebeer")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(homeBeerYellow)
                    .padding(.bottom)
                
                Spacer()
                
                if isSignUp {
                    TextField("Nome", text: $viewModel.name)
                        .padding()
                        .fontWeight(.heavy)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                }
                
                TextField("E-mail", text: $viewModel.email)
                    .padding()
                    .fontWeight(.heavy)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                
                SecureField("Senha", text: $viewModel.password)
                    .padding()
                    .fontWeight(.heavy)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                
                Button {
                    Task {
                        do {
                            if viewModel.emailIsEmpty() {
                                alertTitle = "Insira um e-mail para prosseguir."
                                showAlert.toggle()
                                return
                            }
                            if viewModel.passwordIsEmpty() {
                                alertTitle = "Insira uma senha para prosseguir."
                                showAlert.toggle()
                                return
                            }
                            
                            if isSignUp {
                                if viewModel.nameIsEmpty() {
                                    alertTitle = "Insira um nome para criar o seu usuário."
                                    showAlert.toggle()
                                    return
                                }
                                
                                try await viewModel.signUp()
                            } else {
                                try await viewModel.signIn()
                            }
                            
                            showSignInView = false
                            return
                        } catch {
                            showAlert.toggle()
                            self.alertTitle = "Ocorreu um erro ao tentar autenticar-se."
                        }
                    }
                } label: {
                    Text(isSignUp ? "Cadastrar-se" : "Entrar")
                        .font(.headline)
                        .foregroundColor(homeBeerBrown)
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                        .background(homeBeerYellow)
                        .cornerRadius(12)
                }
                
                Button {
                    Task {
                        isSignUp = !isSignUp
                    }
                } label: {
                    Text(isSignUp ? "Já tenho uma conta" : "Quero me cadastrar")
                        .font(.headline)
                        .foregroundColor(homeBeerYellow)
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                        .background(homeBeerBrown)
                        .cornerRadius(12)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .alert(isPresented: $showAlert, content: getAlert)
        }
        }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
}
