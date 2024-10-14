//
//  ProfileView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 9/10/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.properties) var props
    @Environment(\.colorScheme) var colorScheme
    @State private var confirmationShow = false
    let authService: AuthService

    init(authService: AuthService){
        self.authService = authService
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // LinearGradient as the background
                LinearGradient(gradient: Gradient(colors: [.tertiaryGreen, .primaryGreen, .lightGreen]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                    .blur(radius: 1)
                    .opacity(0.3)

                // Content on top of the gradient
                VStack {
                    Text(Customer.sample.fullName.initialsFromFirstTwoWords())
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

                    Text(Customer.sample.fullName)
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                        .foregroundStyle(colorScheme == .dark ? .lightGreen : .white)

                    Label(Customer.sample.email, systemImage: "envelope")
                        .imageScale(.small)
                        .padding(.all, 10)
                        .background(Color(.lightGreen).opacity(0.75), in: Capsule())

                    // MARK: - Middle part
                    List {
                        // General
                        Section {
                            Text("Sửa thông tin cá nhân")
                            Text("Thông tin căn cước")
                        } header: {
                            Label("General", systemImage: "person.fill")
                        }

                        // Privacy and safety
                        Section {
                            Text("Thông báo")
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
    }


}

#Preview {
    ProfileView(authService: AuthService(keychainService: KeychainService.shared, httpClient: HTTPClient()))
}
