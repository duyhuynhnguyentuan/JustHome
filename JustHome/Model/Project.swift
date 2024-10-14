//
//  Project.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 14/10/24.
//

import Foundation

struct Project: Identifiable, Decodable, Hashable {
    let projectID: String
    let projectName: String
    let location: String
    let investor: String
    let gneralContractor: String
    let designUnit: String
    let totalArea: String
    let scale: String
    let buildingDensity: String
    let totalNumberOfApartment: String
    let legalStatus: String
    let handOver: String
    let convenience: String
    let images: [String]
    let status: String
    var id: String { projectID }
}
