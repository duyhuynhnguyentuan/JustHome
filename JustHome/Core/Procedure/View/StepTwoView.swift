//
//  StepTwoView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 20/11/24.
//

import SwiftUI

struct StepTwoView: View {
    @EnvironmentObject private var routerManager: NavigationRouter
    @State private var showingPDF = false
    @State private var isChecked1 = false
    @State private var isChecked2 = false
    @State private var isChecked3 = false
    let contractDepositFile: String
    let contractID: String
    var body: some View {
        VStack {
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
            NavigationLink {
                StepTwoOTPVerification(contractID: contractID)
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
struct CheckToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Label {
                configuration.label
            } icon: {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(configuration.isOn ? Color.accentColor : .secondary)
                    .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                    .imageScale(.large)
            }
        }
        .buttonStyle(.plain)
    }
}
//#Preview {
//    StepTwoView(contractDepositFile: "https://realestatesystem.blob.core.windows.net/contractdepositfile/1708a333-bb27-45f7-ab1e-d81db151053e_Thỏa thuận đặt cọc")
//}

