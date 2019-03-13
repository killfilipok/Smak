//
//  ChanelVC.swift
//  Smack
//
//  Created by Philip on 3/4/19.
//  Copyright © 2019 Philip. All rights reserved.
//

import UIKit

class ChanelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    @IBOutlet weak var profImg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector(ChanelVC.userDataDidChanged(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChanelVC.chanelsDataDidChanged(_:)), name: NOTIF_CHANELS_LOADED, object: nil)
        
        SocketService.instance.getChanel { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
        SocketService.instance.getChatMessage { (newMessage) in
            print(" new" )
            if newMessage.id != MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn{
                MessageService.instance.unreadChanels.append(newMessage.ChannelId)
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpUserInfo()
    }
    
    //actions
    @IBAction func loginBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    @IBAction func createChanelPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn{
            let addChanel = AddChanelVC()
            addChanel.modalPresentationStyle = .custom
            present(addChanel, animated: true, completion: nil)
        }
    }
    
    
    @objc func userDataDidChanged(_ notif: Notification){
        setUpUserInfo()
    }
    @objc func chanelsDataDidChanged(_ notif: Notification){
        tableView.reloadData()
    }
    
    func setUpUserInfo(){
        print(UserDataService.instance.name, AuthService.instance.isLoggedIn,  "------")
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            profImg.image = UIImage(named: UserDataService.instance.avatarName)
            profImg.backgroundColor = UserDataService.instance.returnUIColor(colorStr: UserDataService.instance.avatar)
        } else {
            loginBtn.setTitle("Login", for: .normal)
            profImg.image = UIImage(named: "menuProfileIcon")
            profImg.backgroundColor = UIColor.clear
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.chanels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell {
            let channel = MessageService.instance.chanels[indexPath.row]
            cell.configureCell(chanel: channel)
            return cell
        } else {
            return ChannelCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chanel = MessageService.instance.chanels[indexPath.row]
        MessageService.instance.selectedChannel = chanel
        NotificationCenter.default.post(name: NOTIF_CHANEL_SELECTED, object: nil)
        
        if MessageService.instance.unreadChanels.count > 0 {
        MessageService.instance.unreadChanels = MessageService.instance.unreadChanels.filter {$0 != chanel.id}
        }
        
        let index = IndexPath(row: indexPath.row, section: 0)
        tableView.reloadRows(at: [index], with: .none)
        tableView.selectRow(at: index, animated: false, scrollPosition: .none)
        
        self.revealViewController()?.revealToggle(animated: true)
    }
}
