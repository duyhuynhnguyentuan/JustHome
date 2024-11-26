//
//  Route.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 16/10/24.
//

import Foundation
import SwiftUI

enum Route {
    //route for feed detail view aka project detail view
    case projects(project: Project)
    //booking tab view aka activity View
    case activity
    // route for activity detail view aka booking detail view (type String because of booking status)
    case bookings(bookingID: String)
    // route to real time
    case realTime(projectCategoryDetailID: String)
    //route contract
    case contract(contractID: String)
    //route procedure
    case procedure
    //route for contract payment detail upload
    case contractPaymentDetailUpload(contractPaymentDetail: ContractPaymentDetail)
    ///
    case profile
}

extension Route {
    static func buildDeepLink(from route: Route) -> URL? {
        switch route {
        case .projects(let project):
            let queryProjectId = project.projectID
            var url = URL(string: "justhome://project")!
            let queryItems = [URLQueryItem(name: "projectID", value: queryProjectId)]
            url.append(queryItems: queryItems)
            return url
        default:
            break
        }
    return nil
    }
}

extension Route: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    static func == (lhs: Route, rhs: Route) -> Bool {
        switch (lhs, rhs){
        case (.projects(let lhsItem), .projects(let rhsItem)):
            return lhsItem == rhsItem
        case (.activity, .activity):
            return true
        case (.bookings(let lhsItem), .bookings(let rhsItem)):
            return lhsItem == rhsItem
        case (.realTime(let lhsItem), .realTime(let rhsItem)):
            return lhsItem == rhsItem
        case (.contract(let lhsItem), .contract(let rhsItem)):
            return lhsItem == rhsItem
        case (.procedure, .procedure):
            return true
        case (.contractPaymentDetailUpload(let lhsItem), .contractPaymentDetailUpload(let rhsItem)):
            return lhsItem == rhsItem
        case (.profile, .profile):
            return true
        default:
            return false
        }
    }
}

extension Route: View {
    var body: some View {
        switch self {
        case .projects(let project):
            ProjectDetailView(project: project)
                .navigationBarBackButtonHidden()
        case .activity:
            ActivityView()
                .navigationBarBackButtonHidden()
        case .bookings(let bookingID):
            BookingDetailView(bookingID: bookingID)
        case .realTime(let projectCategoryDetailID):
            RealTimeView(categoryDetailID: projectCategoryDetailID)
                .toolbar(.hidden, for: .tabBar)
        case .contract(let contractID):
            ContractDetailView(contractID: contractID)
        case .procedure:
            ProcedureView()
                .toolbar(.hidden, for: .tabBar)
        case .contractPaymentDetailUpload(let contractPaymentDetail):
            ContractPaymentDetailUploadView(contractPaymentDetail: contractPaymentDetail)
        case .profile:
            ProfileView(authService: AuthService(keychainService: KeychainService.shared, httpClient: HTTPClient()))
        }
        
    }
}
