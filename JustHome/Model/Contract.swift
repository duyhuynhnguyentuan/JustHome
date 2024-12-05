//
//  Contract.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 17/11/24.
//


import Foundation

struct PromotionDetail: Codable, Identifiable {
    let promotionDetailID: String
    let description: String
    let amount: Double
    let promotionID: String
    let promotionName: String
    let propertyTypeID: String
    let propertyTypeName: String
    
    var id: String { promotionDetailID }
}

struct PaymentProcess: Codable, Identifiable {
    let paymentProcessID: String
    let paymentProcessName: String
    let status: Bool
    let salesPolicyID: String
    let salesPolicyType: String
    
    var id: String { paymentProcessID }
}

struct PromotionAndPaymentResponse: Codable {
    let promotionDetail: PromotionDetail
    let paymentProcess: [PaymentProcess]
}
struct ContractTitleResponse: Codable {
    let property: String
    let project: String
}

struct ContractByCustomerIDResponse: Codable, Identifiable {
    var id: String {
        contractID
    }
    let expiredTime: String
    let contractID: String
    let projectName: String
    let propertyCode: String
    let priceSold: Double
    let status: String
}
struct ContractStepOneResponse: Identifiable, Codable {
    let customer: Customer
    let property: Property
    let project: Project

    var id: String {
        customer.customerID
    }
}
struct Contract: Identifiable, Codable {
    let contractID: String
      let contractCode: String
      let contractType: String
      let createdTime: String
      let updatedTime: String?
      let expiredTime: String?
      let totalPrice: Double?
      let description: String?
      let contractDepositFile: String?
      let contractSaleFile: String?
      let priceSheetFile: String?
      let contractTransferFile: String?
      let status: String
      let documentTemplateID: String?
      let documentName: String?
      let bookingID: String
      let customerID: String
      let fullName: String
      let paymentProcessID: String?
      let paymentProcessName: String?
      let promotionDetailID: String?
    var id: String { contractID }
}

extension Contract {
    static var sample = Contract(contractID: "3fa85f64-5717-4562-b3fc-2c963f66afa6", contractCode: "", contractType: "", createdTime: "", updatedTime: "", expiredTime: "", totalPrice: 0, description: "", contractDepositFile: "", contractSaleFile: "", priceSheetFile: "", contractTransferFile: "", status: "", documentTemplateID: "", documentName: "", bookingID: "", customerID: "", fullName: "", paymentProcessID: "", paymentProcessName: "", promotionDetailID: "")
}
extension ContractByCustomerIDResponse {
    static var sample = ContractByCustomerIDResponse(expiredTime: "", contractID: "99da8a00-7f06-4a28-ae79-3dfc69c1873a", projectName: "Vinhomes Grand Park", propertyCode: "S302 3507", priceSold: 1200000000, status: "HAHHAHAHAH")
} 

// Extensions to create sample data
extension Customer {
    static var sample = Customer(
        customerID: "1fa73089-1213-467e-ac77-2d0d6b73ae51",
        fullName: "Huynh Nguyen Tuan Duy",
        dateOfBirth: "2024-10-06",
        phoneNumber: "0835488888",
        identityCardNumber: "000292909302939",
        nationality: "Việt Nam",
        placeOfOrigin: "Xã Hưng Yên, Huyện An Biên, Kiên Giang",
        placeOfResidence: "Xã Hưng Yên, Huyện An Biên, Kiên Giang",
        dateOfExpiry: nil,
        taxcode: "278237877",
        bankName: "Vietincc",
        bankNumber: "10920902399",
        address: "S302 Vinhomes Grand Park, Nguyen Xien, Long Thanh My",
        deviceToken: "fOuu00íW6hzM-yUA4SASN:APA91bFc5mt-V0beV1fAQIl9kfVvENoJ1KF00-yLy8dXsyF-O4sCN4d2LXaf1Rn4MYaqoTq-O_QVeUwnKVAgcCdP0AiAHuAkIyBi6D__syya3tpsc9lRnw4",
        status: true,
        accountID: "b771d4c8-6c21-44ae-b6a5-a3239eae2c76",
        email: "andyhntd2003@gmail.com"
    )
}

extension Property {
    static var sample = Property(
        propertyID: "527352ad-1a6f-414b-85fd-368c880a812b",
        propertyCode: "CH02",
        view: "Thoang dep",
        priceSold: 1000000000,
        status: "Giữ chỗ",
        unitTypeID: "f0347344-25b3-4aa8-994b-1df2b2771687",
        bathRoom: 2,
        bedRoom: 3,
        kitchenRoom: 1,
        livingRoom: 1,
        numberFloor: 1,
        basement: nil,
        netFloorArea: 92,
        grossFloorArea: 101.5,
        imageUnitType: "Image",
        floorID: "d7d63816-8dbd-4376-b30d-ff8a666369a7",
        numFloor: 2,
        blockID: "630c5ee1-1f44-48d0-accf-c28e05474090",
        blockName: "BE1",
        zoneID: "b179f06c-70ff-4732-a6f6-96f23448e1ed",
        zoneName: "The Bervely",
        projectCategoryDetailID: "b1009ee3-a532-42f6-a9cb-de9bc9c7b87d",
        projectName: "Vinhomes Ocean Park",
        propertyCategoryName: "Shophouse"
    )
}

extension Project {
    static var sampleProject = Project(
        projectID: "d1d901bc-2cdf-460c-ba34-086e4dec1d85",
        projectName: "Vinhomes Ocean Park",
        location: "15 xã Kiêu Kỵ, Đa Tốn và Dương Xá, huyện Gia Lâm, Hà Nội.",
        investor: "Mitsubishi Corporation và Vingroup",
        generalContractor: "Faros",
        designUnit: "Alinco",
        totalArea: "4 tòa Be1, Be2, Be3 và Be4; cao 24 – 26 tầng",
        scale: "422 ha",
        buildingDensity: "43%",
        totalNumberOfApartment: "53000",
        legalStatus: "Sở hữu không thời hạn",
        handOver: "Dự kiến tháng 8 năm 2025.",
        convenience: "Vinhomes Ocean Park được bao bọc bởi hơn 100 ha cây xanh, mặt nước và những bãi cát trắng mịn màng cùng hàng dừa xanh rợp bóng.",
        images: ["https://realestatesystem.blob.core.windows.net/projectimage/2fdc0d2c-0d3c-4351-af81-98eb2fc6b065_z5296946716703_91251820253476c865e0488ca2fb3e5f.jpg"],
        status: "Sắp mở bán",
        paymentPolicyID: "7f4df58a-61c6-4b2e-8aa0-9b0f6c711595",
        paymentPolicyName: "Thanh toán trễ hạn"
    )
}

extension ContractStepOneResponse {
    static var sample = ContractStepOneResponse(
        customer: .sample,
        property: .sample,
        project: .sampleProject
    )
}
extension PromotionDetail {
    static var sample = PromotionDetail(
        promotionDetailID: "9f0f15e6-d7ab-4a98-87b5-55541a08310e",
        description: "Khuyến mãi 2PN",
        amount: 280000000,
        promotionID: "e519437c-bfae-4ebf-893d-0743e7887523",
        promotionName: "Khuyến mãi nội thất",
        propertyTypeID: "d0092fb4-8d01-4ef1-bf1d-aadf00df2fc6",
        propertyTypeName: "Căn 2 phòng ngủ"
    )
}

extension PaymentProcess {
    static var sample = PaymentProcess(
        paymentProcessID: "377f82ab-88e9-409e-a53c-faa287ec3e7d",
        paymentProcessName: "Thanh toán 7 đợt",
        status: true,
        salesPolicyID: "f3a63ad4-a8bc-4824-9713-c16051a577a8",
        salesPolicyType: "Chính sách chung"
    )
}

extension PromotionAndPaymentResponse {
    static var sample = PromotionAndPaymentResponse(
        promotionDetail: .sample,
        paymentProcess: [.sample]
    )
}
