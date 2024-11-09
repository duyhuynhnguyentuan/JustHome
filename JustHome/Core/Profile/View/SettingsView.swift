//
//  SettingsView.swift
//  Introduction_to_NavigationStackApp
//
//  Created by Huynh Nguyen Tuan Duy on 25/9/24.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var manager = NotificationManager()
    var body: some View {
        Button{
            Task {
                await manager.request()
            }
        }label: {
            Text(manager.hasPermission ? "Đã cho phép đẩy thông báo" : "Bật cho phép đẩy thông báo")
        }
        .buttonStyle(.bordered)
        .disabled(manager.hasPermission)
        .task {
            await manager.getAuthStatus()
        }
    }
}

#Preview {
    SettingsView()
}
