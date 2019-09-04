//
//  ConfirmImageViewController.swift
//  FIT5140Assignment1
//
//  Created by Aditya Kumar on 03/09/19.
//  Copyright © 2019 Aditya Kumar. All rights reserved.
//

import UIKit

class ConfirmImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBAction func changeButton(_ sender: Any) {
        // Pop up the camera/gallery again, replace image
        let controller = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            controller.sourceType = .camera
        } else {
            controller.sourceType = .photoLibrary
        }
        
        controller.allowsEditing = true
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func saveButton(_ sender: Any) {
        guard let image = imageView.image else {
            let alertController = UIAlertController(title: "Error", message: "Cannot save a photo till a photo is selected!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alertController,animated: true,completion: nil)
            return
        }
        let date = UInt(Date().timeIntervalSince1970)
        var data = Data()
        data = image.jpegData(compressionQuality: 1)!
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("\(date)") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
            let count = self.navigationController!.viewControllers.count
            if count > 1 {
                let newSightViewController = self.navigationController!.viewControllers[count - 2] as! NewSightViewController
                newSightViewController.locationImagePath = filePath
            }
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    var imageToShow:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if imageToShow != nil {
            // Image exists, show it
            imageView.image = imageToShow
        }
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Force unwrap instead of optional because it doesn't return correct value otherwise
        let pickedImage = info[.editedImage] as! UIImage
        self.imageView.image = pickedImage
        dismiss(animated: true, completion: nil)
    }
}
