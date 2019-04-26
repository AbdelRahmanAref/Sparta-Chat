//
//  UsersTableViewController.swift
//  Sparta Chat
//
//  Created by AbdelRahman Aref on 4/22/19.
//  Copyright © 2019 AbdelRahman Aref. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class UsersTableViewController: UITableViewController, UISearchResultsUpdating,UserTableViewCellDelegate {



    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var filterSegmentedController: UISegmentedControl!

    var allUsers: [FUser] = []
    var filteredUsers : [FUser] = []
    var allUsersGrouped = NSDictionary() as! [String: [FUser]]
    var sectionTitleList : [String] = []
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Users"
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        loadUsers(filter: kCITY)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
        }else {
            return allUsersGrouped.count
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredUsers.count
        }else {
            //find section title
            let sectionTitle = self.sectionTitleList[section]

            //user for given tile
            let users = self.allUsersGrouped[sectionTitle]
            return users!.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
        var user: FUser
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filteredUsers[indexPath.row]
        }else {
            let sectionTitle = self.sectionTitleList[indexPath.section]
            let users = self.allUsersGrouped[sectionTitle]
            user = users![indexPath.row]
        }

        cell.generateCellWith(fUser: user, indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    //MARK: Table view delegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return ""
        }else {
            return sectionTitleList[section]
        }
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return nil
        }else {
            return self.sectionTitleList
        }
    }

    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }

    func loadUsers(filter: String){
        ProgressHUD.show()
        var query : Query!
        switch filter {
        case kCITY:
            query = reference(.User).whereField(kCITY, isEqualTo: FUser.currentUser()!.city).order(by: kFIRSTNAME, descending: false)
        case kCOUNTRY:
            query = reference(.User).whereField(kCOUNTRY, isEqualTo: FUser.currentUser()!.country).order(by: kFIRSTNAME, descending: false)
        default://get all users and filter by firstname
            query = reference(.User).order(by: kFIRSTNAME, descending: false)
        }

        query.getDocuments { (snapshot, error) in
            //emptying the array and dictionary not to show multiples of the same users
            self.allUsers = []
            self.sectionTitleList = []
            self.allUsersGrouped = [:]
            if error != nil {
                print(error!.localizedDescription)
                ProgressHUD.dismiss()
                self.tableView.reloadData()
                return
            }
            //if no error, check for snapshot
            guard let snapshot = snapshot else {
                ProgressHUD.dismiss()
                return
            }
            //snapshot contain all documents
            //if we have data in tableview, present it
            if !snapshot.isEmpty{
                for userDictionary in snapshot.documents {
                    let userDictionary = userDictionary.data() as NSDictionary
                    let fUser = FUser(_dictionary: userDictionary)
                    if fUser.objectId != FUser.currentId(){//return current id of logged in user
                        self.allUsers.append(fUser)
                    }
                }
                //split to groups
                self.splitDataIntoSections()
                self.tableView.reloadData()
            }
            self.tableView.reloadData()
            ProgressHUD.dismiss()
        }
    }

    //MARK: IBActions

    @IBAction func filterSegmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: //city
            loadUsers(filter: kCITY)
        case 1: //country
            loadUsers(filter: kCOUNTRY)
        case 2: //all
            loadUsers(filter: "")
        default:
            return
        }
    }

    //MARK: Search Controllers functions
    func filterContentForSearchText(searchText: String, scope: String = "All"){
        filteredUsers = allUsers.filter({ (user) -> Bool in
            return user.firstname.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }

    //MARK: Helper functions
    fileprivate func splitDataIntoSections(){
        var sectionTitle: String = ""
        for i in 0..<self.allUsers.count {
            let currentUser = self.allUsers[i]
            let firstChar = currentUser.firstname.first!
            let firstCharString = "\(firstChar)"
            if firstCharString != sectionTitle {
                sectionTitle = firstCharString
                self.allUsersGrouped[sectionTitle] = []
                self.sectionTitleList.append(sectionTitle)
            }
            self.allUsersGrouped[firstCharString]?.append(currentUser)
        }
    }
    //MARK:- usertableviewcell delegate
    func didTapAvatarImage(indexPath: IndexPath) {
        print("user avatar tap at \(indexPath)")
        let profileVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileView") as! ProfileTableViewController

        var user: FUser
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filteredUsers[indexPath.row]
        }else {
            let sectionTitle = self.sectionTitleList[indexPath.section]
            let users = self.allUsersGrouped[sectionTitle]
            user = users![indexPath.row]
        }

        profileVC.user = user
        
        self.navigationController?.pushViewController(profileVC, animated: true)

    }
}
