//
//  PersonalInfoView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 4/11/24.
//

import SwiftUI

struct PersonalInfoView: View {
    @StateObject var viewModel: PersonalInfoViewModel
    init(){
        _viewModel = StateObject(wrappedValue: PersonalInfoViewModel(customerService: CustomerService(httpClient: HTTPClient())))
    }
    var body: some View {
        VStack(alignment: .center){
            switch viewModel.loadingState {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
            case .finished:
            if (viewModel.customer?.identityCardNumber) != nil {
                personalDetails()
            }else{
                Text("Bạn chưa cập nhật giấy tờ tùy thân nào")
                    .font(.title2.bold())
                    .foregroundStyle(.red)
            }
            NavigationLink{
                IdentityCardTextRecognizing()
                    .navigationBarBackButtonHidden()
            }label: {
                Text("Thay đổi giấy tờ tùy thân")
                    .modifier(JHButtonModifier())
            }
        }
        }
        .onAppear(){
            viewModel.loadData()
        }
        .padding(.horizontal)
        .navigationTitle("Giấy tờ tùy thân")
        .navigationBarTitleDisplayMode(.inline)
    }
    func personalDetails() -> some View {
        VStack{
            List{
                LabeledContent{
                    Text((viewModel.customer?.identityCardNumber ?? ""))
                }label: {
                    Text("Số căn cước:")
                }
                LabeledContent{
                    Text((viewModel.customer?.dateOfExpiry ?? ""))
                }label: {
                    Text("Ngày hết hạn:")
                }
                LabeledContent{
                    Text((viewModel.customer?.placeOfResidence ?? ""))
                }label: {
                    Text("Nơi thường chú:")
                }
                LabeledContent{
                    Text((viewModel.customer?.placeofOrigin ?? ""))
                }label: {
                    Text("Quê quán:")
                }
                LabeledContent{
                    Text("\(viewModel.customer?.bankNumber ?? "N/A")(\(viewModel.customer?.bankName ?? "N/A"))")
                }label: {
                    Text("Số tài khoản")
                }
                LabeledContent{
                    Text((viewModel.customer?.taxcode ?? ""))
                }label: {
                    Text("Mã số thuế")
                }
            }
            .listStyle(.plain)
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
           .padding(.horizontal, 5)
           .frame(maxWidth: .infinity)
    }
}

#Preview {
    PersonalInfoView()
}
