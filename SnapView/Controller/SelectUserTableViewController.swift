//
//  SelectUserTableViewController.swift
//  SnapView
//
//  Created by Alperen Ünal on 10.02.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SelectUserTableViewController: UITableViewController {

    let snap = Snap()
    var imageName = ""
    var imageURL = ""
    var message = ""
    var users : [User] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            if let userDictionary = snapshot.value as? NSDictionary{
                if let email = userDictionary["email"] as? String {
                    let user = User()
                    user.email=email
                    user.uid = snapshot.key
                    self.users.append(user)
                    self.tableView.reloadData()
                }
            }
        }
      
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = users[indexPath.row]
        cell.textLabel?.text = user.email
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        if let fromEmail = Auth.auth().currentUser?.email{
            snap.imageName = self.imageName
            snap.imageURL = self.imageURL
            snap.message = self.message
            let snapDictionary = ["from":fromEmail, "imageName":snap.imageName, "imageURL":snap.imageURL, "message":snap.message]
            Database.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snapDictionary)
            navigationController?.popToRootViewController(animated: true)
        }
    }

}
