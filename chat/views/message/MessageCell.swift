//
//  MessageCellTableViewCell.swift
//  chat
//
//  Created by Hubert Sośnicki on 18/02/2021.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var messageBox: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var chatUserAvatarBox: UIView!
    @IBOutlet weak var activeUserAvatarBox: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        styleAvatarBox(avatarBox: chatUserAvatarBox)
        styleAvatarBox(avatarBox: activeUserAvatarBox)
        
        messageBox.layer.cornerRadius = 10
        messageBox.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func styleAvatarBox(avatarBox: UIView) {
        avatarBox.layer.cornerRadius = avatarBox.frame.height / 2
        avatarBox.layer.masksToBounds = true
    }
}
