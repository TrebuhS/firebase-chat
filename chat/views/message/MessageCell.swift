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
    @IBOutlet weak var imageBox: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
