//
//  AuthViewController.swift
//  SnapView
//
//  Created by Alperen Ünal on 10.02.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AuthViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    
    var loginMode = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func topTapped(_ sender: Any) {
        
        if let email = emailTextField.text{
            if let password = passwordTextField.text{
                if loginMode{
                    
                    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                        if error == nil{
                            self.performSegue(withIdentifier: "authSuccess", sender: nil)
                        }
                        else{
                            print("Error:\(error!)")
                        }
                    }
                    
                }
                else{
                    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                        if error == nil{
                            
                            if let uid = result?.user.uid{
                                
                                Database.database().reference().child("users").child(uid).child("email").setValue(email)
                                self.performSegue(withIdentifier: "authSuccess", sender: nil)
                            }
                            
                            
                        }
                        else{
                            print("Error:\(error!)")
                        }
                    }
                }
            }
        }
        
       
    }
    
    
    @IBAction func bottomTapped(_ sender: Any) {
        if loginMode{
            loginMode = false
            topButton.setTitle("Sign Up", for: .normal)
            bottomButton.setTitle("Switch to Sign In", for: .normal)
        }
        else{
            loginMode=true
            topButton.setTitle("Sign In", for: .normal)
            bottomButton.setTitle("Switch to Sign Up", for: .normal)
        }
    }
    

}
