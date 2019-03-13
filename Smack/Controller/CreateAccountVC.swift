//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Philip on 3/4/19.
//  Copyright © 2019 Philip. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    
    //outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    
    //Variables
    var avatarName = "profileDefault"
    var avatarColor = "[0.5,0.5,0.5,1]"
    var bgColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let storedAvatar = UserDataService.instance.avatarName
        
        if storedAvatar != "" {
            userImg.image = UIImage(named: storedAvatar)
            avatarName = storedAvatar
            
            if(avatarName.contains("light") && bgColor == nil){
                userImg.backgroundColor = UIColor.lightGray
            }
        }
    }
    //UI SetUP
    func setUpViews(){
        setUpTintFor(textField:usernameTxt,placeholder: "username")
        setUpTintFor(textField:emailTxt,placeholder: "email")
        setUpTintFor(textField:passwordTxt,placeholder: "password")
        spiner.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func endEditing(){
        view.endEditing(true)
    }
    
    func setUpTintFor(textField:UITextField, placeholder:String){
        textField.attributedPlaceholder = NSAttributedString(string:placeholder, attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder])
    }
    
    //Actions
    @IBAction func generateColorBtnPressed(_ sender: Any) {
        let r = CGFloat(arc4random_uniform(225)) / 225
        let g = CGFloat(arc4random_uniform(225)) / 225
        let b = CGFloat(arc4random_uniform(225)) / 225
        
        bgColor = UIColor(red: r, green:g , blue: b, alpha: 1)
        avatarColor = "[\(r),\(g),\(b), 1]"
        UIView.animate(withDuration: 0.2){
            self.userImg.backgroundColor = self.bgColor
        }
    }
    
    @IBAction func choseAvatarBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANEL, sender: nil)
    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        spiner.isHidden = false
        spiner.startAnimating()
        
        guard let name = usernameTxt.text, usernameTxt.text != "" else {return}
        guard let email = emailTxt.text, emailTxt.text != "" else {return}
        guard let pass = passwordTxt.text, passwordTxt.text != "" else {return}
        
        AuthService.instance.registerUser(email: email, password: pass, completion: { (success) in
            
            if(success){
                
                AuthService.instance.logInUser(email: email, password: pass, completionHendaler: { (success) in
                    
                    if success {
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completionHandler: {
                            (success) in
                            
                            if success {
                                self.spiner.isHidden = true
                                self.spiner.stopAnimating()
                                
                                AuthService.instance.isLoggedIn = true
                                
                                self.performSegue(withIdentifier: UNWIND_TO_CHANEL, sender: nil)
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                            }
                        })
                    }
                })
            } else {
                print("Error: Auth fail")
            }
        })
    }
}
