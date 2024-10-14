import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel

    init(authService: AuthService) {
        _viewModel = StateObject(wrappedValue: ContentViewModel(authService: authService))
    }

    var body: some View {
        ResponsiveView { _ in
            Group {
                if viewModel.isAuthenticated {
                    JHTabView(authService: viewModel.authService)
                    .transition(.blurReplace)
                } else {
                    VStack {
                        LoginView(authService: viewModel.authService)
                    }
                    .transition(.blurReplace) // Slide transition from left
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
            .animation(.smooth(duration: 0.5), value: viewModel.isAuthenticated) // Applying animation
        }
    }
}

#Preview {
    ContentView(authService: AuthService(keychainService: KeychainService(), httpClient: HTTPClient()))
}
