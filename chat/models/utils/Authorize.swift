//
//  Authorize.swift
//  chat
//
//  Created by Hubert Sośnicki on 06/03/2021.
//

import Foundation
import UIKit

class AuthorizeUtil {
    static func setActiveUser(segue: UIStoryboardSegue, activeUser: User) {
        if segue.destination is UsersListViewController {
            let vc = segue.destination as? UsersListViewController
            vc?.activeUser = activeUser
        }
    }
}
