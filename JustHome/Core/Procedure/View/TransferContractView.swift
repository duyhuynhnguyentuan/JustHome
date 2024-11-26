//
//  TransferContractView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 23/11/24.
//

import SwiftUI

struct TransferContractView: View {
    let contractID: String
    @StateObject var viewModel: TransferContractViewModel
    @State private var isSheetPresented = false
    @State private var showConfirmationDialog = false
    @EnvironmentObject private var routerManager : NavigationRouter
    init(contractID: String) {
        self.contractID = contractID
        _viewModel = StateObject(wrappedValue: TransferContractViewModel(contractId: contractID, contractService: ContractsService(httpClient: HTTPClient())))
    }
    var body: some View {
        switch viewModel.loadingState {
        case .idle:
            EmptyView()
        case .loading:
            ProgressView()
        case .finished:
        VStack{
            Text("Để thực hiện giao dịch chuyển nhượng thỏa thuận đặt cọc, quý khách vui lòng điền các thông tin theo nội dung dưới đây")
                .font(.caption)
                .foregroundStyle(.primaryGreen)
            Divider()
            Text("Thông tin bên chuyển nhượng")
                .font(.title2)
                .bold()
                .foregroundStyle(.secondaryGreen)
                .padding(.bottom)
            //Customer detail cell
            if viewModel.loadingState == .loading {
                ProgressView()
            }else {
                VStack{
                    HStack{
                        VStack(alignment: .leading){
                            if let selectedTransferee = viewModel.selectedTransferee {
                                Text("Đã chọn:")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                                Text(selectedTransferee.fullName)
                                    .font(.title3.bold())
                                Text("Số CCCD: \(selectedTransferee.identityCardNumber ?? "N/A")")
                                    .font(.headline)
                                Text("Ngày sinh: \(selectedTransferee.dateOfBirth)")
                                    .font(.callout)
                                Text("Số điện thoại: \(selectedTransferee.phoneNumber) ")
                                    .font(.callout)
                                Text("Email: \(selectedTransferee.email) ")
                                    .font(.callout)
                            }else{
                                Text("Chưa chọn bên chuyển nhượng")
                                    .font(.title3.bold())
                                    .foregroundStyle(.yellow)
                            }
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                .onTapGesture {
                    isSheetPresented.toggle()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.primaryGreen, lineWidth: 3)
                )
            }
            //Confirm button
            Spacer()
            Button{
                showConfirmationDialog.toggle()
            }label: {
                Text("XÁC NHẬN")
                    .font(.title3)
                    .fontDesign(.rounded)
                    .modifier(JHButtonModifier())
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
        .confirmationDialog("Bạn đã chắc chắn thông tin là chính xác?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
            Button("Có", role: .destructive) {
                Task{
                    let response = try await viewModel.checkCustomerTransferred(customerTransfereeId: viewModel.selectedTransferee!.customerID)
                    if(response.message != nil){
                        routerManager.push(to: .procedure)
                        routerManager.reset()
                    }
                }
            }
            Button("Hủy", role: .cancel) {}
        }
        .padding(.horizontal)
        .sheet(isPresented: $isSheetPresented) {
            TransfereeSelectionView(viewModel: viewModel)
        }
      }
    }
}
struct TransfereeSelectionView: View {
    @ObservedObject var viewModel: TransferContractViewModel
    @State private var searchText = ""

    var filteredTransferees: [Customer] {
        if searchText.isEmpty {
            return viewModel.transfereeList
        } else {
            return viewModel.transfereeList.filter { transferee in
                transferee.identityCardNumber?.contains(searchText) == true ||
                transferee.fullName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Tìm kiếm theo số CCCD hoặc tên", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                List(filteredTransferees, id: \.id) { transferee in
                    VStack(alignment: .leading) {
                        Text(transferee.fullName)
                            .font(.headline)
                        Text("Số CCCD: \(transferee.identityCardNumber ?? "")")
                            .font(.subheadline)
                        if transferee == viewModel.selectedTransferee {
                            Text("Đã chọn bên chuyển nhượng này ✅ ")
                                .foregroundStyle(.green)
                                .font(.callout.bold())
                        }
                    }
                    .onTapGesture {
                        viewModel.selectedTransferee = transferee
                    }
                }
            }
            .navigationTitle("Bên chuyển nhượng")
            .navigationBarItems(trailing: Button("Đóng") {
                viewModel.loadData()
            })
        }
    }
}
//#Preview {
//    TransferContractView()
//}
