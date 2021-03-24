//
//  ChatViewController.swift
//  chat
//
//  Created by Hubert Sośnicki on 19/01/2021.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    var messages: [Message] = []
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    var activeUser: User!
    var chatUser: User!
    
    let db = FirestoreDb.get()
    
    @IBAction func handleSendBtn(_ sender: UIButton) {
        if let messageText = self.messageTextField.text {
            self.sendMessage(text: messageText)
            self.messageTextField.text = ""
        }
    }
    
    @IBAction func handleLogoutButton(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let err as NSError {
            print("Error when signing out: %@", err)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageTextField.layer.cornerRadius = self.messageTextField.frame.height / 2
        self.messageTextField.layer.masksToBounds = true
        self.messageTextField.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        self.messageTextField.layer.borderWidth = 2
        
        messageTableView.dataSource = self
        messageTableView.register(UINib(nibName: Constants.Identifiers.MessageCell, bundle: nil), forCellReuseIdentifier: Constants.Identifiers.MessageCell)
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.messageTableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.MessageCell, for: indexPath) as! MessageCell
        cell.messageLabel.text = self.messages[indexPath.row].text
        return cell
    }
}

extension ChatViewController {
    private func appendMessage(message: Message) -> Void {
        messages.append(message)
        self.messageTableView.reloadData()
    }
    
    private func handleMessageLoading(documents: [DocumentSnapshot]) -> Void {
        do {
            try documents.forEach { document in
                let data = try document.data(as: MessageDto.self)
                if let message = data {
                    if message.receiver == self.activeUser.email {
                        self.appendMessage(message: MessageMapper.toMessage(message))
                    }
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    func loadMessages() -> Void {
        do {
            try db.collection(Constants.Firebase.Collection.messages).addSnapshotListener { documentSnapshot, error in
                if let err = error {
                    return
                } else {
                    if let documents = documentSnapshot?.documents {
                        self.handleMessageLoading(documents: documents)
                    }
                }
            }
        } catch {
            print ("Error when loading new messages.")
        }
    }
    
    func sendMessage(text: String) -> Void {
        let message = MessageDto(sender: activeUser.email, receiver: chatUser.email, text: text)
        do {
            try db.collection(Constants.Firebase.Collection.messages).addDocument(from: message) { error in
                if let err = error {
                    print("Error", err)
                } else {
                    self.appendMessage(message: MessageMapper.toMessage(message))
                }
            }
        } catch let error {
            print("Error with message: ", error)
        }
        
    }
}
