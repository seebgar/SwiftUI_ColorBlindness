//
//  ImagePickerController.swift
//  Color Blind
//
//  Created by Sebastian on 2/13/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//


import SwiftUI


struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var isPresenting: Bool
    @Binding var image: UIImage
    @Binding var showCamera: Bool
    @Binding var showFilter: Bool
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIViewController {
        // Image Picker - Camera
        let picker: UIImagePickerController = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.sourceType =  showCamera ? .camera : .photoLibrary
        return picker
    }
    
    func makeCoordinator() -> ImagePickerView.Coordinator {
        return Coordinator(parent: self)
    }
    
    /**
     Selection of Image
     */
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePickerView
        init(parent: ImagePickerView) {
            self.parent = parent
        }
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            dicImages = [:]
            
            if let selected = info[.editedImage] as? UIImage {
                self.parent.image = selected
                globalOriginal = selected
                if picker.sourceType == .camera {
                    UIImageWriteToSavedPhotosAlbum(selected, nil, nil, nil)
                }
            }
                                                
            self.parent.isPresenting = false
            self.parent.showFilter = true
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.isPresenting = false
        }
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ImagePickerView>) { }
    
}
