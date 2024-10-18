//
//  Project.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 14/10/24.
//

import Foundation

struct Project: Identifiable, Encodable, Decodable, Hashable {
    let projectID: String
    let projectName: String
    let location: String
    let investor: String
    let generalContractor: String
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

extension Project {
    static var sample = Project(projectID: "2938e29839", projectName: "Vinhomes Grand Park", location: "Long Thanh My, Nguyen Xien, TP.HCM", investor: "VinGroup", generalContractor: "Your mom", designUnit: "IDK", totalArea: "1000m2", scale: "420 ha", buildingDensity: "90%", totalNumberOfApartment: "53000", legalStatus: "Sở hữu không thời hạn", handOver: "Tháng 9 năm 2024", convenience: "hồ bơi, công viên, cửa hàng", images: ["https://realestatesystem.blob.core.windows.net/projectimage/4a98e305-7973-44f7-a0b7-abd49cbfc6cd_the-beverly-1.jpg", "https://realestatesystem.blob.core.windows.net/projectimage/52a923c3-bda6-4fcd-b9ae-0afce26004ac_vinhomeoceanpark3.jpg"], status: "Sắp mở bán")
    static var sample2 = Project(projectID: "2938e29839", projectName: "Vinhomes Grand Park", location: "Long Thanh My, Nguyen Xien, TP.HCM", investor: "VinGroup", generalContractor: "Your mom", designUnit: "IDK", totalArea: "1000m2", scale: "420 ha", buildingDensity: "90%", totalNumberOfApartment: "53000", legalStatus: "Sở hữu không thời hạn", handOver: "Tháng 9 năm 2024", convenience: "hồ bơi, công viên, cửa hàng", images: ["https://realestatesystem.blob.core.windows.net/projectimage/13a4bf79-8557-4226-8639-13e3c0e30fc2_vinhomeoceanpark1.jpeg", "https://realestatesystem.blob.core.windows.net/projectimage/52a923c3-bda6-4fcd-b9ae-0afce26004ac_vinhomeoceanpark3.jpg"], status: "Đang mở bán")
    static var sample3 = Project(projectID: "2938e29839", projectName: "Vinhomes Grand Park", location: "Long Thanh My, Nguyen Xien, TP.HCM", investor: "VinGroup", generalContractor: "Your mom", designUnit: "IDK", totalArea: "1000m2", scale: "420 ha", buildingDensity: "90%", totalNumberOfApartment: "53000", legalStatus: "Sở hữu không thời hạn", handOver: "Tháng 9 năm 2024", convenience: "hồ bơi, công viên, cửa hàng", images: ["https://realestatesystem.blob.core.windows.net/projectimage/13a4bf79-8557-4226-8639-13e3c0e30fc2_vinhomeoceanpark1.jpeg", "https://realestatesystem.blob.core.windows.net/projectimage/52a923c3-bda6-4fcd-b9ae-0afce26004ac_vinhomeoceanpark3.jpg"], status: "Đã mở bán")
}
