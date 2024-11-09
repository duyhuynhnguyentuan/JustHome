//
//  ActivityView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 9/10/24.
//

import SwiftUI

struct ActivityView: View {
    @StateObject var viewModel: ActivityViewModel
    @EnvironmentObject private var routerManager : NavigationRouter
    init() {
        _viewModel = StateObject(wrappedValue: ActivityViewModel(bookingsService: BookingsService(httpClient: HTTPClient()), biometricService: BiometricService()))
    }
    
    var body: some View {
        NavigationStack(path: $routerManager.routes){
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    BookingFilter()
                        .padding(.bottom,20)
                    
                    if viewModel.loadingState == .loading {
                        ActivityRowPlaceHolder()
                    } else {
                        if viewModel.filteredBookings.isEmpty {
                            Text("Bạn chưa có booking nào")
                                .font(.largeTitle)
                        }
                        ForEach(viewModel.filteredBookings) { booking in
                            NavigationLink(value: Route.bookings(bookingID: booking.bookingID)) {
                                ActivityViewRow(bookings: booking)
//                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding()
            }
            .refreshable {
                viewModel.handleRefresh()
            }
            .navigationTitle("Booking")
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
    
    @ViewBuilder
    func BookingFilter() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(BookingsFilter.allCases, id: \.self) { filter in
                    Text(filter.rawValue)
                        .bold()
                        .padding()
                        .background(viewModel.currentBookingsFilter == filter ? Capsule().fill(Color.primaryGreen) : Capsule().fill(Color.gray))
                        .foregroundColor(.white)
                        .onTapGesture {
                            withAnimation {
                                viewModel.currentBookingsFilter = filter
                            }
                        }
                }
            }
//            .padding(.horizontal)
        }
    }
}

#Preview {
    ActivityView()
}
