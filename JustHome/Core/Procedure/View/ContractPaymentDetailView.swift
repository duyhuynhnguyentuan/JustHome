//
//  ContractPaymentDetailView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 23/11/24.
//

import SwiftUI

struct ContractPaymentDetailView: View {
    let contractID: String
    @StateObject var contractPaymentDetailViewModel: ContractPaymentDetailViewModel
    init(contractID: String) {
        self.contractID = contractID
        _contractPaymentDetailViewModel = StateObject(wrappedValue: ContractPaymentDetailViewModel(contractID: contractID, contractPaymentDetailService: ContractPaymentDetailService(httpClient: HTTPClient())))
    }
    var body: some View {
        switch contractPaymentDetailViewModel.loadingState {
        case .idle:
            EmptyView()
        case .loading:
            ProgressView()
        case .finished:
        VStack(alignment: .leading){
            Text("Thông tin các đợt thanh toán")
                .foregroundStyle(.primaryGreen)
                .font(.title3)
                .bold()
            ForEach(contractPaymentDetailViewModel.contractPaymentDetails){ detail in
                NavigationLink(value: Route.contractPaymentDetailUpload(contractPaymentDetail: detail)){
                    VStack(alignment: .leading){
                        Text("Thanh toán lần thứ: \(detail.paymentRate)")
                            .font(.title3)
                            .bold()
                            .italic()
                        if let _ = detail.remittanceOrder {
                            detail.status ?
                            Label("Staff đã xác nhận", systemImage: "checkmark.seal.fill")
                                .foregroundStyle(.green)
                                .font(.caption) :   Label("Staff chưa xác nhận phiếu nhiệm chi đã upload", systemImage: "x.circle.fill")
                                .foregroundStyle(.red)
                                .font(.caption)
                        }else{
                            Label("Chưa upload ủy nhiệm chi", systemImage: "x.circle.fill")
                                .foregroundStyle(.red)
                                .font(.caption)
                        }
                        Divider()
                        Text("Mô tả: \(detail.description ?? "N/A")")
                        Text("Giai đoạn: \(detail.period)")
                        Text("Mã hợp đồng: \(detail.contractCode)")
                        Text("Chính sách thanh toán: \(detail.paymentPolicyName)")
                        Divider()
                        Text("Giá trị: \(Double(detail.paidValue), format: .currency(code: "VND"))")
                            .font(.callout)
                            .bold()
                        Text("Giá trị thanh toán trễ hạn: \(Double(detail.paidValueLate ?? 0), format: .currency(code: "VND")) ")
                            .font(.callout)
                            .bold()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.background)
                            .shadow(
                                color: Color.primaryGreen.opacity(0.7),
                                radius: 8,
                                x: 0,
                                y: 0
                            )
                    )
                    .padding(.horizontal, 5)
                    .frame(maxWidth: .infinity)
                }
                .disabled(detail.status)
                Divider()
            }
        }
        .padding(.horizontal)
    }
    }
}

//#Preview {
//    ContractPaymentDetailView()
//}
