//
//  ContractDetailView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 18/11/24.
//

import SwiftUI

struct ContractDetailView: View {
    @State private var isPresentedProgressSheet = false
    ///show confirmation dialog toggle
    let contractID: String
    @StateObject var viewModel: ContractDetailViewModel
    init(contractID: String){
        self.contractID = contractID
        _viewModel = StateObject(wrappedValue: ContractDetailViewModel(contractID: contractID, contractsService: ContractsService(httpClient: HTTPClient())))
    }
    var body: some View {
        ScrollView(.vertical){
            switch viewModel.loadingState {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
            case .finished:
                if let status = viewModel.contractStatus {
                    VStack{
                        Text("\(viewModel.contractTitle?.project ?? "") - \(viewModel.contractTitle?.property ?? "")")
                            .font(.callout.weight(.semibold))
                            .foregroundStyle(.secondary)
                        switch status {
                        case .choxacnhanTTDG:
                            StepOneView(contractID: contractID)
                        case .choxacnhanTTDC:
                            StepTwoView(contractDepositFile: viewModel.contract?.contractDepositFile ?? "https://realestatesystem.blob.core.windows.net/contractdepositfile/1708a333-bb27-45f7-ab1e-d81db151053e_Thỏa thuận đặt cọc", contractID: contractID)
                        case .daxacnhanTTDC:
                            StepThreeView(contractID: contractID)
                        case .daxacnhanchinhsachbanhang:
                            StepFourView(contractID: contractID, priceSheetFile: viewModel.contract?.priceSheetFile ?? "https://realestatesystem.blob.core.windows.net/pricefile/396f7f0f-cf2b-41fe-9b47-baa2000ce0a3_Phiếu tính giá")
                        case .daxacnhanphieutinhgia:
                            StepFiveView(contractID: contractID)
                        case .dathanhtoandot1hopdongmuaban:
                            StepSixView(contractSaleFile: viewModel.contract?.contractSaleFile ?? "", contractID: contractID)
                        case .daxacnhanhopdongmuaban:
                            StepSevenView(contractID: contractID)
                                .padding(.top)
                            ContractPaymentDetailView(contractID: contractID)
                        case .dabangiaoquyensohuudat:
                            VStack{
                                Image(systemName: "checkmark.shield.fill")
                                    .foregroundStyle(.primaryGreen)
                                Text("Chúc mừng bạn đã thành công sở hữu đất!")
                                    .bold()
                                ContractPaymentDetailView(contractID: contractID)
                            }
                        case .dahuy:
                            VStack {
                                Image(systemName: "exclamationmark.octagon.fill")
                                    .foregroundStyle(.red)
                                Text("Hợp đồng đã bị hủy!")
                                    .bold()
                            }
                        case .choxacnhanTTCN:
                            ConfirmTransferContractView(contractTransferFile: viewModel.contract?.contractTransferFile ?? "https://realestatesystem.blob.core.windows.net/pricefile/396f7f0f-cf2b-41fe-9b47-baa2000ce0a3_Phiếu tính giá", contractID: contractID)
                        case .daxacnhanchuyennhuong:
                            VStack{
                                Image(systemName: "checkmark.shield.fill")
                                    .foregroundStyle(.primaryGreen)
                                Text("Chúc mừng bạn đã chuyển nhượng thành công!")
                                    .bold()
                            }
                        case .choxacnhanTTCNTTDC:
                            ConfirmReceiveContractView(contractID: contractID, contractDepositFile: viewModel.contract?.contractDepositFile ?? "https://realestatesystem.blob.core.windows.net/contractdepositfile/1708a333-bb27-45f7-ab1e-d81db151053e_Thỏa thuận đặt cọc")
                        }
                    }
                    .alert(item: $viewModel.error) { error in
                        // Handle alert cases
                        switch error {
                        case .badRequest:
                            return Alert(
                                title: Text("Bad Request"),
                                message: Text("Unable to perform the request."),
                                dismissButton: .default(Text("OK"))
                            )
                        case .decodingError(let decodingError):
                            return Alert(
                                title: Text("Decoding Error"),
                                message: Text(decodingError.localizedDescription),
                                dismissButton: .default(Text("OK"))
                            )
                        case .invalidResponse:
                            return Alert(
                                title: Text("Invalid Response"),
                                message: Text("The server response was invalid."),
                                dismissButton: .default(Text("OK"))
                            )
                        case .errorResponse(let errorResponse):
                            return Alert(
                                title: Text("Lỗi"),
                                message: Text(errorResponse.message ?? "An unknown error occurred."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                    .navigationTitle(status.rawValue)
                    .toolbar {
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            Button{
                                isPresentedProgressSheet = true
                            }label: {
                                Image(systemName: "info.circle")
                                    .tint(Color.red)
                            }
                        }
                    }
                    .sheet(isPresented: $isPresentedProgressSheet) {
                        ContractProgressView(contractStatus: viewModel.contractStatus!)
                            .presentationDetents([.medium, .large])
                            .presentationDragIndicator(.visible)
                            
                    }
                }
            }
        }
        .refreshable{
            viewModel.handleRefresh()
        }
    }
}

//#Preview {
//    ContractDetailView()
//}
