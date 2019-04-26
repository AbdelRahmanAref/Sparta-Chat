//
//  ChatViewController.swift
//  Sparta Chat
//
//  Created by AbdelRahman Aref on 4/22/19.
//  Copyright © 2019 AbdelRahman Aref. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    //MARK: IBActions

    @IBAction func createNewChatButtonPressed(_ sender: Any) {
        let userVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersTableView") as! UsersTableViewController
        self.navigationController?.pushViewController(userVC, animated: true)
    }


}
