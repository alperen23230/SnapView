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
   
    @IBOutlet private var topButton: CustomButton!
    @IBOutlet private var bottomButton: CustomButton!
    
    var loginMode = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topButton.setTitle("Sign In", for: .normal)
        self.bottomButton.setTitle("Switch to Sign Up", for: .normal)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
    }
    
    
  



    @IBAction func topButton(_ sender: CustomButton) {
        if let email = emailTextField.text{
            if let password = passwordTextField.text{
                if loginMode{
                    
                    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                        if error == nil{
                            self.performSegue(withIdentifier: "authSuccess", sender: nil)
                        }
                        else{
                            
                            if let errCode = AuthErrorCode(rawValue: error!._code){
                                
                                switch errCode {
                                case .wrongPassword:
                                    print("wrong password")
                                    _ = SweetAlert().showAlert("This password is wrong!", subTitle: "", style: AlertStyle.error)
                                case .missingEmail:
                                    print("This e-mail not in the system")
                                    _ = SweetAlert().showAlert("This e-mail not in the system", subTitle: "", style: AlertStyle.error)
                                case .userNotFound:
                                    _ = SweetAlert().showAlert("This e-mail not in the system", subTitle: "", style: AlertStyle.error)
                                default:
                                    print("Create User Error: \(String(describing: error))")
                                }
                                
                            }
                            
                            
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
                            if let errCode = AuthErrorCode(rawValue: error!._code){
                                
                                switch errCode {
                                case .invalidEmail:
                                    print("invalid email")
                                    _ = SweetAlert().showAlert("This E-mail is invalid!", subTitle: "", style: AlertStyle.error)
                                case .emailAlreadyInUse:
                                    print("in use")
                                     _ = SweetAlert().showAlert("This E-mail is already in", subTitle: "use!", style: AlertStyle.error)
                                case .weakPassword:
                                     _ = SweetAlert().showAlert("This password is too", subTitle: "weak!", style: AlertStyle.error)
                                default:
                                    print("Create User Error: \(String(describing: error))")
                                }
                                
                            }
//                            print("Error:\(error!)")
                        }
                    }
                }
            }
        }

    }
    



    @IBAction func bottomTapped(_ sender: CustomButton) {
        
        if loginMode{
            loginMode = false
            topButton.shake()
            topButton.setTitle("Sign Up", for: .normal)
            bottomButton.setTitle("Switch to Sign In", for: .normal)
        }
        else{
            loginMode=true
            topButton.shake()
            topButton.setTitle("Sign In", for: .normal)
            bottomButton.setTitle("Switch to Sign Up", for: .normal)
        }
    }
    
    
}


