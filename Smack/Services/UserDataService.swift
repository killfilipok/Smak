//
//  UserDataService.swift
//  Smack
//
//  Created by Philip on 3/5/19.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    public private(set) var id = ""
    public private(set) var avatar = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id:String,avatar:String,avatarName:String,email:String, name:String){
        self.id = id
        self.avatar = avatar
        self.avatarName = avatarName
        self.email = email
        self.name = name
        print(id, avatar, avatarName, email,name, "------")
    }
    
    func setAvatarName(avatarName:String){
        self.avatarName = avatarName
    }
    
    func returnUIColor(colorStr:String) -> UIColor{
        let scaner = Scanner(string: colorStr)
        
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scaner.charactersToBeSkipped = skipped
        
        var r, g, b, a :NSString?
        
        scaner.scanUpToCharacters(from: comma, into: &r)
        scaner.scanUpToCharacters(from: comma, into: &g)
        scaner.scanUpToCharacters(from: comma, into: &b)
        scaner.scanUpToCharacters(from: comma, into: &a)
        
        let defaultColor = UIColor.lightGray
        
        guard let rUnwrapped = r else {return defaultColor}
        guard let gUnwrapped = g else {return defaultColor}
        guard let bUnwrapped = b else {return defaultColor}
        guard let aUnwrapped = a else {return defaultColor}
        
        let rFloat = CGFloat(rUnwrapped.doubleValue)
        let gFloat = CGFloat(gUnwrapped.doubleValue)
        let bFloat = CGFloat(bUnwrapped.doubleValue)
        let aFloat = CGFloat(aUnwrapped.doubleValue)
        
        let newUIColor = UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)
        
        return newUIColor
    }
    
    
    func logoutUser(){
        id = ""
        avatarName = ""
        avatar = ""
        email = ""
        name = ""
        AuthService.instance.isLoggedIn = false
        AuthService.instance.authToken = ""
        AuthService.instance.userEmail = ""
        MessageService.instance.clearChannels()
        MessageService.instance.clearMessages()
    }
}
