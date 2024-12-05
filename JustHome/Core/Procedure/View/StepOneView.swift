//
//  StepOneView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 19/11/24.
//

import SwiftUI


struct StepOneView: View {
    let contractID: String
    @StateObject private var viewModel: StepOneViewModel
    @State private var stepOneConfirmationDialogIsPresented: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @EnvironmentObject private var routerManager: NavigationRouter

    init(contractID: String) {
        self.contractID = contractID
        _viewModel = StateObject(wrappedValue: StepOneViewModel(contractId: contractID, contractsService: ContractsService(httpClient: HTTPClient())))
    }

    let screenWidth = UIScreen.main.bounds.width

    var body: some View {
        switch viewModel.loadingState {
        case .idle:
            EmptyView()
        case .loading:
            ProgressView()
        case .finished:
            VStack {
                VStack(alignment: .leading) {
                    ZStack(alignment: .bottomLeading) {
                        AsyncImage(url: URL(string: viewModel.stepOneContractDetail?.project.images.first ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: screenWidth * 0.95, height: screenWidth / 1.75)
                                .cornerRadius(15)
                        } placeholder: {
                            Color(.secondarySystemBackground)
                                .frame(width: screenWidth * 0.95, height: screenWidth / 1.75)
                                .cornerRadius(15)
                        }
                        Text("Niêm yết: \(Double(viewModel.stepOneContractDetail?.property.priceSold ?? 0), format: .currency(code: "VND"))")
                            .font(.footnote)
                            .bold()
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.red
                                .mask(Capsule()))
                            .foregroundColor(Color.white)
                            .cornerRadius(5)
                            .padding([.leading, .bottom], 10)
                    }
                    Text("Dự án \(viewModel.stepOneContractDetail?.project.projectName ?? "")")
                        .font(.title3.bold())
                        .fontDesign(.rounded)
                    Text("Đã chọn: \(viewModel.stepOneContractDetail?.property.propertyCode ?? "") - \(viewModel.stepOneContractDetail?.property.blockName ?? "") - Khu \(viewModel.stepOneContractDetail?.property.zoneName ?? "")")
                        .font(.headline)
                        .foregroundStyle(.primaryGreen)
                    Text("Diện tích: \(String(format: "%.1f", viewModel.stepOneContractDetail?.property.netFloorArea ?? 0)) m² (Thông thủy) & \(String(format: "%.1f", viewModel.stepOneContractDetail?.property.grossFloorArea ?? 0)) m² (Tim tường)")
                        .font(.caption)
                    Text("Loại căn hộ: \(viewModel.stepOneContractDetail?.property.bedRoom ?? 0)PN - \(viewModel.stepOneContractDetail?.property.bathRoom ?? 0)WC")
                        .font(.caption)
                }
                CustomerInfo()
                    .padding(.top)
                Button {
                    stepOneConfirmationDialogIsPresented.toggle()
                } label: {
                    Text("XÁC NHẬN THÔNG TIN")
                        .font(.headline)
                        .fontDesign(.rounded)
                        .modifier(JHButtonModifier())
                }
            }
            .confirmationDialog("Bạn đã chắc chắn thông tin là chính xác?", isPresented: $stepOneConfirmationDialogIsPresented, titleVisibility: .visible) {
                Button("Có", role: .destructive) {
                    Task {
                        let response = try await viewModel.checkStepOneContract(by: contractID)
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

    @ViewBuilder
    func CustomerInfo() -> some View {
        VStack {
            Text("Thông tin khách hàng")
                .font(.headline)
            Divider()
                .padding(.bottom)
            HStack {
                Text("Họ tên:")
                    .bold()
                Spacer()
                Text(viewModel.stepOneContractDetail?.customer.fullName ?? "N/A")
            }
            .font(.callout)
            Divider()
            HStack {
                Text("Số CCCD/CMND:")
                    .bold()
                Spacer()
                Text(viewModel.stepOneContractDetail?.customer.identityCardNumber ?? "N/A")
            }
            .font(.callout)
            Divider()
            HStack(alignment: .top) {
                Text("Quê quán:")
                    .bold()
                Spacer()
                Text(viewModel.stepOneContractDetail?.customer.placeOfOrigin ?? "N/A")
            }
            .font(.callout)
            Divider()
            HStack {
                Text("Ngày hết hạn:")
                    .bold()
                Spacer()
                Text(viewModel.stepOneContractDetail?.customer.dateOfExpiry ?? "N/A")
            }
            .font(.callout)
            Divider()
            HStack {
                Text("Email:")
                    .bold()
                Spacer()
                Text(viewModel.stepOneContractDetail?.customer.email ?? "N/A")
            }
            .font(.callout)
            Divider()
            HStack {
                Text("Ngày sinh:")
                    .bold()
                Spacer()
                Text(viewModel.stepOneContractDetail?.customer.dateOfBirth ?? "N/A")
            }
            .font(.callout)
            Divider()
            HStack {
                Text("Quốc tịch:")
                    .bold()
                Spacer()
                Text(viewModel.stepOneContractDetail?.customer.nationality ?? "N/A")
            }
            .font(.callout)
            Divider()
            HStack {
                Text("Số điện thoại:")
                    .bold()
                Spacer()
                Text(viewModel.stepOneContractDetail?.customer.phoneNumber ?? "N/A")
            }
            .font(.callout)
            Divider()
            HStack(alignment: .top) {
                Text("Địa chỉ liên hệ:")
                    .bold()
                Spacer()
                Text(viewModel.stepOneContractDetail?.customer.address ?? "N/A")
            }
            .font(.callout)
            Divider()
            HStack(alignment: .top) {
                Text("Địa chỉ thường trú:")
                    .bold()
                Spacer()
                Text(viewModel.stepOneContractDetail?.customer.placeOfResidence ?? "N/A")
            }
            .font(.callout)
            .padding(.bottom)
            Text("Quý khách vui lòng kiểm tra thông tin cá nhân, nếu có sai xót xin vui lòng chỉnh sửa ở trang cá nhân")
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
        .padding(.horizontal)
    }
}

//
//#Preview {
//    StepOneView(contractID: ContractStepOneResponse.sample)
//}
