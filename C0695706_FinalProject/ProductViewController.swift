//
//  ProductViewController.swift
//  C0695706_FinalProject
//
//  Created by Amy kang on 2017-07-25.
//  Copyright © 2017 Amy kang. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import SDWebImage

class ProductViewController: UIViewController, UITableViewDataSource , UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!

    var nameTextArray = [String]()
    var postImageURLArray = [String]()
    
    
    var selectedItem = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromServer()
        
    }
    
    
    func getDataFromServer() {
        
        Database.database().reference().child("users").observe(DataEventType.childAdded, with: { (snapshot) in
            
            
            let values = snapshot.value! as! NSDictionary
            
            let posts = values["posts"] as! NSDictionary
            
            let postIDs = posts.allKeys
            
            for id in postIDs {
                
                let singlePost = posts[id] as! NSDictionary
                
                self.nameTextArray.append(singlePost["nameText"] as! String)
                self.postImageURLArray.append(singlePost["image"] as! String)
                
            }
            
            self.tableView.reloadData()
            
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameTextArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! productCell
        
        cell.nameText.text = nameTextArray[indexPath.row]
        cell.postImage.sd_setImage(with: URL(string: self.postImageURLArray[indexPath.row]))
        
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedItem = nameTextArray[indexPath.row]
        performSegue(withIdentifier: "toDisplayData", sender: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDisplayData" {
            let destinationVC = segue.destination as! ProductDetailVC
            destinationVC.chosenItem = selectedItem
        }
        
    }

    
    
    
    
    
    
   
//  ...............Add..............
    @IBAction func addButton(_ sender: Any) {
        
        performSegue(withIdentifier: "toAddToProduct", sender: nil)
    }
    
//...................LogOut.............
    @IBAction func logOutButtonClicked(_ sender: Any) {
        //     1. after creating permanent login ... creat log out option
        
        
        UserDefaults.standard.removeObject(forKey: "usersigned")
        UserDefaults.standard.synchronize()
        
        
        let signUp = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as!  SignInViewController
        
        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = signUp
        delegate.rememberLogin()
        
        
        
        
        
    }

    

   
}
