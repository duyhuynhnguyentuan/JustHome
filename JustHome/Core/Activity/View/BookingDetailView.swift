//
//  BookingDetailView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 31/10/24.
//



import SwiftUI
import CoreImage.CIFilterBuiltins
import StripePaymentSheet
import WebKit

struct BookingDetailView: View {
    @State var url: URL?
    @Environment(\.dismiss) private var dismiss
    @State private var showingPDF = false
    @StateObject var viewModel: BookingDetailViewModel
    @EnvironmentObject private var routerManager: NavigationRouter
    let bookingID: String
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    init(bookingID: String){
        self.bookingID = bookingID
        _viewModel = StateObject(wrappedValue: BookingDetailViewModel(bookingID: bookingID, bookingService: BookingsService(httpClient: HTTPClient()), openForSalesService: OpenForSaleService(httpClient: HTTPClient())))
    }
    //MARK: Body
    var body: some View {
        ScrollView(.vertical){
            switch viewModel.loadingState {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
            case .finished:
                if let status = viewModel.bookingStatus {
                    Text("Lần cập nhật cuối: \(viewModel.booking?.updatedTime ?? "N/A")")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                              Text(status.rawValue)
                                  .font(.title)
                                  .fontWeight(.semibold)
                                  .foregroundColor(viewModel.booking?.statusColor)
                    Text("Ngày tạo: \(viewModel.booking?.createdTime ?? "N/A" )")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    switch status {
                    case .khongchonsanpham:
                        Text("Bạn đã không chọn sản phẩm nào")
                            .foregroundStyle(.brown)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    case .chuathanhtoan:
                        Text("Số tiền: \(Decimal(string: viewModel.openForSaleDetail?.reservationPrice ?? "") ?? Decimal(0), format: .currency(code: "VND"))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Button{
                          
                        }label: {
                            if let paymentSheet = viewModel.paymentSheet {
                              PaymentSheet.PaymentButton(
                                paymentSheet: paymentSheet,
                                onCompletion: viewModel.onPaymentCompletion
                              ) {
                                  Text("Thanh toán ngay!")
                                      .font(.title3.bold())
                                      .modifier(JHButtonModifier())
                              }
                            } else {
                                Text("Đang setup cổng thanh toán")
                                    .font(.title3.bold())
                                    .modifier(JHButtonModifier(backgroundColor: .gray))
                            }
                        }
                        if let result = viewModel.paymentResult {
                          switch result {
                          case .completed:
                            Text("Thanh toán thành công")
                                  .font(.callout.bold())
                                  .foregroundStyle(.green)
                                  .onAppear(){
                                      viewModel.handleRefresh()
                                      viewModel.paymentResult = nil
                                  }
                          case .failed(let error):
                            Text("Thanh toán thất bại: \(error.localizedDescription)")
                                  .font(.callout.bold())
                                  .foregroundStyle(.red)
                          case .canceled:
                            Text("Đã hủy thanh toán.")
                                  .font(.callout.bold())
                                  .foregroundStyle(.yellow)
                          }
                        }
                    case .dadatcho, .dacheckin, .dachonsanpham, .dakythoathuandatcoc, .dahuy:
                        if viewModel.openForSaleDetail?.saleType == "Offline" {
                            // Show only a disabled button with "Được chọn bởi staff"
                            Button("Được chọn bởi Staff") {}
                                .disabled(true)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        } else {
                            // Handle each case as per the original logic
                            switch status {
                            case .dadatcho:
                                Text("Đã đặt cọc vào lúc \(viewModel.booking?.depositedTimed ?? "N/A")")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                Text("Thời gian check-in: \(viewModel.openForSaleDetail?.checkinDate ?? "N/A")")
                                    .font(.caption)
                                    .foregroundStyle(.yellow)
                                if let checkinDateString = viewModel.openForSaleDetail?.checkinDate,
                                   let checkinDate = DateFormatter.yyyyMMddHHmmss.date(from: checkinDateString) {
                                    VStack {
                                        if Date() < checkinDate {
                                            Button("Chưa đến thời gian checkin") {}
                                                .padding()
                                                .background(Color.gray)
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                        } else if Date() < Calendar.current.date(byAdding: .day, value: 1, to: checkinDate)! {
                                            Button("Check-in ngay") {
                                                Task {
                                                    let response = try await viewModel.checkingIn(by: bookingID)
                                                    if response?.message != nil {
                                                        routerManager.push(to: .realTime(projectCategoryDetailID: viewModel.booking!.projectCategoryDetailID))
                                                    }
                                                }
                                            }
                                            .padding()
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                        } else {
                                            Button("Đã quá thời gian checkin, không thể chọn căn") {}
                                                .padding()
                                                .background(Color.red)
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                        }
                                    }
                                } else {
                                    Text("Ngày checkin không hợp lệ.")
                                        .foregroundColor(.red)
                                }
                            case .dacheckin:
                                if let checkinDateString = viewModel.openForSaleDetail?.checkinDate,
                                   let checkinDate = DateFormatter.yyyyMMddHHmmss.date(from: checkinDateString),
                                   let endDateString = viewModel.openForSaleDetail?.endDate,
                                   let endDate = DateFormatter.yyyyMMddHHmmss.date(from: endDateString) {

                                    VStack {
                                        if Date() < Calendar.current.date(byAdding: .day, value: 1, to: checkinDate)! {
                                            // Allow "Vào chọn căn ngay" if it's before checkinDate + 1 day
                                            Button {
                                                routerManager.push(to: .realTime(projectCategoryDetailID: viewModel.booking!.projectCategoryDetailID))
                                            } label: {
                                                Text("Vào chọn căn ngay")
                                                    .bold()
                                                    .modifier(JHButtonModifier())
                                            }
                                        } else if Date() > Calendar.current.date(byAdding: .day, value: 1, to: checkinDate)! && Date() < endDate {
                                            // Allow "Vào chọn căn ngay" if it's after checkinDate + 1 day but before endDate
                                            Button {
                                                routerManager.push(to: .realTime(projectCategoryDetailID: viewModel.booking!.projectCategoryDetailID))
                                            } label: {
                                                Text("Vào chọn căn ngay")
                                                    .bold()
                                                    .modifier(JHButtonModifier())
                                            }
                                        } else {
                                            // Show disabled button if current date is after endDate
                                            Button("Đã quá thời gian checkin") {}
                                                .padding()
                                                .background(Color.red)
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                        }
                                    }
                                } else {
                                    // Handle invalid date scenarios
                                    Text("Ngày checkin hoặc ngày kết thúc không hợp lệ.")
                                        .foregroundColor(.red)
                                }

                            case .dachonsanpham, .dakythoathuandatcoc:
                                Button {
                                } label: {
                                    Label("Vui lòng vào trang hợp đồng để xem thông tin", systemImage: "info.circle")
                                }
                                .padding()
                                .background(Color.yellow)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            case .dahuy:
                                Text("Booking đã tự động bị hủy")
                                    .foregroundStyle(.red)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            default:
                                EmptyView()
                            }
                        }
                    }
                    VStack(alignment: .leading, spacing: 15){
                        Divider()
                        Text("Thông tin booking")
                            .font(.title.bold())
                        BookingDetailView()
                        Text("Thông tin đợt mở bán")
                            .font(.title.bold())
                        OpenForSalesDetailView()
                        if let pdfFile = viewModel.booking?.bookingFile, let fileURL = URL(string: pdfFile) {
                            Text("Phiếu giữ chỗ")
                                .font(.title.bold())
                                     Button{
                                         print(fileURL)
                                        showingPDF = true
                                         print("URL là: \(self.url!)")
                                     }label: {
                                         HStack(alignment: .top){
                                             Image(.pdfIcon)
                                             VStack(alignment: .leading){
                                                 Text("Mẫu thỏa thuận đặt cọc.pdf")
                                                     .font(.title3.bold())
                                                     .foregroundStyle(.primaryText)
                                                 Text("Nhấn vào để xem chi tiết")
                                                     .font(.callout)
                                                     .foregroundStyle(.gray)
                                             }
                                             Spacer()
                                         }
                                         .padding()
                                         .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.primaryGreen ,lineWidth: 2)
                                         )
                                     }
                                     .onAppear{
                                         self.url = fileURL
                                     }
                                 }
                        Text("Mã QR")
                            .font(.title.bold())
                        HStack{
                            Spacer()
                            Image(uiImage: generateQRCode(from: viewModel.booking))
                                .interpolation(.none)
                                .resizable()
                                .frame(width: 200, height: 200)
                            Spacer()
                        }
                    }
                        .padding(.vertical)
//                    Spacer()
                           
                    
                          } else {
                              Text("Loading status...")
                                  .foregroundColor(.gray)
                          }
            }
        }
        .refreshable {
            viewModel.handleRefresh()
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal)
        .sheet(isPresented: $showingPDF) {
                  if let pdfURL = url {
                      VStack{
                          HStack{
                              ShareLink(item: pdfURL){
                                  Label("Chia sẻ file PDF", systemImage: "square.and.arrow.up")
                              }.bold()
                              Spacer()
                              Button{
                                  showingPDF = false
                              }label: {
                                  Image(systemName: "xmark")
                                      .font(.caption2)
                                      .foregroundStyle(.white)
                                      .padding()
                                      .background(Color.black.opacity(0.35))
                                      .clipShape(Circle())
                              }
                          }.padding()
                      //MARK: - PDF View
                          PDFViewRepresentable(url: pdfURL)
                              .edgesIgnoringSafeArea(.all)
                      }
                  } else {
                      Text("PDF could not be loaded.")
                  }
              }
        .onAppear {
            viewModel.loadData()
            viewModel.preparePaymentSheet()
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
    @ViewBuilder
       func BookingDetailView() -> some View {
           VStack(alignment: .leading ,spacing: 5){
               Text("Dự án: \(viewModel.booking?.projectName ?? "N/A")")
                   .font(.title2.bold())
               Text("Loại hình: \(viewModel.booking?.propertyCategoryName ?? "N/A")")
                   .font(.headline.italic())
               Text("Tên khách hàng: \(viewModel.booking?.customerName ?? "N/A")")
               Text("Tên quyết định: \(viewModel.booking?.decisionName ?? "N/A")")
               HStack{
                   Spacer()
               }
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
    @ViewBuilder
    func OpenForSalesDetailView() -> some View {
        VStack(alignment: .leading ,spacing: 5){
            Text("\(viewModel.openForSaleDetail?.decisionName ?? "N/A")")
                .font(.title2.bold())
            Text("Hình thức: \(viewModel.openForSaleDetail?.saleType ?? "N/A")")
                .font(.headline.italic())
            Text("Số tiền đặt giữ chỗ: \(Decimal(string: viewModel.openForSaleDetail?.reservationPrice ?? "") ?? Decimal(0), format: .currency(code: "VND"))")
            Text("Mô tả: \(viewModel.openForSaleDetail?.description ?? "N/A")")
            HStack{
                Spacer()
            }
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
    //generate QR
    func generateQRCode(from booking: Bookings?) -> UIImage {
        // Prepare a dictionary with relevant booking data
        let bookingData: [String: String] = [
            "bookingID": booking?.bookingID ?? "N/A",
            "customerID": booking?.customerID ?? "N/A",
            "openingForSaleID": booking?.openingForSaleID ?? "N/A"
        ]
        
        // Convert dictionary to JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: bookingData, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return UIImage(systemName: "xmark.circle") ?? UIImage()
        }

        // Set the QR code message
        filter.message = Data(jsonString.utf8)

        // Generate the QR code image
        if let outputImage = filter.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}


struct PDFViewRepresentable: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        // Create WKWebView and configure it
        let webView = WKWebView(frame: .zero)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Load the PDF URL
        let request = URLRequest(url: url)
        webView.load(request)
        
        // Add the WKWebView to the view controller's view
        viewController.view.addSubview(webView)
        
        // Set up Auto Layout constraints
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])
        
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Optional: Handle updates to the view, if needed
    }
}
#Preview {
    BookingDetailView(bookingID: "c0bfde94-5e0f-4220-88ba-1cc457357129")
}


