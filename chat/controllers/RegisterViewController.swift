//
//  RegisterViewController.swift
//  chat
//
//  Created by Hubert Sośnicki on 19/01/2021.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let db = FirestoreDb.get()
    var activeUser: User?
    
    @IBAction func handleRegisterButton(_ sender: Any) {
        if let email = self.emailTextField.text, let password = self.passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let err = error {
                    print(err)
                } else {
                    self.handleCompletedUserCreation(for: email)
                }
            }
        }
    }
    
    private func handleCompletedUserCreation(for email: String) {
        self.db
            .collection(Constants.Firebase.Collection.users)
            .addDocument(data: [
                "email": email
            ]) { error in
                if let err = error {
                    print(err)
                } else {
                    self.activeUser = User(email: email)
                    self.performSegue(withIdentifier: Constants.Segues.RegisterToUsersList, sender: self)
                }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
