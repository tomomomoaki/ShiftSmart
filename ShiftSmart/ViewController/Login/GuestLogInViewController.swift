//
//  GuestLogInViewController.swift
//  ShiftSmart
//
//  Created by 大島友陽 on 2021/01/13.
//

import UIKit

class GuestLogInViewController: UIViewController {

    @IBOutlet weak var guestEmailTextField: UITextField!
    @IBOutlet weak var guestPasswordTextField: UITextField!
    @IBOutlet weak var guestLogInButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guestLogInButton.layer.cornerRadius = 20
    }
    
    
}
