//
//  ProductDetailVC.swift
//  C0695706_FinalProject
//
//  Created by Amy kang on 2017-07-25.
//  Copyright © 2017 Amy kang. All rights reserved.
//

import UIKit
import CoreData
import FirebaseDatabase

class ProductDetailVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var name1 = ""
    var price1 = ""
    var desc1 = ""
    var image1 = ""
    
    var chosenItem = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = name1
        priceLabel.text = price1
        descLabel.text = desc1
        imageView.image = UIImage()
        
        
        
        // .................................
        if chosenItem != "" {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Items")
            //   using predicate to filter result ...
            fetchRequest.predicate = NSPredicate(format: "name = %@", self.chosenItem)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        
                        if (result.value(forKey: "name") as? String) != nil {
                            nameLabel.text = name1
                        }
                        if (result.value(forKey: "year") as? Int) != nil {
                            priceLabel.text = String(price1)
                        }
                        if (result.value(forKey: "artist") as? String) != nil {
                            descLabel.text = desc1
                                                    }
                        if let imageData = result.value(forKey: "image") as? Data {
                        let image = UIImage(data: imageData)
                        self.imageView.image = image
                        }
                        
                    }
                    
                    
                    
                }
            } catch {
                
                print("error")
            }
            
        } else {
            print("Error")
        }
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        
        
    }

    
    
    @IBAction func addToCart(_ sender: Any) {
        
        
        
        guard let appDelegate =
            
            UIApplication.shared.delegate as? AppDelegate else {
                
                return
                
        }
        
        
        
        // 1
        
        let managedContext =
            
            appDelegate.persistentContainer.viewContext
        
        
        
        // 2
        
        let entity =
            
            NSEntityDescription.entity(forEntityName: "Items",
                                       
                                       in: managedContext)!
        
        
        
        let productData = NSManagedObject(entity: entity,
                                          
                                          insertInto: managedContext)
        
        
        
        // 3
        
        productData.setValue(name1, forKeyPath: "name")
        
        productData.setValue(Double(price1), forKeyPath: "price")
        
        productData.setValue(desc1, forKeyPath: "disc")
        
        
        
        // 4
        
        do {
            
            try managedContext.save()
            
            print("Record Inserted")
            
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
            
        }
        
        let alertController = UIAlertController(title: "Message", message: "Item added to cart", preferredStyle: .alert)
        
        
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        
        
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    
    
}
