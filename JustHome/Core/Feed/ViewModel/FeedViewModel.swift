//
//  FeedViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 11/10/24.
//

import Foundation
import Combine
import CoreData
import SwiftUI

@MainActor
class FeedViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState = .idle
    @Published private(set) var projects = [Project]()
    @Published var error: NetworkError?
    @Published var generalError: Error?
    @Published var hasReachedEnd = false
    @Published var noResult: Bool = false
    @Published var isSearching: Bool = false  // Controls search loading overlay
//    @Environment(\.managedObjectContext) private var managedObjectContext
//    @EnvironmentObject private var dataController: DataController
    let dataController: DataController
    @Published var searchText = "" {
        didSet {
            searchTextSubject.send(searchText)
        }
    }
    
    private var page = 0
    let projectsService: ProjectsService
    private var cancellables: Set<AnyCancellable> = []
    private let searchTextSubject = CurrentValueSubject<String, Never>("")
    
    init(projectsService: ProjectsService, dataController: DataController) {
        self.dataController = dataController
        self.projectsService = projectsService
        observeSearchTextChanges()
        loadData()
    }
    // Function to save liked project
    func likeProject(project: Project) {
        // Check if the project is already liked
        let fetchRequest: NSFetchRequest<LikedProject> = LikedProject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "projectID == %@", project.projectID)

        do {
            let likedProjects = try dataController.container.viewContext.fetch(fetchRequest)

            if let existingLikedProject = likedProjects.first {
                // If the project is already liked, unlike it by deleting it
                dataController.container.viewContext.delete(existingLikedProject)
                print("Project unliked: \(project.projectName)")
            } else {
                // If the project is not liked, add it as a liked project
                let likedProject = LikedProject(context: dataController.container.viewContext)
                likedProject.projectID = project.projectID
                likedProject.projectName = project.projectName
                likedProject.location = project.location
                // Add other properties as necessary
                print("Project liked: \(project.projectName)")
            }
            
            // Save the context after liking or unliking the project
            try dataController.container.viewContext.save()
            
        } catch {
            print("Error saving liked project: \(error.localizedDescription)")
        }
    }


        // Function to count liked projects
//        func countLikedProjects() -> Int {
//            let fetchRequest: NSFetchRequest<LikedProject> = LikedProject.fetchRequest()
//            
//            do {
//                let count = try managedObjectContext.count(for: fetchRequest)
//                return count
//            } catch {
//                print("Error counting liked projects: \(error.localizedDescription)")
//                return 0
//            }
//        }

        // Function to fetch liked projects
        func fetchLikedProjects() -> [LikedProject] {
            let fetchRequest: NSFetchRequest<LikedProject> = LikedProject.fetchRequest()
            
            do {
                let likedProjects = try dataController.container.viewContext.fetch(fetchRequest)
                return likedProjects
            } catch {
                print("Error fetching liked projects: \(error.localizedDescription)")
                return []
            }
        }
    @MainActor
    func handleRefresh() {
        projects.removeAll()
        page = 0
        hasReachedEnd = false
        loadData()
    }

    private func observeSearchTextChanges() {
        // Observe search text changes and debounce for search input
        searchTextSubject
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                guard let self = self else { return }
                
                if searchText.isEmpty {
                    // Reload initial feed when search text is cleared
                    self.isSearching = false
                } else {
                    // Trigger search for non-empty input
                    self.isSearching = true
                    Task {
                        try await self.searchProject(projectName: searchText)
                    }
                }
            }
            .store(in: &cancellables)
    }

    @MainActor
    func searchProject(projectName: String) async throws {
        do {
            let result = try await projectsService.loadProjects(projectName: projectName)
            isSearching = false
            if result.projects.isEmpty {
                noResult = true
            } else {
                self.projects = result.projects
                noResult = false
            }
        } catch let error as NetworkError {
            isSearching = false
            switch error {
            case .errorResponse(let response):
                if response.message == "Dự án không tồn tại." {
                    noResult = true
                }
            default:
                self.error = error
            }
            print("Error: \(error.localizedDescription)")
        } catch {
            isSearching = false
            self.generalError = error
            print("Unexpected error: \(error.localizedDescription)")
        }
    }

    @MainActor
    func loadProjects() async throws {
        page += 1
        defer { loadingState = .finished }
        
        do {
            let projects = try await projectsService.loadProjects(page: page)
            self.projects.append(contentsOf: projects.projects)
            if projects.totalPages < page {
                page = projects.totalPages
                hasReachedEnd = true
            }
        } catch let error as NetworkError {
            switch error {
            case .errorResponse(let response):
                if response.message == "Dự án không tồn tại." {
                    hasReachedEnd = true
                    page -= 1
                }
            default:
                self.error = error
            }
            print("Error: \(error.localizedDescription)")
        } catch {
            self.generalError = error
            print("Unexpected error in feed view model: \(error.localizedDescription)")
        }
    }

    func loadData() {
        Task(priority: .medium) {
            if page == 0 {
                loadingState = .loading
            }
            try await loadProjects()
        }
    }
}
