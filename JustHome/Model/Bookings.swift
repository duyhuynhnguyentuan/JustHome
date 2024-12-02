//
//  Bookings.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 26/10/24.
//

import Foundation

struct Bookings: Identifiable, Encodable, Decodable, Hashable {
    let bookingID: String
    let depositedTimed: String?
    let depositedPrice: Double?
    let createdTime: String
    let updatedTime: String?
    let bookingFile: String?
    let note: String?
    let status: String
    let customerID: String
    let customerName: String
    let staffID: String?
    let staffName: String?
    let openingForSaleID: String
    let decisionName: String
    let projectCategoryDetailID: String
//    let propertyCategoryID: String
    let propertyCategoryName: String?
//    let projectID: String
    let projectName: String
    let documentTemplateID: String?
    let documentName: String?
    var id: String { bookingID }
}

extension Bookings {
    static var sample = Bookings(
        bookingID: "c0bfde94-5e0f-4220-88ba-1cc457357129",
          depositedTimed: nil,
          depositedPrice: nil,
          createdTime: "2024-10-23T14:53:20.9547933",
          updatedTime: nil,
          bookingFile: nil,
          note: nil,
          status: "Đã ký thỏa thận đặt cọc",
          customerID: "1fa73089-1213-467e-ac77-2d0d6b73ae51",
          customerName: "Huynh Nguyen Tuan Duy",
          staffID: nil,
          staffName: nil,
          openingForSaleID: "a47807c3-4ab7-47ce-a8d6-54dffb078cb3",
          decisionName: "Mở bán lần 1",
          projectCategoryDetailID: "2c91dbdd-ea16-438b-9f4b-5bdbd715316f",
//          propertyCategoryID: "284f1eb6-006b-4696-88fe-a8c6c64f614c",
          propertyCategoryName: nil,
//          projectID: "9a459acb-4f8e-4a52-bbdb-9108ba296ccf",
          projectName: "Vinhomes Grand Park",
          documentTemplateID: nil,
          documentName: nil
    )
}
import SwiftUI

extension Bookings {
    var statusColor: Color {
        switch status {
        case "Chưa thanh toán tiền giữ chỗ":
            return .yellow
        case "Đã đặt chỗ":
            return .green
        case "Đã check in":
            return .blue
        case "Đã chọn sản phẩm":
            return .orange
        case "Đã ký thỏa thuận đặt cọc":
            return .purple
        case "Đã hủy":
            return .red
        case "Không chọn sản phẩm":
            return .brown
        default:
            return .gray
        }
    }
}
