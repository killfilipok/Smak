//
//  AuthService.swift
//  Smack
//
//  Created by Philip on 3/4/19.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: USER_TOKEN) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_TOKEN)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    func registerUser(email :String, password: String, completion: @escaping CompletionHandler){
        let lowerCaseEmail = email.lowercased()
        
        let body : [String:Any] = [
            "email":lowerCaseEmail,
            "password":password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            
            let error = response.result.error
            
            completion(error == nil)
            
            if(error != nil) {
                debugPrint(error as Any)
            }
        }
    }
    
    func logInUser(email:String,password:String, completionHendaler: @escaping CompletionHandler){
        let lowerCaseEmail = email.lowercased()
        
        let body : [String:Any] = [
            "email":lowerCaseEmail,
            "password":password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {return}
                let json = JSON(data: data)
                self.userEmail = json["user"].stringValue
                self.authToken = json["token"].stringValue
                
                
                completionHendaler(true)
            } else {
                completionHendaler(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func createUser(name:String, email:String,avatarName:String, avatarColor:String, completionHandler: @escaping CompletionHandler){
        let lowerCaseEmail = email.lowercased()
        
        let body :[String: Any] = [
            "name": name,
            "email":lowerCaseEmail,
            "avatarName":avatarName,
            "avatarColor":avatarColor
        ]
        
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
        
            if response.result.error == nil {
                guard let data = response.data else {return}
                
                self.setUserInfo(data: data)
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
    
    func findUserByEmail(completion: @escaping CompletionHandler){
        
        Alamofire.request("\(URL_FIND_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {return}
                
                self.setUserInfo(data: data)
                completion(true)
            } else {
                completion(false)
            }
        }
        
    }
    
    func setUserInfo(data: Data){
        let json = JSON(data: data)
        let id = json["_id"].stringValue
        let avatar = json["avatarName"].stringValue
        let color = json["avatarColor"].stringValue
        let email = json["email"].stringValue
        let name = json["name"].stringValue
        
        UserDataService.instance.setUserData(id: id, avatar: color, avatarName: avatar, email: email, name: name)
    }
}
