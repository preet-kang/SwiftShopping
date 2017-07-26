//
//  AddProductVC.swift
//  C0695706_FinalProject
//
//  Created by Amy kang on 2017-07-25.
//  Copyright © 2017 Amy kang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class AddProductVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var descText: UITextField!
    
   
    
    @IBOutlet weak var AddToCartButton: UIButton!


    var chosenProduct = ""
    
    

    var uuid = NSUUID().uuidString
    

    override func viewDidLoad() {
        super.viewDidLoad()

        postImage.isUserInteractionEnabled = true
        let gerstureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddProductVC.selectImage))
        postImage.addGestureRecognizer(gerstureRecognizer)
    }

    
    // 2. func
    
    func selectImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
       
    }
    
    //    3. Func image picker controller
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        postImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }

    
    
    
    
    
//    ...........Save Button......................
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        self.AddToCartButton.isEnabled = false
        
        //        4. create storage
        let mediaFolder = Storage.storage().reference().child("media")
        //        create data out of image
        if  let data = UIImageJPEGRepresentation(postImage.image!, 0.5) {
            mediaFolder.child("\(uuid).jpg").putData(data, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    //  5. save post to database after uploading
                    
                    let imageURL = metadata?.downloadURL()?.absoluteString
                    
                    let post = ["image" : imageURL!, "postedby" : Auth.auth().currentUser!.email!,"uuid": self.uuid, "nameText" : self.nameText.text! , "priceText" : self.priceText.text! , "descText" : self.descText.text! ] as [String : Any]
                    
                    Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("posts").childByAutoId().setValue(post)
                    
                    self.postImage.image = UIImage(named: "tapme.png")
                    self.nameText.text = ""
                    self.priceText.text = ""
                    self.descText.text = ""
                    self.AddToCartButton.isEnabled = true
                    self.tabBarController?.selectedIndex = 0
                    
                    
                }
                
            })
            
        }
        
        
        
    }
    

        
        
    }

    
   

