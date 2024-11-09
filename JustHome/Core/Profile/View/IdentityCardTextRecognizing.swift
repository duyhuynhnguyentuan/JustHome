//
//  IdentityCardTextRecognizing.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 4/11/24.
//

import SwiftUI
import AVFoundation
import Vision
import VisionKit

struct IdentityCardTextRecognizing: View {
    @StateObject var viewModel: IdentityCardTextRecognizingViewModel
    init(){
        _viewModel = StateObject(wrappedValue: IdentityCardTextRecognizingViewModel(customerService: CustomerService(httpClient: HTTPClient())))
    }
    @State private var recognizedText: String = "Hãy quét căn cước của bạn"
    @State private var scanComplete: Bool = false
    @State private var showAlert: Bool = false
    @Environment(\.dismiss) private var dismiss
    // New fields
    @State private var bankNumber: String = ""
    @State private var bankName: String = ""
    @State private var taxCode: String = ""

    var body: some View {
        ZStack(alignment: .bottom) {
            if scanComplete {
                VStack {
                    let details = extractIdentityCardDetails(from: recognizedText)
                    
                    if details.cardNumber == nil || details.placeOfOrigin == nil || details.placeOfResidence == nil || details.expiryDate == nil {
                        Text("Đã xảy ra lỗi khi quét xin vui lòng quét lại")
                            .font(.title.bold())
                            .onAppear{
                                showAlert = true
                            }
                    } else {
                        Text("Hãy kiểm tra thông tin và điền thông tin ngân hàng")
                            .font(.title.bold())
                        Button{
                            scanComplete = false
                        }label: {
                            Text("Thông tin chưa chính xác? Quét lại")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        VStack(alignment: .leading){
                            Text("Số CCCD: \(details.cardNumber ?? "N/A")")
                            Text("Ngày hết hạn: \(details.expiryDate ?? "N/A")")
                            Text("Quê quán: \(details.placeOfOrigin ?? "N/A")")
                            Text("Nơi thường trú: \(details.placeOfResidence ?? "N/A")")
                                .lineLimit(nil)  // Allow multiple lines
                                .truncationMode(.tail)
                            // New Text Fields
                            TextField("Bank Number", text: $bankNumber)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Bank Name", text: $bankName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Tax Code", text: $taxCode)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                        
                        // Submit Button
                        Button("Cập nhật") {
                            Task {
                                await viewModel.updateCustomerInfo(
                                    details: details,
                                    bankNumber: bankNumber,
                                    bankName: bankName,
                                    taxCode: taxCode
                                )
                            }
                            dismiss()
                        }
                        .font(.title2.bold())
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Scan Thất Bại"),
                        message: Text("Một số thông tin không thấy rõ. Hãy quét lại"),
                        dismissButton: .default(Text("OK")) {
                            scanComplete = false
                        }
                    )
                }
            } else {
                ZStack(alignment: .top) {
                    ScannerView(recognizedText: $recognizedText) {
                        scanComplete = true
                    }
                    .edgesIgnoringSafeArea(.all)
                    
                    Text("Hãy quét căn cước của bạn")
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.top, UIScreen.main.bounds.height / 6)
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}


struct ScannerView: UIViewControllerRepresentable {
    @Binding var recognizedText: String
    let onScanComplete: () -> Void  // Callback when scan is complete
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: ScannerView
        private lazy var textRecognitionRequest: VNRecognizeTextRequest = {
            let request = VNRecognizeTextRequest { [weak self] (request, error) in
                guard let results = request.results as? [VNRecognizedTextObservation] else { return }
                
                let recognizedStrings = results.compactMap { $0.topCandidates(1).first?.string }
                DispatchQueue.main.async {
                    print(recognizedStrings.joined(separator: "\n"))
                    self?.parent.recognizedText = recognizedStrings.joined(separator: "\n")
                    
                    // Stop scanning and move to another view
                    self?.parent.onScanComplete()
                }
            }
            request.recognitionLanguages = ["vi-VT"]
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            return request
        }()
        
        init(_ parent: ScannerView) {
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            // Stop scanning as soon as we detect text
            controller.dismiss(animated: true, completion: nil)
            
            for pageIndex in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                processImage(image)
                
                // Stop processing after the first page to avoid multiple scans
                break
            }
        }
        
        private func processImage(_ image: UIImage) {
            guard let cgImage = image.cgImage else { return }
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([textRecognitionRequest])
            } catch {
                print("Error in text recognition: \(error)")
            }
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true, completion: nil)
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            controller.dismiss(animated: true, completion: nil)
            print("Document scanning failed: \(error.localizedDescription)")
        }
    }
}
func extractIdentityCardDetails(from text: String) -> (cardNumber: String?, placeOfOrigin: String?, placeOfResidence: String?, expiryDate: String?) {
    
    let cardNumberRegex = #"Số / No\.\:\s*(\d+)"#
    let expiryDateRegex = #"Date of expiry\n?(\d{2}/\d{2}/\d{4})"#
    let placeOfOriginRegex = #"Quê quán / Place of origin:\s*(.+?)(?=\nNơi thường trú|$)"#
    let placeOfResidenceRegex = #"Nơi thường trú / Place of residence:\s*(.+?)(?=\n\S|$)"#
    
    func extractFirstMatch(for regexPattern: String, in text: String) -> String? {
        let regex = try? NSRegularExpression(pattern: regexPattern, options: [.dotMatchesLineSeparators])
        let range = NSRange(location: 0, length: text.utf16.count)
        if let match = regex?.firstMatch(in: text, options: [], range: range),
           let range = Range(match.range(at: 1), in: text) {
            return String(text[range]).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return nil
    }
    
    let cardNumber = extractFirstMatch(for: cardNumberRegex, in: text)
    let expiryDate = extractFirstMatch(for: expiryDateRegex, in: text)
    var placeOfOrigin = extractFirstMatch(for: placeOfOriginRegex, in: text)
    placeOfOrigin = placeOfOrigin?.replacingOccurrences(of: "Quê quán / Place of origin:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
    
    var placeOfResidence = extractFirstMatch(for: placeOfResidenceRegex, in: text)
    placeOfResidence = placeOfResidence?.replacingOccurrences(of: "Nơi thường trú / Place of residence:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
    
    // If the placeOfResidence field seems incomplete, append the last line of text
    if let placeOfResidenceValue = placeOfResidence, !placeOfResidenceValue.contains("Thành phố Đồng Xoài") {
        let lines = text.split(separator: "\n").map { String($0) }
        if let lastLine = lines.last {
            placeOfResidence = "\(placeOfResidenceValue), \(lastLine)"
        }
    }
    
    return (cardNumber, placeOfOrigin, placeOfResidence, expiryDate)
}



#Preview {
    IdentityCardTextRecognizing()
}
