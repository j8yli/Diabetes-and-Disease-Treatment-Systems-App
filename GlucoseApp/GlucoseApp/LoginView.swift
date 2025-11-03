import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var showError = false

    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                Text("Grow Your Glucose")
                    .font(.largeTitle.bold())
                    .foregroundColor(.green)
                    .padding(.top, 50)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)

                HStack {
                    if showPassword {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                Button(action: handleLogin) {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                if showError {
                    Text("Invalid email or password.")
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Spacer()

                NavigationLink(destination: SignupView()) {
                    Text("Don't have an account? Sign up")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
    }

    func handleLogin() {
        if email.lowercased() == "test@example.com" && password == "password" {
            print("Logged in successfully")
        } else {
            showError = true
        }
    }
}

#Preview {
    LoginView()
}
