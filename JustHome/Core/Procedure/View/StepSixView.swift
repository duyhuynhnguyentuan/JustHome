//
//  StepSixView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 21/11/24.
//

import SwiftUI

struct StepSixView:View {
    @EnvironmentObject private var routerManager: NavigationRouter
    @State private var showingPDF = false
    let contractSaleFile: String
    let contractID: String
    var body: some View {
        VStack{
            Button {
                showingPDF = true
            } label: {
                HStack(alignment: .top) {
                    Image(.pdfIcon)
                    VStack(alignment: .leading) {
                        Text("Hợp đồng mua bán.pdf")
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
            Text("Hợp đồng mua bán đã được xác lập với các nội dung nêu trên. Quý khách vui lòng xác nhận để xác nhận thủ tục online.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)
            NavigationLink {
                StepSixOTPVerification(contractID: contractID)
                    .toolbar(.hidden, for: .tabBar)
            } label: {
                Text("Xác nhận")
                    .font(.title2.weight(.black))
                    .fontDesign(.rounded)
                    .modifier(JHButtonModifier())
            }
        }
        .padding(.horizontal)
        .sheet(isPresented: $showingPDF) {
            if let pdfURL = URL(string: contractSaleFile) {
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
