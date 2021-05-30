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
        
        setupKeyboardObservers()
        setupMessageTextField()
        setupMessageTableView()
        
        loadOldMessages()
        setListenerForNewMessages()
    }
    
    deinit {
        removeKeyboardObservers()
    }
    
    @objc func keyboardDidChange(notification: Notification) {
        if notification.name == UIResponder.keyboardDidChangeFrameNotification
            || notification.name == UIResponder.keyboardDidShowNotification {
            guard let keyboardSize = getKeyboardSize(notification: notification) else {return}
            self.view.frame.origin.y = -keyboardSize.height
        } else {
            view.frame.origin.y = 0
        }
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    private func setupMessageTextField() {
        messageTextField.layer.cornerRadius = messageTextField.frame.height / 2
        messageTextField.layer.masksToBounds = true
        messageTextField.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        messageTextField.layer.borderWidth = 2
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    private func setupMessageTableView() {
        messageTableView.dataSource = self
        messageTableView.keyboardDismissMode = .onDrag
        messageTableView.separatorStyle = .none
        messageTableView.register(UINib(nibName: Constants.Identifiers.MessageCell, bundle: nil), forCellReuseIdentifier: Constants.Identifiers.MessageCell)
        
        messageTableView.estimatedRowHeight = 70
        messageTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func getKeyboardSize(notification: Notification) -> CGRect? {
        guard let userInfo = notification.userInfo else {return CGRect()}
        guard let keyboardSize = userInfo["UIKeyboardFrameEndUserInfoKey"] as? NSValue else {return CGRect()}
        return keyboardSize.cgRectValue
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.messageTableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.MessageCell, for: indexPath) as! MessageCell
        let message = self.messages[indexPath.row]
        cell.messageLabel.text = message.text
        if activeUser.email == message.sender {
            cell.chatUserAvatarBox.isHidden = true
            cell.activeUserAvatarBox.isHidden = false
            cell.messageBox.backgroundColor = .lightGray
            cell.activeUserAvatarLabel.text = String(message.sender.prefix(2))
        } else {
            cell.activeUserAvatarBox.isHidden = true
            cell.chatUserAvatarBox.isHidden = false
            cell.messageBox.backgroundColor = .yellow
            cell.chatUserAvatarLabel.text = String(message.sender.prefix(2))
        }
        return cell
    }
}

extension ChatViewController {
    func loadOldMessages() {
        self.db.collection(Constants.Firebase.Collection.Messages.CollectionName)
            .whereField(Constants.Firebase.Collection.Messages.Fields.Receiver, in: [self.activeUser.email, self.chatUser.email])
            .order(by: Constants.Firebase.Collection.Messages.Fields.Date)
            .limit(toLast: 10)
            .getDocuments { (querySnapshot, error) in
            if error == nil {
                if let documents = querySnapshot?.documents {
                    if self.messages.count > 0 {
                        self.messages.remove(at: 0)
                    }
                    self.handleMessageLoading(documents: documents)
                }
            }
        }
    }
    
    func setListenerForNewMessages() {
        self.db.collection(Constants.Firebase.Collection.Messages.CollectionName)
            .whereField(Constants.Firebase.Collection.Messages.Fields.Receiver, in: [self.activeUser.email, self.chatUser.email])
            .order(by: Constants.Firebase.Collection.Messages.Fields.Date)
            .limit(toLast: 1)
            .addSnapshotListener { documentSnapshot, error in
            if error == nil {
                if let documents = documentSnapshot?.documents {
                    self.handleMessageLoading(documents: documents)
                }
            }
        }
    }
    
    func sendMessage(text: String) {
        if !text.isEmpty {
            let message = MessageDto(sender: activeUser.email, receiver: chatUser.email, text: text, date: Timestamp())
            do {
                _ = try db.collection(Constants.Firebase.Collection.Messages.CollectionName).addDocument(from: message)
            } catch let error {
                print("Error with message: ", error)
            }
        }
    }
    
    private func appendMessage(message: Message) {
        messages.append(message)
    }
    
    private func handleMessageLoading(documents: [DocumentSnapshot]) {
        do {
            try documents.forEach { document in
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
}
