//
//  StepSevenView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 22/11/24.
//

import SwiftUI

struct StepSevenView: View {
    let contractID: String
    @StateObject var viewModel: StepSevenViewModel
    init(contractID: String) {
        self.contractID = contractID
        _viewModel = StateObject(wrappedValue: StepSevenViewModel(contractId: contractID, contractsService: ContractsService(httpClient: HTTPClient())))
    }
    var body: some View {
        VStack{
            VStack(alignment: .leading){
                Text("Đặt lịch nhận Hợp đồng mua bán")
                    .foregroundStyle(.primaryGreen)
                    .font(.title3)
                    .bold()
                HStack{
                    Image(.calendar)
                        .resizable()
                        .frame(width: 100, height: 100)
                    Spacer()
                    Text("Lưu ý: \(viewModel.stepSevenDetail?.message ?? "Quý khách chỉ có thể nhận HĐMB trong khoảng thời gian từ ngày 2024/11/23 tới ngày 2024/12/06")")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    StepSevenView()
//}
