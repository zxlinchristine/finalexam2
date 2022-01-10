//
//  NewTableViewController.swift
//  SlideImage
//
//  Created by NDHU_CSIE on 2022/1/3.
//

import UIKit

class NewTableViewController: UITableViewController {
    
    @IBOutlet var nameTextField: RoundedTextField! {
        didSet {
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
        }
    }
    @IBOutlet var cityTextField: RoundedTextField! {
        didSet {
            cityTextField.tag = 2
            cityTextField.delegate = self
        }
    }
    @IBOutlet var addressTextField: RoundedTextField! {
        didSet {
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }
   
    @IBOutlet var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.tag = 4
            descriptionTextView.layer.cornerRadius = 10.0
            descriptionTextView.layer.masksToBounds = true
        }
    }
    @IBOutlet var photoImageView: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - UITableViewDelegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {  // select the first cell contained one image view
            
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    imagePicker.delegate = self
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.delegate = self
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            
            // For iPad only
            if let popoverController = photoSourceRequestController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            present(photoSourceRequestController, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func saveButtonTapped(sender: UIButton) {
        //Check empty fields and trigger an alert message
        if nameTextField.text == "" || cityTextField.text == "" || addressTextField.text == "" || descriptionTextView.text == "" {
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        //Create a managed object in the context
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let restaurant = Restaurant(context: appDelegate.persistentContainer.viewContext)
        
        // Set the property values from the edit text fields
        restaurant.name = nameTextField.text!
        restaurant.type = cityTextField.text!
        restaurant.location = addressTextField.text!
        restaurant.summary = descriptionTextView.text
        if let imageData = photoImageView.image?.pngData() {  //having a default image already
            restaurant.image = imageData
        }
        
        // Save the data to the data store
        appDelegate.saveContext()
        
        // Dismiss the current view controller
        dismiss(animated: true, completion: nil)
    }
    

}
    // MARK: - UITextFieldDelegate methods

    extension NewTableViewController: UITextFieldDelegate  {
      
        // auto return to the next input textfield
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if let nextTextField = view.viewWithTag(textField.tag + 1) {
                textField.resignFirstResponder()
                nextTextField.becomeFirstResponder()
            }
            
            return true
        }
    }
    
    
// MARK: - UIImagePickerControllerDelegate methods

extension NewTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Retrieve the image picked up by the usr
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        
        //set constraints here
        
        // get the selectedImageName
        //if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
        //selectedImageName = url.path
        //print(selectedImageName)
        //}
        
        
        dismiss(animated: true, completion: nil)
    }

}
