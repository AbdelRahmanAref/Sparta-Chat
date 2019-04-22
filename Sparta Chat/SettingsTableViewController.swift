//
//  SettingsTableViewController.swift
//  Sparta Chat
//
//  Created by AbdelRahman Aref on 4/22/19.
//  Copyright © 2019 AbdelRahman Aref. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {









    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true


    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }



    @IBAction func logoutButtonPressed(_ sender: Any) {
        FUser.logOutCurrentUser { (success) in
            if success {
               // show login view
                self.showLoginView()
            }
        }

    }
    func showLoginView(){
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "welcome")
        self.present(mainView, animated: true, completion: nil)

    }
}
