//
//  UserTableViewCell.swift
//  Sparta Chat
//
//  Created by AbdelRahman Aref on 4/22/19.
//  Copyright © 2019 AbdelRahman Aref. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {


    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!

    var indexPath: IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    func generateCellWith(fUser: FUser, indexPath: IndexPath){
        self.indexPath = indexPath
        self.fullnameLabel.text = fUser.fullname
        //convert image from string to image
        if fUser.avatar != nil {
            imageFromData(pictureData: fUser.avatar) { (avatarImage) in
                if avatarImage != nil {
                    self.avatarImageView.image = avatarImage!.circleMasked
                }
            }
        }

    }






}
