//
//  CreateSnapViewController.swift
//  SnapView
//
//  Created by Alperen Ünal on 10.02.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import FirebaseStorage

class CreateSnapViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var noteTextField: UITextField!
    
    var imagePicker = UIImagePickerController()
    var imageName = "\(NSUUID().uuidString).jpeg"
    var imageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        let imagesFolder = Storage.storage().reference().child("images")
        if let image = imageView.image{
            
            if let imageData = image.jpegData(compressionQuality: 0.1){
                imagesFolder.child(imageName).putData(imageData, metadata: nil) { (metaData, error) in
                    if let error = error {
                        print(error)
                    }
                    else{
                        imagesFolder.child(self.imageName).downloadURL(completion: { (url, error) in
                            if let imageURL = url?.absoluteString{
                                self.imageURL = imageURL
                                self.performSegue(withIdentifier: "moveToSender", sender: nil)
                            }
                        })
                        
                    }
                }
                
            }
        }
       
        
    }
    
    
    @IBAction func camTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func choosePhotoTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage]{
            
            imageView.image = selectedImage as! UIImage
            dismiss(animated: true, completion: nil)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedVC = segue.destination as? SelectUserTableViewController{
            selectedVC.imageName = imageName
            selectedVC.imageURL = imageURL
            if let message = noteTextField.text{
                selectedVC.message = message
            }
        }
    }
    
    

   
}