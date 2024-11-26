//
//  SalePolicy.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 25/11/24.
//

import Foundation

struct SalesPolicy: Codable, Identifiable {
    var id:String {
        salesPolicyID
    }
    let salesPolicyID: String
    let salesPolicyType: String
    let expressTime: String
    let peopleApplied: String
    let status: Bool
    let projectID: String
    let projectName: String
}
