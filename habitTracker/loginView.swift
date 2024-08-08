import SwiftUI
import Firebase
import FirebaseAuth

struct LogInView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var navigateToHome = false

    var body: some View {
        VStack {
            Text("Log In")
                .font(.largeTitle)
                .padding(.bottom, 40)

            TextField("Enter your email", text: $email)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                .padding(.bottom, 20)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            SecureField("Enter your password", text: $password)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                .padding(.bottom, 20)

            NavigationLink(destination: HomeView(), isActive: $navigateToHome) {
                EmptyView()
            }

            Button(action: logIn) {
                Text("Log In")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Log In"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                    if alertMessage == "Log In successful!" {
                        navigateToHome = true
                    }
                })
            }
            .padding(.horizontal, 20)
        }
        .padding()
    }

    func logIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showingAlert = true
            } else {
                alertMessage = "Log In successful!"
                showingAlert = true
            }
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}

