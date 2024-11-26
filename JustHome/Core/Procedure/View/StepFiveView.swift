import SwiftUI
import Alamofire

struct StepFiveView: View {
    @State private var showImagePicker = false
    @State private var image: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var localPath: String?
    @State private var isUploading = false
    @State private var uploadProgress: Double = 0.0
    @State private var uploadMessage: String?
    @State private var showConfirmationDialog = false
    @State private var showAlert = false
    @State private var alertMessage: String?
    @EnvironmentObject private var routerManager: NavigationRouter
    var contractID: String // Pass this dynamically

    var body: some View {
        ZStack {
            VStack {
                Text("Thanh toán tiến độ lần 1 hợp đồng mua bán")
                    .foregroundStyle(.primaryGreen)
                    .font(.callout)
                Text("Quý khách vui lòng upload ủy nhiệm chi")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                VStack {
                    if let uiImage = image {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    } else {
                        Image(systemName: "photo.badge.plus")
                            .resizable()
                            .foregroundStyle(.primaryGreen)
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }

                    Text("Tải lên ủy nhiệm chi")
                        .font(.callout.bold())
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.primaryGreen, lineWidth: 3)
                        )

                    HStack {
                        Button("Chọn từ thư viện ảnh") {
                            sourceType = .photoLibrary
                            showImagePicker.toggle()
                        }.buttonStyle(.borderedProminent)
                        Button("Chụp ảnh") {
                            sourceType = .camera
                            showImagePicker.toggle()
                        }.buttonStyle(.borderedProminent)
                    }
                    .padding(.top)
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .sheet(isPresented: $showImagePicker, content: {
                    ImagePicker(image: $image, localPath: $localPath, sourceType: sourceType)
                })
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.primaryGreen, lineWidth: 3)
                )
                .padding(.top)

                Button {
                    if let _ = localPath {
                        showConfirmationDialog.toggle()
                    } else {
                        uploadMessage = "Vui lòng chọn ảnh trước khi tải lên."
                    }
                } label: {
                    Text("Tôi đã thanh toán")
                        .font(.title)
                        .fontWeight(.black)
                        .modifier(JHButtonModifier())
                }
                .padding(.top)

                if let message = uploadMessage {
                    Text(message)
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.9)
            .padding()
            .confirmationDialog("Bạn đã chắc chắn thông tin là chính xác?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
                Button("Có", role: .destructive) {
                    if let path = localPath {
                        uploadImageWithAlamofire(filePath: path)
                    }
                }
                Button("Hủy", role: .cancel) {}
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Thông báo"), message: Text(alertMessage ?? ""), dismissButton: .default(Text("OK")))
            }

            // Overlay for upload progress
            if isUploading {
                Color.black.opacity(0.6) // Darken the screen
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    ProgressView(value: uploadProgress, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding()
                    Text("Đang tải lên... \(Int(uploadProgress * 100))%")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .frame(width: UIScreen.main.bounds.width * 0.8, height: 150)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 10)
            }
        }
    }

    func uploadImageWithAlamofire(filePath: String) {
        guard let url = URL(string: "https://realestateproject-bdhcgphcfsf6b4g2.canadacentral-01.azurewebsites.net/api/contracts/check-step-five/\(contractID)") else {
            alertMessage = "URL không hợp lệ."
            showAlert = true
            return
        }

        let headers: HTTPHeaders = [
            "Accept": "*/*"
        ]

        isUploading = true
        uploadProgress = 0.0

        AF.upload(
            multipartFormData: { formData in
                let fileURL = URL(fileURLWithPath: filePath)
                formData.append(fileURL, withName: "RemittanceOrder", fileName: "image.jpg", mimeType: "image/jpeg")
                formData.append("Alamofire".data(using: .utf8)!, withName: "test")
            },
            to: url,
            method: .put,
            headers: headers
        )
        .uploadProgress { progress in
            uploadProgress = progress.fractionCompleted
        }
        .response { response in
            isUploading = false

            if let request = response.request {
                print("Request URL: \(request.url?.absoluteString ?? "No URL")")
                print("Request Method: \(request.httpMethod ?? "No HTTP Method")")
                if let headers = request.allHTTPHeaderFields {
                    print("Request Headers: \(headers)")
                }
            }

            if let httpResponse = response.response {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                print("Response Headers: \(httpResponse.allHeaderFields)")
            } else {
                print("No HTTP response received.")
            }

            if let responseData = response.data {
                if let responseString = String(data: responseData, encoding: .utf8) {
                    print("Raw Server Response: \(responseString)")
                }

                if let jsonResponse = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                   let message = jsonResponse["message"] as? String {
                    alertMessage = message
                    print("Parsed Server Message: \(message)")
                    if !message.isEmpty {
                        routerManager.push(to: .procedure)
                        routerManager.reset()
                        return
                    }
                } else {
                    alertMessage = "Phản hồi từ server không hợp lệ hoặc bị thiếu."
                    print("Unexpected response format.")
                }
            } else {
                print("No response data received.")
                alertMessage = "Không nhận được phản hồi từ server."
            }

            if let error = response.error {
                print("Upload failed with error: \(error.localizedDescription)")
                alertMessage = "Lỗi tải lên: \(error.localizedDescription)"
            }

            showAlert = true
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var localPath: String?
    var sourceType: UIImagePickerController.SourceType

    func makeCoordinator() -> Coordinator {
        Coordinator(image: $image, localPath: $localPath)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var image: UIImage?
        @Binding var localPath: String?

        init(image: Binding<UIImage?>, localPath: Binding<String?>) {
            _image = image
            _localPath = localPath
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                image = uiImage

                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                let imageName = "temp.jpg"
                if let path = documentDirectory?.appendingPathComponent(imageName).path,
                   let data = uiImage.jpegData(compressionQuality: 0.8) {
                    FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
                    localPath = path
                }
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
