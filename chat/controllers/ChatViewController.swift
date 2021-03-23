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
    var activeUser: User?
    var chatUser: User?
    
    @IBAction func handleSendBtn(_ sender: UIButton) {
        self.sendMessage()
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
        
        print(activeUser ?? "No active user", chatUser ?? "no chat user")
        
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
    func loadMessages() {
        
    }
    
    func sendMessage() {
        
    }
}
