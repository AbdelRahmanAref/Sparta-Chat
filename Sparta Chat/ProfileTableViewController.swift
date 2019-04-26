//
//  ProfileTableViewController.swift
//  Sparta Chat
//
//  Created by AbdelRahman Aref on 4/23/19.
//  Copyright © 2019 AbdelRahman Aref. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var messageButtonOutlet: UIButton!
    @IBOutlet weak var callButtonOutlet: UIButton!
    @IBOutlet weak var blockButtonOutlet: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!

    var user: FUser?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

    }

    @IBAction func callButtonPressed(_ sender: Any) {

    }


    @IBAction func chatButtonPressed(_ sender: Any) {

    }

    @IBAction func blockuserButtonPressed(_ sender: Any) {
        var currentBlockIds = FUser.currentUser()!.blockedUsers
        if currentBlockIds.contains(user!.objectId){
            currentBlockIds.remove(at: currentBlockIds.index(of: user!.objectId)!)
        }else{
            currentBlockIds.append(user!.objectId)
        }
        updateCurrentUserInFirestore(withValues: [kBLOCKEDUSERID: currentBlockIds]) { (error) in
            if error != nil {
                print("error updating user \(error?.localizedDescription)")
                return
            }else{//update button outlet
                self.updateBlockStatus()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //clean view
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //first section
        if section == 0 {
            return 0
        }
        // the second and third section
        return 30
    }

    //MARK:- Setup UI
    func setupUI(){
        if user != nil {
            self.title = "Profile"
            fullnameLabel.text = user!.fullname
            phoneNumberLabel.text = user!.phoneNumber
            updateBlockStatus()
            imageFromData(pictureData: user!.avatar) { (avatarImage) in
                if avatarImage != nil {
                    self.avatarImageView.image = avatarImage!.circleMasked
                }
            }
        }
    }

    func updateBlockStatus(){
        if user!.objectId != FUser.currentId(){
            blockButtonOutlet.isHidden = false
            messageButtonOutlet.isHidden = false
            callButtonOutlet.isHidden = false
        }else {
            blockButtonOutlet.isHidden = true
            messageButtonOutlet.isHidden = true
            callButtonOutlet.isHidden = true
        }
        if FUser.currentUser()!.blockedUsers.contains(user!.objectId){
            blockButtonOutlet.setTitle("Unblock User", for: .normal)
        }else{
            blockButtonOutlet.setTitle("Block User", for: .normal)
        }
    }
}
