//
//  ContractPaymentDetail.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 23/11/24.
//

import Foundation

struct ContractPaymentDetail: Codable, Identifiable, Equatable {
    var id: String {
        contractPaymentDetailID
    }
    let contractPaymentDetailID:String
    let paymentRate: Int
    let description: String?
    let period: String
    let paidValue: Double
    let paidValueLate: Double?
    let remittanceOrder: String?
    let status: Bool
    let contractID: String
    let contractCode: String
    let paymentPolicyID: String
    let paymentPolicyName: String
}
