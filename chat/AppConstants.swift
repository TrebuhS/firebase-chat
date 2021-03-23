//
//  AppConstants.swift
//  chat
//
//  Created by Hubert Sośnicki on 15/02/2021.
//

import Foundation

struct Constants {
    struct Segues {
        static let RegisterToUsersList = "RegisterToUsersList"
        static let LoginToUsersList = "LoginToUsersList"
        static let UsersListToChat = "UsersListToChat"
        static let UsersListToStart = "UsersListToStart"
    }
    
    struct Identifiers {
        static let MessageCell = "MessageCell"
        static let UserCell = "UserCell"
    }
    
    struct Firebase {
        struct Collection {
            static let users = "users"
            static let messages = "messages"
        }
    }
}
