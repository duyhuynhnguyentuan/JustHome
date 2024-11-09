//
//  OpenForSale.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 23/10/24.
//

import Foundation

struct OpenForSales: Decodable, Encodable{
    let openingForSaleID: String
    let decisionName: String
    let startDate: String
    let endDate: String
    let checkinDate: String
    let saleType: String
    let reservationPrice: String
    let description: String
    let status: Bool
    let projectCategoryDetailID: String
    let projectName: String?
    let propertyCategoryName: String?
}
extension OpenForSales {
    static var sample = OpenForSales(openingForSaleID: "a47807c3-4ab7-47ce-a8d6-54dffb078cb3",
                                    decisionName: "Mở bán lần 1",
                                    startDate: "2024-10-24T09:55:00",
                                    endDate: "2024-10-30T09:00:00",
                                    checkinDate: "2024-10-27T07:00:00",
                                    saleType: "Offline",
                                    reservationPrice: "30000000",
                                    description: "Mở đợt mở bán lần 1",
                                    status: true,
                                     projectCategoryDetailID: "2c91dbdd-ea16-438b-9f4b-5bdbd715316f", projectName: "Vinhomes Grand Park", propertyCategoryName: nil)
}
