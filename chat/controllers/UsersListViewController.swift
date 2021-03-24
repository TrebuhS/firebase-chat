//
//  UsersListViewController.swift
//  chat
//
//  Created by Hubert Sośnicki on 22/02/2021.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class UsersListViewController: UIViewController {
    @IBOutlet weak var userTableView: UITableView!
    var users: [User] = []
    var selectedUser: User?
    var activeUser: User?
    
    let db = FirestoreDb.get()
    
    private func logout() {
        self.performSegue(withIdentifier: Constants.Segues.UsersListToStart, sender: self)
    }
    
    @IBAction func handleLogout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            logout()
        } catch {
            print("Error when singing out.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentUser = Auth.auth().currentUser {
            self.activeUser = User(email: currentUser.email!)
        } else {
            logout()
        }
        userTableView.dataSource = self
        userTableView.register(UINib(nibName: Constants.Identifiers.UserCell, bundle: nil), forCellReuseIdentifier: Constants.Identifiers.UserCell)
        
        
        navigationItem.hidesBackButton = true
        navigationItem.title = "Users"
        
        getUsers()
    }
    
    private func getUsers() {
        db.collection("users")
            .whereField("email", isNotEqualTo: activeUser?.email ?? "")
            .getDocuments(completion: {(collection, error) in
                
                let result = Result {
                    try collection?.documents.forEach {(queryDocumentSnapshot) in
                        let user = try queryDocumentSnapshot.data(as: UserItemDto.self)
                        if let user = user {
                            self.users.append(User(email: user.email))
                        }
                    }
                }
                
                switch result {
                case .success(_):
                    if self.users.count > 0 {
                        self.userTableView.reloadData()
                    } else {
                        print("no users")
                    }
                case .failure(_):
                    print("no users found")
                }
            })
    }
}

extension UsersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.UserCell, for: indexPath) as! UserCell
        cell.delegate = self
        cell.userEmailLabel.text = self.users[indexPath.row].email
        return cell
    }
}

extension UsersListViewController: UserCellProtocol {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ChatViewController {
            let vc = segue.destination as? ChatViewController
            vc?.activeUser = self.activeUser
            vc?.chatUser = self.selectedUser
        }
    }
    
    func handleUserSelection(user: User?) {
        self.selectedUser = user
        self.performSegue(withIdentifier: Constants.Segues.UsersListToChat, sender: self)
    }
}
