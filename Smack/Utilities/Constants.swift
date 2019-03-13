//
//  Constants.swift
//  Smack
//
//  Created by Philip on 3/4/19.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ success: Bool) -> ()

// URL Constants
let BASE_URL = "http://localhost:3005/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"
let URL_FIND_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
let URL_GET_CHANELS = "\(BASE_URL)channel/"
let URL_GET_MESSAGES = "\(BASE_URL)message/byChannel"

//Colors
let smackPurplePlaceholder = #colorLiteral(red: 0.2588235294, green: 0.3294117647, blue: 0.8509803922, alpha: 0.4950235445)

//Notification Constants
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("NOTIF_USER_DATA_DID_CHANGE")
let NOTIF_CHANELS_LOADED = Notification.Name("NOTIF_CHANELS_LOADED")
let NOTIF_CHANEL_SELECTED = Notification.Name("NOTIF_CHANEL_SELECTED")

//Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND_TO_CHANEL = "unwindToChanel"
let TO_AVATAR_PICKER = "toAvatarPicker"

//User Defaults
let USER_EMAIL = "USER_EMAIL"
let USER_TOKEN = "USER_TOKEN"
let LOGGED_IN_KEY = "LOGGED_IN_KEY"


//Headers
let HEADER = [
    "Content-Type":"application/json; charset=utf-8"
]
let BEARER_HEADER = [
    "Authorization":"Bearer \(AuthService.instance.authToken)",
    "Content-Type":"application/json; charset=utf-8"
]
