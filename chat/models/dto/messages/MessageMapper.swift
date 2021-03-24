//
//  MessageMapper.swift
//  chat
//
//  Created by Hubert Sośnicki on 24/03/2021.
//

import Foundation

struct MessageMapper {
    static func toMessageDto(_ message: Message) -> MessageDto {
        return MessageDto(sender: message.sender, receiver: message.receiver, text: message.text)
    }
    
    static func toMessage(_ message: MessageDto) -> Message {
        return Message(sender: message.sender, receiver: message.receiver, text: message.text)
    }
}
