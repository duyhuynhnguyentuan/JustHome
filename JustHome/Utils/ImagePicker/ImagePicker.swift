////
////  ImagePicker.swift
////  JustHome
////
////  Created by Huynh Nguyen Tuan Duy on 21/11/24.
////
//
//import Foundation
//import SwiftUI
//import UIKit
//struct ImagePicker: UIViewControllerRepresentable{
//    @Binding var image: UIImage?
//    var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
//        var parent: ImagePicker
//        
//        init(parent: ImagePicker) {
//            self.parent = parent
//        }
//        
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let uiImage = info[.originalImage] as? UIImage {
//                parent.image = uiImage
//            }
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//        
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//    }
//    @Environment(\.presentationMode) private var presentationMode
//    func makeCoordinator() -> Coordinator {
//        Coordinator(parent: self)
//    }
//    func makeUIViewController(context: Context) -> some UIViewController {
//        let picker = UIImagePickerController()
//        picker.sourceType = sourceType
//        picker.delegate = context.coordinator
//        return picker
//    }
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        
//    }
//}
