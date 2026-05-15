import SwiftUI

struct LoginView: View {
    @ObservedObject var store: LoginStore

    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()
            VStack {
                header
                    .padding(.bottom, 48)
                formSection
                    .padding(.bottom, 32)
                actionsSection
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            store.send(.viewDidAppear)
        }
    }
}

// MARK: - Sections
private extension LoginView {
    var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "face.smiling.fill")
                .font(.system(size: 64))
                .foregroundStyle(.brown)
            Text("Jokes")
                .textStyle(textType: .navigationTitle)
        }
    }

    var formSection: some View {
        VStack(spacing: 12) {
            TextField("E-mail", text: $store.state.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(UIConstants.cornerRadius)

            SecureField("Password", text: $store.state.password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(UIConstants.cornerRadius)

            Toggle(isOn: Binding(
                get: { store.state.rememberMe },
                set: { store.send(.rememberMeChanged($0)) }
            )) {
                Text("Remember me")
                    .textStyle(textType: .caption)
            }
            .tint(.brown)

            if let error = store.state.errorMessage {
                Text(error)
                    .textStyle(textType: .caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }
        }
    }

    var actionsSection: some View {
        VStack(spacing: 12) {
            if store.state.isLoading {
                ProgressView()
            } else {
                Button("Sign In") {
                    store.send(.signIn)
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.brown)
                .cornerRadius(UIConstants.cornerRadius)

                Button("Sign Up") {
                    store.send(.signUp)
                }
                .font(.headline)
                .foregroundStyle(.brown)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(UIConstants.cornerRadius)
            }
        }
    }
}
