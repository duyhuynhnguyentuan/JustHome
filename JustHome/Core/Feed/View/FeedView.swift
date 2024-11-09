import SwiftUI

struct FeedView: View {
    @StateObject private var feedViewModel: FeedViewModel
    @EnvironmentObject private var routerManager : NavigationRouter
    init(projectsService: ProjectsService) {
        _feedViewModel = StateObject(wrappedValue: FeedViewModel(projectsService: projectsService))
    }

    var body: some View {
        NavigationStack(path: $routerManager.routes) {
            ZStack {
                switch feedViewModel.loadingState {
                case .loading:
                    // Main loading state when loading initial data
                    List {
                        FeedRowPlaceHolder()
                    }
                    .listStyle(.plain)
                    .navigationTitle("Đã thêm gần đây")

                case .finished:
                    if feedViewModel.noResult {
                        // Show no results message if search yielded no results
                        VStack{
                            Image(systemName: "questionmark.circle")
                                .font(.headline)
                                .padding()
                            Text("Không có dự án nào khớp với tìm kiếm \"\(feedViewModel.searchText)\".")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                            Button("Quay trở lại"){
                                feedViewModel.noResult = false
                            }.buttonStyle(.borderedProminent)
                        }
                    } else {
                        List {
                            ForEach(feedViewModel.projects, id: \.id) { project in
                                Button {
                                    routerManager.push(to: .projects(project: project))
                                }label: {
                                    FeedRowView(project: project, isPlaceHolder: false)
                                        .onAppear {
                                            if project.id == feedViewModel.projects.last?.id {
                                                feedViewModel.loadData()
                                            }
                                        }
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button{
                                        print("liked: \(project.projectName)")
                                    }label: {
                                        Label("Like", systemImage: "heart")
                                    }.tint(.pink)
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button{
                                        print("shared: \(project.projectName)")
                                    }label: {
                                        Label("Share", systemImage: "square.and.arrow.up")
                                    }.tint(.primaryGreen)
                                }
                                
                            }
                            if feedViewModel.hasReachedEnd {
                                Text("Bạn đã tới cuối feed.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.top, 10)
                            }
                        }
                        .listStyle(.plain)
                        .alert(item: $feedViewModel.error) { error in
                            // Handle alert cases
                            switch error {
                            case .badRequest:
                                return Alert(
                                    title: Text("Bad Request"),
                                    message: Text("Unable to perform the request."),
                                    dismissButton: .default(Text("OK"))
                                )
                            case .decodingError(let decodingError):
                                return Alert(
                                    title: Text("Decoding Error"),
                                    message: Text(decodingError.localizedDescription),
                                    dismissButton: .default(Text("OK"))
                                )
                            case .invalidResponse:
                                return Alert(
                                    title: Text("Invalid Response"),
                                    message: Text("The server response was invalid."),
                                    dismissButton: .default(Text("OK"))
                                )
                            case .errorResponse(let errorResponse):
                                return Alert(
                                    title: Text("Lỗi"),
                                    message: Text(errorResponse.message ?? "An unknown error occurred."),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                        }
                        .refreshable {
                            feedViewModel.handleRefresh()
                        }
                        .searchable(text: $feedViewModel.searchText, placement: .automatic, prompt: "Tìm kiếm dự án...")
                        .navigationTitle("Đã thêm gần đây")
                        .navigationDestination(for: Route.self) { $0 }
                        .navigationSplitViewStyle(.balanced)
                        .toolbar {
                            ToolbarItemGroup(placement: .topBarTrailing) {
                                Button{
                                    
                                } label: {
                                    Image(systemName: "heart")
                                        .tint(Color.red)
                                }
                            }
                        }
                    }

                case .idle:
                    EmptyView()
                }

                // Search-specific loading overlay
                if feedViewModel.isSearching {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView("Đang tìm kiếm dự án...")
                        .foregroundColor(.white)
                        .scaleEffect(1.5)
                }
            }
        }.navigationSplitViewStyle(.balanced)
    }
}

#Preview {
    FeedView(projectsService: ProjectsService(httpClient: HTTPClient()))
        .environmentObject(NavigationRouter())
}
