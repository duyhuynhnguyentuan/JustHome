//
//  ProcedureView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 9/10/24.
//

import SwiftUI

struct ProcedureView: View {
    @StateObject private var viewModel: ProcedureViewModel
    @EnvironmentObject private var routerManager : NavigationRouter
    init(){
        _viewModel = StateObject(wrappedValue: ProcedureViewModel(contractsService: ContractsService(httpClient: HTTPClient()), biometricService: BiometricService()))
    }
    var body: some View {
        NavigationStack(path: $routerManager.routes){
            ScrollView{
                if viewModel.loadingState == .loading {
                    ProcedureViewRowPlaceHolder()
                        .padding(.top)
                } else {
                    if viewModel.filteredContract.isEmpty {
                        Text("Không tìm thấy hợp đồng")
                            .font(.largeTitle)
                    }
                    ForEach(viewModel.filteredContract) { contract in
                        NavigationLink(value: Route.contract(contractID: contract.contractID)) {
                            ProcedureViewRow(contract: contract)
                        }
                    }
                }
            }
            .refreshable {
                viewModel.handleRefresh()
            }
            .searchable(text: $viewModel.searchText)
            .navigationTitle("Danh sách bất động sản hiện có")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Route.self) { $0 }
            .onAppear {
                do {
                    viewModel.biometricError = nil
                    try viewModel.authenticateWithBiometrics()
                } catch {
                    print("Biometric authentication failed with error: \(error.localizedDescription)")
                }
            }
            .alert(item: $viewModel.biometricError) { errorMessage in
                Alert(
                    title: Text("Biometric Authentication Failed"),
                    message: Text(errorMessage.errorDescription ?? "An unknown error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    ProcedureView()
}
