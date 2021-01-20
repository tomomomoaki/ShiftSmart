//
//  ManagerLogInViewController.swift
//  ShiftSmart
//
//  Created by 大島友陽 on 2021/01/13.
//

import UIKit
import Firebase

class ManagerLogInViewController: UIViewController {

    @IBOutlet weak var managerEmailTextField: UITextField!
    @IBOutlet weak var managerPasswordTextField: UITextField!
    @IBOutlet weak var managerLogInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        managerLogInButton.layer.cornerRadius = 20
    }

    @IBAction func tappedManagerLogInButton(_ sender: Any) {
        guard let email = managerEmailTextField.text else { return }
        guard let password = managerPasswordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("Managerログインに失敗しました\(err)")
                return
            }
            print("ログインに成功しました")
            let nav = self.presentingViewController as! UINavigationController
            let groupListViewController = nav.viewControllers[nav.viewControllers.count-1] as? GroupListViewController
            groupListViewController?.fetchGroupsInfoFromFirestore()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
