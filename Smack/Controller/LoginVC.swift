//
//  LoginVC.swift
//  Smack
//
//  Created by Philip on 3/4/19.
//  Copyright © 2019 Philip. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    //Outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    //Actions
    @IBAction func loginPressed(_ sender: Any) {
        spiner.isHidden = false
        spiner.startAnimating()
        
        guard let email = emailTxt.text, emailTxt.text != "" else {return}
        guard let pass = passwordTxt.text, passwordTxt.text != "" else {return}
        
        AuthService.instance.logInUser(email: email, password: pass) { (success) in
            if success {
                AuthService.instance.findUserByEmail(completion: { (success) in
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                })
                self.spiner.isHidden = true
                self.spiner.stopAnimating()
                AuthService.instance.isLoggedIn = true
                self.dismiss(animated: true, completion: nil)
            } else {
                
            }
        }
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    func setUpView(){
        spiner.isHidden = true
        emailTxt.attributedPlaceholder = NSAttributedString(string:"username", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder])
        passwordTxt.attributedPlaceholder = NSAttributedString(string:"password", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder])
    }
}
