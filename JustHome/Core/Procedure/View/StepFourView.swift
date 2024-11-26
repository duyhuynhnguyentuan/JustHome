//
//  StepFourView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 21/11/24.
//

import SwiftUI

struct StepFourView: View {
    @State private var stepFourConfirmationDialogIsPresented: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @StateObject var viewModel: StepFourViewModel
    @EnvironmentObject private var routerManager: NavigationRouter
    let contractID: String
    init(contractID: String, priceSheetFile: String){
        self.contractID = contractID
        _viewModel = StateObject(wrappedValue: StepFourViewModel(contractId: contractID, contractsService: ContractsService(httpClient: HTTPClient())))
        self.priceSheetFile = priceSheetFile
    }
    let priceSheetFile: String
    @State private var showingPDF = false
    var body: some View {
        switch viewModel.loadingState {
        case .idle:
            EmptyView()
        case .loading:
            ProgressView()
        case .finished:
        VStack{
            Text("Xác nhận thông tin và hợp HDMB & PTG")
                .font(.callout.bold())
            Button {
                showingPDF = true
            } label: {
                HStack(alignment: .top) {
                    Image(.pdfIcon)
                    VStack(alignment: .leading) {
                        Text("Phieu-tinh-gia.pdf")
                            .font(.title3.bold())
                            .foregroundStyle(.primaryText)
                        Text("Nhấn vào để xem chi tiết")
                            .font(.callout)
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.primaryGreen, lineWidth: 2)
                )
            }
            //thong tin khach hang
            VStack {
                Text("Thông tin khách hàng")
                    .font(.headline)
                Divider()
                    .padding(.bottom)
                HStack {
                    Text("Họ tên:")
                        .bold()
                    Spacer()
                    Text(viewModel.stepFourResponse?.fullName ?? "N/A")
                }
                .font(.callout)
                Divider()
                HStack {
                    Text("Số CCCD/CMND:")
                        .bold()
                    Spacer()
                    Text(viewModel.stepFourResponse?.identityCardNumber ?? "N/A")
                }
                .font(.callout)
                Divider()
                HStack(alignment: .top) {
                    Text("Quê quán:")
                        .bold()
                    Spacer()
                    Text(viewModel.stepFourResponse?.placeofOrigin ?? "N/A")
                }
                .font(.callout)
                Divider()
                HStack {
                    Text("Ngày hết hạn:")
                        .bold()
                    Spacer()
                    Text(viewModel.stepFourResponse?.dateOfExpiry ?? "N/A")
                }
                .font(.callout)
                Divider()
                HStack {
                    Text("Email:")
                        .bold()
                    Spacer()
                    Text(viewModel.stepFourResponse?.email ?? "N/A")
                }
                .font(.callout)
                Divider()
                HStack {
                    Text("Ngày sinh:")
                        .bold()
                    Spacer()
                    Text(viewModel.stepFourResponse?.dateOfBirth ?? "N/A")
                }
                .font(.callout)
                Divider()
                HStack {
                    Text("Quốc tịch:")
                        .bold()
                    Spacer()
                    Text(viewModel.stepFourResponse?.nationality ?? "N/A")
                }
                .font(.callout)
                Divider()
                HStack {
                    Text("Số điện thoại:")
                        .bold()
                    Spacer()
                    Text(viewModel.stepFourResponse?.phoneNumber ?? "N/A")
                }
                .font(.callout)
                Divider()
                HStack(alignment: .top) {
                    Text("Địa chỉ liên hệ:")
                        .bold()
                    Spacer()
                    Text(viewModel.stepFourResponse?.address ?? "N/A")
                }
                .font(.callout)
                Divider()
                HStack(alignment: .top) {
                    Text("Địa chỉ thường trú:")
                        .bold()
                    Spacer()
                    Text(viewModel.stepFourResponse?.placeOfResidence ?? "N/A")
                }
                .font(.callout)
                .padding(.bottom)
                Text("*Quý khách vui lòng kiểm tra kỹ giá BDS, thông tin chiết khấu, tiến độ thanh toán, mã BDS, tên khách hàng trước khi ấn nút xác nhận bên dưới")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
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
            Button{
                stepFourConfirmationDialogIsPresented.toggle()
            }label: {
                Text("Xác nhận")
                    .font(.title3.bold())
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
        .confirmationDialog("Bạn đã chắc chắn thông tin là chính xác?", isPresented: $stepFourConfirmationDialogIsPresented, titleVisibility: .visible) {
            Button("Có", role: .destructive) {
                Task {
                    let response = try await viewModel.checkStepFourContract(by: contractID)
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
        .padding(.horizontal)
        .sheet(isPresented: $showingPDF) {
            if let pdfURL = URL(string: priceSheetFile) {
                VStack {
                    HStack {
                        ShareLink(item: pdfURL) {
                            Label("Chia sẻ file PDF", systemImage: "square.and.arrow.up")
                        }
                        .bold()
                        Spacer()
                        Button {
                            showingPDF = false
                        } label: {
                            Image(systemName: "xmark")
                                .font(.caption2)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color.black.opacity(0.35))
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    // MARK: - PDF View
                    PDFViewRepresentable(url: pdfURL)
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
}
}

//#Preview {
//    StepFourView(priceSheetFile: "https://realestatesystem.blob.core.windows.net/pricefile/9af07817-1b31-4442-81b2-40a24be72d0c_Phiếu tính giá")
//}
