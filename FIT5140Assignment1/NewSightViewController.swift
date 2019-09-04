//
//  NewSightViewController.swift
//  FIT5140Assignment1
//
//  Created by Aditya Kumar on 03/09/19.
//  Copyright © 2019 Aditya Kumar. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class NewSightViewController: UIViewController {
    
    // Variable to store the saved image from the confirm image screen
    var locationImagePath:String?
    
    // Outlets and actions
    @IBOutlet weak var scrollView: UIScrollView!

    // Name
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!

    // Description
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionField: UITextView!

    // Map
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    // Address
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressField: UITextField!
    
    // Photo
    @IBOutlet weak var photoLabel: UILabel!
    @IBAction func photoButton(_ sender: Any){
        // Open the camera/gallery straight first, then go to the confirmation screen once the image is picked
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
    @IBOutlet weak var buttonOutlet: UIButton!
    
    //Picker
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var categoryLabel: UILabel!

    // Save button
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBAction func saveButtonAction(_ sender: Any) {
        print ("Save called")
        // Todo: Validations
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer?.viewContext
        let newLocation = NSEntityDescription.insertNewObject(forEntityName: "Location", into: managedObjectContext!) as! Location
        // Get all variables
        
    }
    
    // Holds all categories
    var categories:[String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reference: https://codewithchris.com/uipickerview-example/
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Do any additional setup after loading the view.
        descriptionField.layer.borderColor = UIColor.lightGray.cgColor
        descriptionField.layer.borderWidth = 0.25
        descriptionField.layer.cornerRadius = 5
        descriptionField.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        categories = ["Art Galleries", "Arts & Culture", "Theatre & Musicals", "Museums" , "Heritage Buildings" , "History & Heritage", "Maritime History", "Architecture & Design", "Other"]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Had to break it up because compiler cannot typecheck this in decent time
        var totalHeight = nameLabel.frame.height + nameField.frame.height + descriptionLabel.frame.height + descriptionField.frame.height
        totalHeight += locationLabel.frame.height + mapView.frame.height + categoryLabel.frame.height + buttonOutlet.frame.height
        totalHeight += photoLabel.frame.height + pickerView.frame.height + addressLabel.frame.height + addressField.frame.height
        totalHeight += saveButtonOutlet.frame.height
        
        // Manually set height on the content inside the scrollview
        scrollView.contentSize = CGSize(width: 375, height: totalHeight + 200)
    }
}

// Extensions for cleanup

// UIPicker functions
extension NewSightViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
}

// UIImagePicker functions
extension NewSightViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // .editedImage because the imageView is square, NOT rectangle. Should be equally bad for both landscape and portrait, and I didn't want to force users into one way or another
        if let pickedImage = info[.editedImage] as? UIImage {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let confirmImageViewController:ConfirmImageViewController = storyboard.instantiateViewController(withIdentifier: "confirmImageViewController") as! ConfirmImageViewController
            confirmImageViewController.imageToShow = pickedImage
            self.navigationController!.pushViewController(confirmImageViewController, animated: true)
        }
        dismiss(animated: true, completion: nil)
    }
}
