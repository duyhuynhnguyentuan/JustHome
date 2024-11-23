//
//  ConfirmTransferContractView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 23/11/24.
//

import SwiftUI

struct ConfirmTransferContractView: View {
    @EnvironmentObject private var routerManager: NavigationRouter
    @State private var showingPDF = false
    @State private var isChecked1 = false
    @State private var isChecked2 = false
    @State private var isChecked3 = false
    let contractTransferFile: String
    let contractID: String
    var body: some View {
        VStack {
            Button {
                showingPDF = true
            } label: {
                HStack(alignment: .top) {
                    Image(.pdfIcon)
                    VStack(alignment: .leading) {
                        Text("Mẫu thỏa thuận chuyển nhượng.pdf")
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
                    Text("Tôi đã đọc, hiểu rõ, và đồng ý toàn bộ nội dung của Thỏa thuận chuyển nhượng trên.")
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
            NavigationLink {
                ConfirmTransferContractOTPVerification(contractID: contractID)
                    .toolbar(.hidden, for: .tabBar)
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
        .padding(.horizontal)
        .sheet(isPresented: $showingPDF) {
            if let pdfURL = URL(string: contractTransferFile) {
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
//    ConfirmTransferContractView()
//}
