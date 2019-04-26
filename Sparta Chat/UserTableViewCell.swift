//
//  UserTableViewCell.swift
//  Sparta Chat
//
//  Created by AbdelRahman Aref on 4/22/19.
//  Copyright © 2019 AbdelRahman Aref. All rights reserved.
//

import UIKit

protocol UserTableViewCellDelegate {
    func didTapAvatarImage(indexPath: IndexPath)
}

class UserTableViewCell: UITableViewCell {


    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!

    var indexPath: IndexPath!
    let tapGestureRecognizer = UITapGestureRecognizer()
    var delegate: UserTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        tapGestureRecognizer.addTarget(self, action: #selector(self.avatarTap))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
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

    @objc func avatarTap(){
        print("avatar tapped at \(indexPath)")
        delegate?.didTapAvatarImage(indexPath: indexPath)
    }




}
