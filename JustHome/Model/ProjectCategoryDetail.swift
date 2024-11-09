//
//  ProjectCategoryDetail.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 19/10/24.
//

import Foundation

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
    let openForSale: Bool
}

extension ProjectCategoryDetail{
    static var sample = ProjectCategoryDetail(projectCategoryDetailID: "2c91dbdd-ea16-438b-9f4b-5bdbd715316f", projectID: "adn238u2983un89u", projectName: "Vinhomes Grand Park", propertyCategoryID: "aiksjdkajsd", propertyCategoryName: "Căn hộ chung cư", openForSale: true)
}

