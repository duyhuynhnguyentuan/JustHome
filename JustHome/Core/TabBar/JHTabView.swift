import SwiftUI

struct JHTabView: View {
    @State private var selectedTab = 0
    let authService: AuthService
    let projectsService: ProjectsService
    init(authService: AuthService) {
        self.authService = authService
        self.projectsService = ProjectsService(httpClient: authService.httpClient)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView(projectsService: projectsService)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                }
                .tag(0)
            
            ActivityView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "clock.fill" : "clock")
                        .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                }
                .tag(1)
            
            ProcedureView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "list.bullet.rectangle.fill" : "list.bullet.rectangle")
                }
                .tag(2)
            
            NotificationView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "bell.fill" : "bell")
                }
                .tag(3)
//                .badge(3)
            
            ProfileView(authService: authService)
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "person.crop.circle.fill" : "person.crop.circle")
                }
                .tag(4)
        }.tint(Color.theme.green)
    }
}

//#Preview {
//    JHTabView()
//}
