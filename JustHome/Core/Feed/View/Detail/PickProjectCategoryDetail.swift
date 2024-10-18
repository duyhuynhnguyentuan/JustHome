//
//  PickProjectCategoryDetail.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 19/10/24.
//

import SwiftUI

struct PickProjectCategoryDetail: View {
    @Environment(\.properties) private var props
    @Environment(\.dismiss) private var dismiss
    let projectID: String
    @StateObject private var viewModel: PickProjectCategoryDetailViewModel
    init(projectID: String) {
        self.projectID = projectID
        _viewModel = StateObject(wrappedValue: PickProjectCategoryDetailViewModel(projectID: projectID))
    }
    var body: some View {
        VStack{
            HStack{
                Text("Loại bất động sản")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.primaryGreen)
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
            HStack{
                Text(viewModel.projectCategoryDetail.first?.projectName ?? "")
                    .font(.title3)
                    .foregroundStyle(.secondaryGreen)
                Spacer()
            }
            VStack(spacing: 10){
                ForEach(viewModel.projectCategoryDetail, id: \.id){ projectCategoryDetail in
                    Text(projectCategoryDetail.propertyCategoryName)
                        .font(.title2)
                        .bold()
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.primaryGreen, lineWidth: 3)
                                .frame(width: props.size.width * 0.95)
                        )
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
    }
}

#Preview {
    PickProjectCategoryDetail(projectID: "")
}
