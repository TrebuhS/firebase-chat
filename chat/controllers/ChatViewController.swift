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
        
        self.loadOldMessages()
        self.setListenerForNewMessages()
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
    }
    
    private func handleMessageLoading(documents: [DocumentSnapshot]) -> Void {
        do {
            try documents.forEach { document in
                print("asdf", document)
                let data = try document.data(as: MessageDto.self)
                if let message = data {
                    self.appendMessage(message: MessageMapper.toMessage(message))
                }
            }
            self.messageTableView.reloadData()
            self.messageTableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: UITableView.ScrollPosition.bottom, animated: false)
            print(self.messages)
        } catch let error {
            print(error)
        }
    }
    
    func loadOldMessages() -> Void {
        self.db.collection(Constants.Firebase.Collection.Messages.CollectionName)
            .whereField(Constants.Firebase.Collection.Messages.Fields.Receiver, in: [self.activeUser.email, self.chatUser.email])
            .order(by: Constants.Firebase.Collection.Messages.Fields.Date)
            .limit(toLast: 1)
            .getDocuments { (querySnapshot, error) in
            if error == nil {
                if let documents = querySnapshot?.documents {
                    self.handleMessageLoading(documents: documents)
                }
            }
        }
        _ = self.messages.popLast()
    }
    
    func setListenerForNewMessages() -> Void {
        self.db.collection(Constants.Firebase.Collection.Messages.CollectionName)
            .whereField(Constants.Firebase.Collection.Messages.Fields.Receiver, in: [self.activeUser.email, self.chatUser.email])
            .order(by: Constants.Firebase.Collection.Messages.Fields.Date)
            .limit(toLast: 10)
            .addSnapshotListener { documentSnapshot, error in
            if error == nil {
                if let documents = documentSnapshot?.documents {
                    self.handleMessageLoading(documents: documents)
                }
            }
        }
    }
    
    func sendMessage(text: String) -> Void {
        let message = MessageDto(sender: activeUser.email, receiver: chatUser.email, text: text, date: Timestamp())
        do {
            _ = try db.collection(Constants.Firebase.Collection.Messages.CollectionName).addDocument(from: message)
            self.appendMessage(message: MessageMapper.toMessage(message))
            self.messageTableView.reloadData()
        } catch let error {
            print("Error with message: ", error)
        }
    }
}
