//
//  ViewController.swift
//  chat
//
//  Created by Hubert Sośnicki on 19/01/2021.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {
    @IBOutlet weak var regitsterButton: UIButton!
    @IBOutlet weak var logoLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoLabel.text = "🔒Personal chat🔓"
        navigationItem.hidesBackButton = true
    }

}

