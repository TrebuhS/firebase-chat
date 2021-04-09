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
            struct Messages {
                static let CollectionName = "messages"
                struct Fields {
                    static let Receiver = "receiver"
                    static let Sender = "sender"
                    static let Text = "text"
                    static let Date = "date"
                }
            }
            static let users = "users"
        }
    }
}
