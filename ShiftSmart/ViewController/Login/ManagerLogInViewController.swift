//
//  ManagerLogInViewController.swift
//  ShiftSmart
//
//  Created by 大島友陽 on 2021/01/13.
//

import UIKit

class ManagerLogInViewController: UIViewController {

    @IBOutlet weak var managerEmailTextField: UITextField!
    @IBOutlet weak var managerPasswordTextField: UITextField!
    @IBOutlet weak var managerLogInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        managerLogInButton.layer.cornerRadius = 20
    }

    
}
