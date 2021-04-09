//
//  UserCell.swift
//  chat
//
//  Created by Hubert Sośnicki on 02/03/2021.
//

import UIKit

protocol UserCellProtocol {
    func handleUserSelection(user: User?)
}

class UserCell: UITableViewCell {
    @IBOutlet weak var userEmailLabel: UILabel!
    var delegate: UserCellProtocol?
    var user: User?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            delegate?.handleUserSelection(user: self.user)
        }
    }
    
}
