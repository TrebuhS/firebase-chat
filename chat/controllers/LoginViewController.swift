//
//  LoginViewController.swift
//  chat
//
//  Created by Hubert Sośnicki on 19/01/2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: AuthorizeTextField!
    @IBOutlet weak var passwordTextField: AuthorizeTextField!
    
    var activeUser: User?
    
    @IBAction func handleLoginButton(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                if let err = error {
                    print(err)
                } else {
                    self.activeUser = User(email: email)
                    self.performSegue(withIdentifier: Constants.Segues.LoginToUsersList, sender: self)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
