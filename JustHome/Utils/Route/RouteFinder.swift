//
//  RouteFinder.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 17/11/24.
//

import Foundation

enum DeepLinkUrls: String {
    case project
    case realtime
    case booking
}

struct RouteFinder {
    func find(from url: URL, projectService: ProjectsService) async -> Route? {
        guard let host = url.host() else { return nil }
        switch DeepLinkUrls(rawValue: host) {
        case .project:
            let queryParams = url.queryParameters
             guard let projectIdQueryVal = queryParams?["projectID"] else {
                 return nil
             }
             
             do {
                let project = try await projectService.loadProject(withId: projectIdQueryVal)
                return .projects(project: project)
                 
             } catch {
                 print("Error loading project: \(error)")
                 return nil
             }
        case .realtime:
            let queryParams = url.queryParameters
            guard let projectCategoryDetailsQueryVal = queryParams?["projectCategoryDetail"] as? String else {
                return .activity
            }
            return .realTime(projectCategoryDetailID: projectCategoryDetailsQueryVal)
        case .booking:
            let queryParams = url.queryParameters
            guard let bookingIDQueryVal = queryParams?["bookingID"] as? String else
            {
                return .activity
            }
            return .bookings(bookingID: bookingIDQueryVal)
        default:
            return nil
            
        }
    }
}
extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()){ (result, item) in
            result[item.name] = item.value?.replacingOccurrences(of: "+", with: " ")
        }
        
    }
}
