//
//  MessageService.swift
//  Smack
//
//  Created by Philip on 3/5/19.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    
    var chanels = [Chanel]()
    var unreadChanels = [String]()
    var messages = [Message]()
    var selectedChannel : Chanel?
    
    func findAllChanels(completion: @escaping CompletionHandler){
        Alamofire.request(URL_GET_CHANELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER)
            .responseJSON { (response) in

                if response.result.error == nil {

//                    self.chanels.removeAll()
                    
                    guard let data = response.data else {return}
                    //                    do {
                    //                        self.chanels = try JSONDecoder().decode([Chanel].self, from: data)
                    //                    } catch let error {
                    //                        debugPrint(error as Any)
                    //                    }
                    if let json = JSON(data: data).array {
                        for item in json {
                            let name = item["name"].stringValue
                            let chanelDesc = item["description"].stringValue
                            let id = item["_id"].stringValue

                            let chanel = Chanel(name:name, description: chanelDesc, id: id)
                            self.chanels.append(chanel)
                        }
                    }
                    print("chanels count: \(self.chanels.count)")
                    
                    NotificationCenter.default.post(name: NOTIF_CHANELS_LOADED, object: nil)

                    completion(true)

                } else {
                    completion(false)
                    debugPrint(response.result.error as Any)
                }
        }
    }
    
    func getAllMessagesForChannel(channelId:String, completion: @escaping CompletionHandler){
        
        print("getAllMessagesForChannel: start")
        Alamofire.request("\(URL_GET_MESSAGES)/\(channelId)", method: .get
            , parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
                
                print("getAllMessagesForChannel: \(response.result.error == nil)")
                if response.result.error == nil {
                    self.clearMessages()
                    guard let data = response.data else {return}
                    if let json = JSON(data: data).array{
                        for item in json {
                            let messageBody = item["messageBody"].stringValue
                            let channelId = item["channelId"].stringValue
                            let id = item["_id"].stringValue
                            let userName = item["userName"].stringValue
                            let userAvatar = item["userAvatar"].stringValue
                            let userAvatarColor = item["userAvatarColor"].stringValue
                            let timeStamp = item["timeStamp"].stringValue
                            
                            let message = Message(message: messageBody,userName:userName,ChannelId:channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timestamp: timeStamp)
                            self.messages.append(message)
                        }
                        print("messages: ")
                        print(self.messages)
                        completion(true)
                    }
                    
                } else {
                    debugPrint(response.result.error as Any)
                    completion(false)
                }
        }
    }
    
    func clearMessages(){
        messages.removeAll()
    }
    
    func clearChannels(){
        chanels.removeAll()
    }
}
