//
//  FirstScreenViewController.swift
//  ShiftSmart
//
//  Created by 大島友陽 on 2021/01/01.
//

import UIKit

class FirstScreenViewController: UIViewController {
    
    @IBOutlet weak var managerSignUpButton: UIButton!
    @IBOutlet weak var alreadyHaveManegerAccountButton: UIButton!
    @IBOutlet weak var guestSignUpButton: UIButton!
    @IBOutlet weak var alreadyHaveGuestAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managerSignUpButton.layer.cornerRadius = 20
        guestSignUpButton.layer.cornerRadius = 20
    }
    
    @IBAction func tappedManagerSignUpButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ManagerSignUp", bundle: nil)
        let managerSignUpViewController = storyboard.instantiateViewController(withIdentifier: "ManagerSignUpViewController") as! ManagerSignUpViewController
        self.navigationController?.pushViewController(managerSignUpViewController, animated: true)
    }
    
    @IBAction func tappedAlreadyHaveManagerAccountButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ManagerLogIn", bundle: nil)
        let managerLogInViewController = storyboard.instantiateViewController(identifier: "ManagerLogInViewController") as! ManagerLogInViewController
        self.navigationController?.pushViewController(managerLogInViewController, animated: true)
    }
    
    @IBAction func tappedGuestSignUpButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "GuestSignUp", bundle: nil)
        let guestSignUpViewController = storyboard.instantiateViewController(identifier: "GuestSignUpViewController") as! GuestSignUpViewController
        self.navigationController?.pushViewController(guestSignUpViewController, animated: true)
    }
    
    @IBAction func tappedAlreadyHaveGuestAccountButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "GuestLogIn", bundle: nil)
        let guestLogInViewController = storyboard.instantiateViewController(identifier: "GuestLogInViewController") as! GuestLogInViewController
        self.navigationController?.pushViewController(guestLogInViewController, animated: true)
    }
    
}
