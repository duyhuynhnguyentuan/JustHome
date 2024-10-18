//
//  ProjectCategoryDetail.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 19/10/24.
//

import Foundation

struct ProjectCategoryDetail: Codable, Identifiable {
    // Computed property for 'id'
    var id: String {
        return "\(projectName)_\(propertyCategoryName)_\(projectID)_\(propertyCategoryID)"
    }
    let projectID: String
    let projectName: String
    let propertyCategoryID: String
    let propertyCategoryName: String
}

extension ProjectCategoryDetail{
    static var sample = ProjectCategoryDetail(projectID: "adn238u2983un89u", projectName: "Vinhomes Grand Park", propertyCategoryID: "aiksjdkajsd", propertyCategoryName: "Căn hộ chung cư")
}

