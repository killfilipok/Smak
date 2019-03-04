//
//  ChanelVC.swift
//  Smack
//
//  Created by Philip on 3/4/19.
//  Copyright © 2019 Philip. All rights reserved.
//

import UIKit

class ChanelVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    }

}
