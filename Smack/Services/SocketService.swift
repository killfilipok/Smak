//
//  SocketService.swift
//  Smack
//
//  Created by Philip on 3/11/19.
//  Copyright © 2019 Philip. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
    
    let manager: SocketManager
    let socket: SocketIOClient
    
    override init() {
        self.manager = SocketManager(socketURL: URL(string: BASE_URL)!)
        self.socket = manager.defaultSocket
        super.init()
    }
    
    func establishConnection(){
        socket.connect()
    }
    
    func closeConnection(){
        socket.disconnect()
    }
    
    func addChanel(name: String, desc:String,completion: @escaping CompletionHandler){
        socket.emit("newChannel", name, desc)
        completion(true)
    }
    
    func getChanel(completion: @escaping CompletionHandler){
        socket.on("channelCreated") { (dataArr, ack) in
            guard let chanelName = dataArr[0] as? String else {return}
            guard let chanelDesc = dataArr[1] as? String else {return}
            guard let chanelId = dataArr[2] as? String else {return}
            
            let newChanel = Chanel(name: chanelName, description: chanelDesc,id: chanelId)
            
            MessageService.instance.chanels.append(newChanel)
            completion(true)
        }
    }
    
    func addMessage(messageBody: String, userId:String, channelId:String,completion: @escaping CompletionHandler){
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName,user.avatar)
        completion(true)
    }
    
    func getChatMessage(completion: @escaping (_ newMessage: Message) -> Void) {
        socket.on("messageCreated") { (dataArray, ack) in
            guard let messageBody = dataArray[0] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            guard let userName = dataArray[3] as? String else {return}
            guard let userAvatar = dataArray[4] as? String else {return}
            guard let userAvatarColor = dataArray[5] as? String else {return}
            guard let id = dataArray[6] as? String else {return}
            guard let timeStamp = dataArray[7] as? String else {return}
            
            let newMsg = Message(message: messageBody,userName:userName,ChannelId:channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timestamp: timeStamp)
            
            completion(newMsg)
        }
    }
    
    func getTypingUsers(_ completionHandeler: @escaping (_ typingUsers : [String: String]) -> Void){
        
        socket.on("userTypingUpdate") { (dataArray, ack) in
            guard let users = dataArray[0] as? [String: String] else {return}
            
            completionHandeler(users)
        }
    }
}
