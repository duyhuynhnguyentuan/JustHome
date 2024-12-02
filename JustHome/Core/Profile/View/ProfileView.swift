//
//  ProfileView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 9/10/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var routerManager : NavigationRouter
    @Environment(\.properties) var props
    @Environment(\.colorScheme) var colorScheme
    @State private var confirmationShow = false
    let authService: AuthService
    @StateObject var viewModel: ProfileViewModel
    init(authService: AuthService){
        self.authService = authService
        _viewModel = StateObject(wrappedValue: ProfileViewModel(customerService: CustomerService(httpClient: HTTPClient())))
    }
    var body: some View {
        NavigationStack {
            ZStack {
                // LinearGradient as the background
                LinearGradient(gradient: Gradient(colors: [.tertiaryGreen, .primaryGreen, .lightGreen]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                    .blur(radius: 1)
                    .opacity(0.3)
                switch viewModel.loadingState {
                case .idle:
                    EmptyView()
                case .loading:
                    ProgressView()
                case .finished:
                // Content on top of the gradient
                VStack {
                    Text(viewModel.customer?.fullName.initialsFromFirstTwoWords() ?? "N/A")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundStyle(.white)
                        .background {
                            Circle()
                                .fill(Color.primaryGreen)
                                .overlay(Circle().stroke(Color.secondaryGreen, lineWidth: 10))
                                .shadow(radius: 15)
                                .frame(width: props.isIpad ? props.size.width / 6 : props.size.width / 3.5,
                                       height: props.isIpad ? props.size.width / 6 : props.size.width / 3.5)
                        }
                        .padding(.bottom, props.isIpad ? props.size.width / 12 : props.size.width / 7)
                        .padding(.top, props.isIpad ? props.size.width / 12 : props.size.width / 7)
                    
                    Text(viewModel.customer?.fullName ?? "N/A")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                        .foregroundStyle(colorScheme == .dark ? .lightGreen : .white)
                    
                    Label(viewModel.customer?.email ?? "N/A", systemImage: "envelope")
                        .imageScale(.small)
                        .padding(.all, 10)
                        .background(Color(.lightGreen).opacity(0.75), in: Capsule())
                    
                    // MARK: - Middle part
                    List {
                        // General
                        Section {
                            NavigationLink{
                                PersonalInfoView()
                            }label: {
                                Text("Sửa thông tin căn cước và thông tin ngân hàng")
                            }
                            //add EditProfile here
                            NavigationLink {
                                if viewModel.customer != nil {
                                    LoadProfileView(customer: viewModel.customer!) // Make sure it's unwrapped or use optional binding
                                }
                            } label: {
                                Text("Thông tin cá nhân")
                            }

                        } header: {
                            Label("General", systemImage: "person.fill")
                        }
                        
                        // Privacy and safety
                        Section {
                            NavigationLink{
                                SettingsView()
                            }label: {
                                Text("Thông báo")
                            }
                            Text("Sử dụng FaceID")
                        } header: {
                            Label("Privacy & Safety", systemImage: "lock.fill")
                        }
                        
                        Section{
                            Text("Báo cáo lỗi")
                            Text("Gợi ý mới")
                        }header: {
                            Label("Support", systemImage: "questionmark.circle.fill")
                        }
                        Section{
                            Text("Xóa tài khoản")
                                .foregroundStyle(.red)
                            Button("Đăng xuất") {
                                confirmationShow.toggle()
                            }
                            .foregroundStyle(.red)
                            .confirmationDialog("Chắc chắn đăng xuất",
                                                isPresented: $confirmationShow,
                                                titleVisibility: .visible) {
                                Button("Yes", role: .destructive){
                                    withAnimation {
                                        authService.logout()
                                        routerManager.reset()
                                    }
                                }
                            }
                        } header: {
                            Label("Danger Zone", systemImage: "exclamationmark.octagon.fill")
                                .foregroundStyle(.red)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                }
                .frame(maxWidth: .infinity)
            }
            }
            .onAppear{
                viewModel.loadData()
            }
        }
    }


}

#Preview {
    ProfileView(authService: AuthService(keychainService: KeychainService.shared, httpClient: HTTPClient()))
}
