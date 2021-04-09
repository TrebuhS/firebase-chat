//
//  MessageDto.swift
//  chat
//
//  Created by Hubert Sośnicki on 24/03/2021.
//

import Foundation
import FirebaseFirestore

struct MessageDto: Codable {
    let sender: String
    let receiver: String
    let text: String
    let date: Timestamp
}
