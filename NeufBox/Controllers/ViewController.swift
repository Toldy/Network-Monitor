//
//  ViewController.swift
//  NeufBox
//
//  Created by Julien Colin on 03/10/16.
//  Copyright © 2016 Julien Colin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func connect(_ sender: UIButton) {
        APIController.authenticate(login: self.loginTextField.text!, password: passwordTextField.text!) { error in
            // @TODO: Handle error
            self.performSegue(withIdentifier: "showHomeSegue", sender: nil)
        }
    }
}
