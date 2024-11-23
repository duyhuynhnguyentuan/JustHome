//
//  ProjectCategoryDetail.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 19/10/24.
//

import Foundation
import SwiftUI

struct ProjectCategoryDetail: Codable, Identifiable, Equatable {
    // Computed property for 'id'
    var id: String {
        return "\(projectName)_\(propertyCategoryName)_\(projectID)_\(propertyCategoryID)"
    }
    let projectCategoryDetailID: String
    let projectID: String
    let projectName: String
    let propertyCategoryID: String
    let propertyCategoryName: String
    let openForSale: String
}

extension ProjectCategoryDetail{
    static var sample = ProjectCategoryDetail(projectCategoryDetailID: "2c91dbdd-ea16-438b-9f4b-5bdbd715316f", projectID: "adn238u2983un89u", projectName: "Vinhomes Grand Park", propertyCategoryID: "aiksjdkajsd", propertyCategoryName: "Căn hộ chung cư", openForSale: "Chưa mở bán")
}

extension ProjectCategoryDetail {
    var statusColor: Color {
        switch openForSale {
        case "Chưa mở bán":
            return .secondary
        case "Giữ chỗ":
            return .yellow
        case "Check in":
            return .secondary
        case "Mua trực tiếp":
            return .green
        default:
            return .gray
        }
    }
}
