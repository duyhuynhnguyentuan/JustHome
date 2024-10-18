//
//  ContentViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 3/10/24.
//

import Foundation
import SwiftUI
import Combine
class ContentViewModel: ObservableObject {
    ///current state to push to authentication screens or not
    @Published private(set) var isAuthenticated: Bool = false
    let authService: AuthService
    private var cancellables = Set<AnyCancellable>()

    
    //  MARK: - Initializer
    init(authService: AuthService){
        self.authService = authService
        setUpSubscribers()
    }
    // MARK: - Subcribers
    /// to observe changes
    private func setUpSubscribers(){
        // The fk $ in authService.$isAuthenticated is a property wrapper that accesses the Published property in Combine. Ko có dấu $ thì ko xài .sink hay mấy cái modifier
        authService.$isAuthenticated.sink { [weak self] isAuthenticated in
            self?.isAuthenticated = isAuthenticated
        }.store(in: &cancellables)
    }
}
