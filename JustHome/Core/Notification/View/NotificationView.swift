//
//  Notification.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 9/10/24.
//

import SwiftUI

struct NotificationView: View {
    @StateObject var viewModel: NotificationViewModel
    @EnvironmentObject private var routerManager : NavigationRouter
    init() {
        _viewModel = StateObject(wrappedValue: NotificationViewModel(notificationService: NotificationService(httpClient: HTTPClient())))
    }
    var body: some View {
            NavigationStack(path: $routerManager.routes){
                ScrollView{
                    if viewModel.loadingState == .loading {
                        ProgressView()
                    }else {
                        if viewModel.notifications.isEmpty {
                            Text("Không có thông báo nào")
                                .font(.largeTitle)
                        }
                        ForEach(viewModel.notifications) { notification in
                            VStack(alignment: .leading){
                                Text(notification.createdTime)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                Text(notification.title)
                                    .font(.title2.bold())
                                    .foregroundStyle(.primaryGreen)
                                Text(notification.subtiltle)
                                    .font(.callout)
                                Text(notification.body)
                                    .font(.caption2)
                                Divider()
                            }
                            .padding()
                        }
                    }
                }
                .onAppear{
                    viewModel.loadData()
                }
                .refreshable {
                    viewModel.handleRefresh()
                }
                .navigationTitle("Thông báo")
            }

        
    }
}

#Preview {
    NotificationView()
}
