//
//  BookingDetailViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 31/10/24.
//

import Foundation
import StripePaymentSheet
enum BookingsStatus: String, CaseIterable {
    case chuathanhtoan = "Chưa thanh toán tiền giữ chỗ"
    case dadatcho = "Đã đặt chỗ"
    case dacheckin = "Đã check in"
    case dachonsanpham = "Đã chọn sản phẩm"
    case dakythoathuandatcoc = "Đã ký thỏa thuận đặt cọc"
    case dahuy = "Đã hủy"
    case khongchonsanpham = "Không chọn sản phẩm"
}
class BookingDetailViewModel: ObservableObject {
    //declarations
    let bookingID: String
    let bookingService: BookingsService
    let openForSalesService: OpenForSaleService
    //Stripes
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
    @Published private(set) var loadingState: LoadingState = .idle
    @Published var error: NetworkError?
    @Published private(set) var booking: Bookings?
    @Published private(set) var openForSaleDetail: OpenForSales?
    init(bookingID: String, bookingService: BookingsService, openForSalesService: OpenForSaleService){
        self.bookingID = bookingID
        self.bookingService = bookingService
        self.openForSalesService = openForSalesService
        loadData()
    }
    private var backendCheckoutUrl: URL {
        return URL(string: "https://realestateproject-bdhcgphcfsf6b4g2.canadacentral-01.azurewebsites.net/api/payments?bookingId=\(bookingID)")!
    }
    var bookingStatus: BookingsStatus? {
          guard let statusText = booking?.status else { return nil }
          return BookingsStatus(rawValue: statusText)
      }
    @MainActor
    func loadABooking(by bookingID: String) async throws {
        defer { loadingState = .finished }
        do {
            loadingState = .loading
            let booking = try await bookingService.loadABooking(by: bookingID)
            self.booking = booking
            // Fetch open-for-sales data using openForSalesID from the booking
            await loadOpenForSaleDetail(openForSalesID: booking.openingForSaleID)
        } catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }

    @MainActor
    private func loadOpenForSaleDetail(openForSalesID: String) async {
        do {
            let openForSaleData = try await openForSalesService.loadOpenForSale(openForSalesID: openForSalesID)
            self.openForSaleDetail = openForSaleData
        } catch {
            print("Error loading open-for-sale detail: \(error)")
        }
    }
    func loadData(){
        Task(priority: .medium){
            try await loadABooking(by: bookingID)
        }
    }
    //MARK: Stripes function
    func onPaymentCompletion(result: PaymentSheetResult) {
      self.paymentResult = result
    }
    func preparePaymentSheet() {
      // MARK: Fetch the PaymentIntent and Customer information from the backend
      var request = URLRequest(url: backendCheckoutUrl)
        print(request.url!)
      request.httpMethod = "POST"
      let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
              let customer = json["customer"] as? String,
              let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
              let paymentIntentClientSecret = json["paymentIntent"] as? String,
              let publishableKey = json["publishableKey"] as? String,
              let self = self else {
          return
        }

        STPAPIClient.shared.publishableKey = publishableKey
        // MARK: Create a PaymentSheet instance
        var configuration = PaymentSheet.Configuration()
          configuration.returnURL = "justhome://stripe-redirect"
        configuration.merchantDisplayName = "JustHome"
        configuration.customer = .init(id: customer, ephemeralKeySecret: customerEphemeralKeySecret)
        // Set `allowsDelayedPaymentMethods` to true if your business handles
        // delayed notification payment methods like US bank accounts.
        configuration.allowsDelayedPaymentMethods = true

        DispatchQueue.main.async {
          self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
        }
      })
      task.resume()
    }
    @MainActor
    func checkingIn(by bookingID: String) async throws -> MessageResponse? {
        do{
            let response = try await bookingService.checkingIn(by: bookingID)
            return response
        }catch let error as NetworkError{
            self.error = error
            print(error.localizedDescription)
            return nil
        }catch{
            print("Other error: \(error.localizedDescription)")
            return nil
        }
    }
    @MainActor
    func handleRefresh() {
        self.booking = nil
        loadData()
    }
}
