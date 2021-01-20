//
//  GuestLogInViewController.swift
//  ShiftSmart
//
//  Created by 大島友陽 on 2021/01/13.
//

import UIKit
import Firebase

class GuestLogInViewController: UIViewController {

    @IBOutlet weak var guestEmailTextField: UITextField!
    @IBOutlet weak var guestPasswordTextField: UITextField!
    @IBOutlet weak var guestLogInButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guestLogInButton.layer.cornerRadius = 20
    }
    
    @IBAction func tappedGuestLogInButton(_ sender: Any) {
        guard let email = guestEmailTextField.text else { return }
        guard let password = guestPasswordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("guestログインに失敗しました\(err)")
                return
            }
            print("guestログインに成功しました")
            let nav = self.presentingViewController as! UINavigationController
            let groupListViewCintroller = nav.viewControllers[nav.viewControllers.count-1] as? GroupListViewController
            groupListViewCintroller?.fetchGroupsInfoFromFirestore()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
