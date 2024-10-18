//
//  LoginViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 5/10/24.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var loadingState: LoadingState = .idle
    @Published var emailOrPhone = ""
    @Published var password = ""
    @Published var error: NetworkError?
    let authSevice: AuthService
    init(authSevice: AuthService) {
        self.authSevice = authSevice
    }
    @MainActor
    func login() async {
        defer{
            loadingState = .finished
        }
        do{
            try await authSevice.login(body: LoginBody(emailOrPhone: emailOrPhone, password: password))
        }catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error : \(error.localizedDescription)")
        }
      
    }
}
