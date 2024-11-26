//
//  ConfirmReceiveContractView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 23/11/24.
//

import SwiftUI

struct ConfirmReceiveContractView: View {
    @State private var showAlert: Bool = false
    @State private var confirmationDialogIsPresented: Bool = false
    @State private var alertMessage: String = ""

    @StateObject var viewModel: ConfirmReceiveContractViewModel
    @EnvironmentObject private var routerManager: NavigationRouter
    @State private var showingPDF = false
    @State private var isChecked1 = false
    @State private var isChecked2 = false
    @State private var isChecked3 = false
    let contractDepositFile: String
    let contractID: String
    init(contractID: String, contractDepositFile: String){
        _viewModel = StateObject(wrappedValue: ConfirmReceiveContractViewModel(contractId: contractID, contractsService: ContractsService(httpClient: HTTPClient())))
        self.contractID = contractID
        self.contractDepositFile = contractDepositFile
    }
    var body: some View {
        VStack {
            Text("Thỏa thuận chuyển nhượng thỏa thuận đặt cọc")
                .font(.callout.bold())
                .foregroundStyle(.primaryGreen)
            Text("Dưới đây là thỏa thuận đặt cọc đã được bên chuyển nhượng và chủ đầu tư xác nhận. Quý khách vui lòng đọc kĩ các nội dung trong thỏa thuận và xác nhận để hoàn tất quy trình chuyển nhượng.")
                .font(.caption)
                .multilineTextAlignment(.leading)
            Button {
                showingPDF = true
            } label: {
                HStack(alignment: .top) {
                    Image(.pdfIcon)
                    VStack(alignment: .leading) {
                        Text("Mẫu thỏa thuận đặt cọc.pdf")
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
            
            // Checkboxes
            VStack(alignment: .leading, spacing: 10) {
                Toggle(isOn: $isChecked1) {
                    Text("Tôi cam kết các thông tin được cung cấp tại đây là hoàn toàn chính xác")
                        .multilineTextAlignment(.leading)
                }
                .toggleStyle(CheckToggleStyle())
                
                Toggle(isOn: $isChecked2) {
                    Text("Tôi đã đọc, hiểu rõ, và đồng ý toàn bộ nội dung của Thỏa thuận đặt cọc trên cũng như chính sách bán hàng áp dụng tại thời điểm đặt mua BDS này trên JustHome.")
                        .multilineTextAlignment(.leading)
                }
                .toggleStyle(CheckToggleStyle())
                
                Toggle(isOn: $isChecked3) {
                    Text("Tôi đồng ý với các điều kiện và điều khoản của JustHome")
                        .multilineTextAlignment(.leading)
                }
                .toggleStyle(CheckToggleStyle())
            }
            Divider()
            // Confirmation Button
            Button {
                confirmationDialogIsPresented.toggle()
            } label: {
                (isChecked1 && isChecked2 && isChecked3) ?
                Text("Xác nhận")
                    .font(.title2.weight(.black))
                    .fontDesign(.rounded)
                    .modifier(JHButtonModifier())
                :
                Text("Chưa xác nhận")
                    .font(.title2.weight(.black))
                    .fontDesign(.rounded)
                    .modifier(JHButtonModifier(backgroundColor: .gray))
            }
            .disabled(!(isChecked1 && isChecked2 && isChecked3))  // Disable if not all are checked
            
        }
        .confirmationDialog("Bạn đã chắc chắn thông tin là chính xác?", isPresented: $confirmationDialogIsPresented, titleVisibility: .visible) {
            Button("Có", role: .destructive) {
                Task {
                    let response = try await viewModel.confirmReceiveContract()
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
            if let pdfURL = URL(string: contractDepositFile) {
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

//#Preview {
//    ConfirmReceiveContractView()
//}
