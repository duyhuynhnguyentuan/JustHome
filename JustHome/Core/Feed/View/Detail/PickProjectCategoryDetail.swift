//
//  PickProjectCategoryDetail.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 19/10/24.
//

import SwiftUI

struct PickProjectCategoryDetail: View {
    @Binding var isPresented: Bool
    ///show confirmation dialog toggle
    @State private var confirmationDialogIsPresented: Bool = false
    @Environment(\.properties) private var props
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var routerManager : NavigationRouter
    let projectID: String
    @Namespace var animation
    @StateObject private var viewModel: PickProjectCategoryDetailViewModel
    init(projectID: String,isPresented: Binding<Bool>) {
        self.projectID = projectID
        self._isPresented = isPresented
        _viewModel = StateObject(wrappedValue: PickProjectCategoryDetailViewModel(projectID: projectID))
    }
    var body: some View {
        VStack{
            HStack{
                Text("Loại bất động sản")
                    .font(.title)
                    .bold()
                Spacer()
                Button{
                    dismiss()
                }label: {
                    Image(systemName: "xmark")
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.black.opacity(0.35))
                        .clipShape(Circle())
                }
            }
            .padding(.top)
            HStack{
                Text(viewModel.projectCategoryDetail.first?.projectName ?? "")
                    .font(.title3)
                    .foregroundStyle(.secondaryGreen)
                Spacer()
            }
            VStack(spacing: 10){
                ForEach(viewModel.projectCategoryDetail, id: \.id){ projectCategoryDetail in
                    if (projectCategoryDetail.openForSale){
                        Text(projectCategoryDetail.propertyCategoryName)
                            .font(.title2)
                            .bold()
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(viewModel.selectedCategoryDetail == projectCategoryDetail ? Color.primaryGreen.opacity(0.4) : Color.clear )
                                    .stroke(Color.gray,lineWidth: 3)
                                    .frame(width: props.size.width * 0.95)
                            )
                            .onTapGesture {
                                withAnimation(.easeInOut){
                                    viewModel.selectedCategoryDetail = projectCategoryDetail
                                }
                            }
                    }else{
                        Text(projectCategoryDetail.propertyCategoryName)
                            .font(.title2)
                            .foregroundStyle(Color.secondary)
                            .bold()
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.4))
                                    .stroke(Color.gray,lineWidth: 3)
                                    .frame(width: props.size.width * 0.95)
                            )
                    }
                }
                if viewModel.loadingState == .finished {
                    Button {
                        confirmationDialogIsPresented.toggle()
                    } label: {
                        if viewModel.buttonLoadingState == .loading {
                            Text("Loading...")
                                .bold()
                                .padding()
                                .modifier(viewModel.selectedCategoryDetail != nil ? JHButtonModifier() : JHButtonModifier(backgroundColor: .gray))
                        } else {
                            Text("Đi đến đặt cọc")
                                .bold()
                                .padding()
                                .modifier(viewModel.selectedCategoryDetail != nil ? JHButtonModifier() : JHButtonModifier(backgroundColor: .gray))
                        }
                    }
                    .disabled( viewModel.selectedCategoryDetail == nil)
                    .confirmationDialog("Bạn có chắc chắn muốn đặt cọc", isPresented: $confirmationDialogIsPresented, titleVisibility: .visible){
                        Button("Có", role: .destructive){
                            Task{
                                //                                let response = try await viewModel.createBooking(propertyCategoryID: viewModel.selectedCategoryDetail!.propertyCategoryID, projectID: projectID, customerID: viewModel.customerID)
                                let response = try await viewModel.createBooking(categoryDetailID: viewModel.selectedCategoryDetail!.projectCategoryDetailID, customerID: viewModel.customerID)
                                if !response.message.isEmpty {
                                    isPresented = false
                                    routerManager.push(to: .activity)
                                    dismiss()
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            Spacer()
        }
        .padding()
        .overlay {
            if viewModel.loadingState == .loading {
                ProgressView()
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
    }
}

#Preview {
    PickProjectCategoryDetail(projectID: "", isPresented: .constant(true))
}
