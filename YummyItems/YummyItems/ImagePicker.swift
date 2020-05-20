//
//  ImagePicker.swift
//  YummyItems
//
//  Created by Kittu Lalli on 19/05/20.
//  Copyright © 2020 Kittu Lalli. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct ImagePicker: UIViewControllerRepresentable {
    
    class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        @Binding var isImagePickerShown: Bool
        @Binding var image: UIImage?
        
        init(isImagePickerShown: Binding<Bool>, image: Binding<UIImage?>) {
            _isImagePickerShown = isImagePickerShown
            _image = image
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isImagePickerShown = false
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            self.image = (info[.originalImage] as! UIImage)
            isImagePickerShown = false
        }
    }
    
    @Binding var isImagePickerShown: Bool
    @Binding var image: UIImage?

    func makeCoordinator() -> ImagePickerDelegate {
        ImagePickerDelegate(isImagePickerShown: $isImagePickerShown, image: $image)
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) { }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
}
