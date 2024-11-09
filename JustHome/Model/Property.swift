//
//  Property.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 8/11/24.
//


import Foundation
import SwiftUICore

struct Property: Codable, Hashable {
    let propertyID: String
    let propertyCode: String
    let view: String
    let priceSold: Int
    let status: String
    let unitTypeID: String?
    let bathRoom: Int
    let bedRoom: Int
    let kitchenRoom: Int
    let livingRoom: Int
    let numberFloor: Int?
    let basement: Int?
    let netFloorArea: Double?
    let grossFloorArea: Double?
    let imageUnitType: String?
    let floorID: String
    let numFloor: Int
    let blockID: String
    let blockName: String
    let zoneID: String
    let zoneName: String
    let projectCategoryDetailID: String
    let projectName: String
    let propertyCategoryName: String
}
extension Property {
    var statusColor: Color {
        switch status {
        case "Mở bán":
            return .cyan
        case "Giữ chỗ":
            return .red
        default:
            return .gray
        }
    }
}
