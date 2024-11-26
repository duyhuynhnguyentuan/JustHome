//
//  StepThreeView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 20/11/24.
//

import SwiftUI

struct StepThreeView: View {
    @StateObject var viewModel: StepThreeViewModel
    @State private var selectedPaymentProcessID: String?
    @State private var stepThreeConfirmationDialogIsPresented: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @EnvironmentObject private var routerManager: NavigationRouter
    let contractID: String
    init(contractID: String){
        self.contractID = contractID
        _viewModel = StateObject(wrappedValue: StepThreeViewModel(contractID: contractID, contractsService: ContractsService(httpClient: HTTPClient())))
    }
    var body: some View {
        switch viewModel.loadingState {
        case .idle:
            EmptyView()
        case .loading:
            ProgressView()
        case .finished:
            VStack{
                Text("Chính sách ưu đãi và phương thức thanh toán")
                    .font(.callout.bold())
                HStack{
                    VStack(alignment: .leading){
                        Text(viewModel.stepThreeContract?.promotionDetail.promotionName ?? "")
                            .font(.title3.bold())
                        Text("Loại: \(viewModel.stepThreeContract?.promotionDetail.propertyTypeName ?? "")")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text("Tên khuyến mãi: \(viewModel.stepThreeContract?.promotionDetail.promotionName ?? "")")
                            .font(.caption.bold())
                            .foregroundStyle(.red)
                        
                    }
                    Spacer()
                    VStack(alignment: .leading){
                        Text("Tổng tiền: ")
                        Text(viewModel.stepThreeContract?.promotionDetail.amount ?? 0, format: .currency(code: "VND"))
                    }.foregroundStyle(.primaryGreen)
                }
                .fontDesign(.rounded)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.primaryGreen, lineWidth: 3)
                )
                .padding()
                // selection
                
                VStack{
                    Text("Các phương án thanh toán")
                    Divider()
                    //put picker here
                    Picker("Tên phương án", selection: $selectedPaymentProcessID) {
                        ForEach(viewModel.stepThreeContract?.paymentProcess ?? []) { process in
                            Text(process.paymentProcessName)
                                .tag(process.paymentProcessID)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .modifier(JHTextFieldModifier())
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
                .padding(.horizontal)
                .padding(.bottom)
                //Button
                Button {
                    stepThreeConfirmationDialogIsPresented.toggle()
                } label: {
                    Text("Xác nhận thông tin")
                        .font(.headline)
                        .fontDesign(.rounded)
                        .modifier(JHButtonModifier())
                }
                Text("Hoặc")
                    .foregroundStyle(.secondary)
                
                NavigationLink {
                    TransferContractView(contractID: contractID)
                } label: {
                    Text("Chuyển nhượng thỏa thuận đặt cọc")
                        .font(.title3.weight(.black))
                        .fontDesign(.rounded)
                        .modifier(JHButtonModifier(backgroundColor: .teal))
                }
                
            }
            .confirmationDialog("Bạn đã chắc chắn?", isPresented: $stepThreeConfirmationDialogIsPresented, titleVisibility: .visible) {
                Button("Có", role: .destructive) {
                    Task {
                        let response = try await viewModel.checkStepThreeContract(contractID: contractID, promotionDetailID: viewModel.stepThreeContract?.promotionDetail.promotionDetailID ?? "", paymentProcessID: selectedPaymentProcessID ?? "")
                        if let message = response.message {
                            alertMessage = message
                            showAlert = true
                        }
                    }
                }
            }
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK") {
                    routerManager.push(to: .procedure)
                    routerManager.reset()
                }
            }
         }
    }
}

//#Preview {
//    StepThreeView(promotionAndPaymentResponse: PromotionAndPaymentResponse.sample)
//}
