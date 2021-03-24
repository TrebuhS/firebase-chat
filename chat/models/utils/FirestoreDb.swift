//
//  FirestoreDb.swift
//  chat
//
//  Created by Hubert Sośnicki on 23/03/2021.
//

import Foundation
import Firebase

struct FirestoreDb {
    static func get() -> Firestore {
        return Firestore.firestore()
    }
}
