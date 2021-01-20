//
//  AddGroupViewController.swift
//  ShiftSmart
//
//  Created by 大島友陽 on 2021/01/15.
//

import UIKit
import Firebase

class AddGroupViewController: UIViewController {
    
    var group: Group?
    
    @IBOutlet weak var groupIdTextField: UITextField!
    @IBOutlet weak var searchGroupButton: UIButton!
    @IBOutlet weak var resultGroupNameLabel: UILabel!
    @IBOutlet weak var addGroupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultGroupNameLabel.isHidden = true
        addGroupButton.isHidden = true
        addGroupButton.layer.cornerRadius = 20
        
        searchGroupButton.isEnabled = false
        
        groupIdTextField.delegate = self
    }
    
    @IBAction func tappedSearchGroupButton(_ sender: Any) {
        
        guard let groupId = groupIdTextField.text else { return }
        
        Firestore.firestore().collection("Groups").document(groupId).getDocument { (groupSnapshot, err) in
            if let err = err {
                print("グループ情報の検索に失敗しました\(err)")
                return
            }
            
            guard let groupSnapshot = groupSnapshot, let dic = groupSnapshot.data() else {
                
                self.resultGroupNameLabel.isHidden = false
                self.resultGroupNameLabel.text = "お探しのグループは見当たりません"
                return
                
            }//wJMzO7K6Sa/5gn276vtH7

            let group = Group(dic: dic)
            self.group = group
            self.group?.documentId = groupId
            
            if self.group?.groupName != nil {
                
                self.resultGroupNameLabel.isHidden = false
                self.resultGroupNameLabel.text = group.groupName
                self.addGroupButton.isHidden = false
                
            }
        }
    }
    
    @IBAction func tappedAddGroupButton(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let groupId = self.group?.documentId else { return }
        
        var members = self.group?.members
        members?.append(uid)
        
        Firestore.firestore().collection("Groups").document(groupId).updateData(["members" : members as Any]) { (err) in
            if let err = err {
                print("group参加に失敗しました\(err)")
                return
            }
            print("group参加に成功しました")
            let nav = self.presentingViewController as! UINavigationController
            let groupListViewController = nav.viewControllers[nav.viewControllers.count-1] as? GroupListViewController
            groupListViewController?.fetchGroupsInfoFromFirestore()
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension AddGroupViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.resultGroupNameLabel.isHidden = true
        self.addGroupButton.isHidden = true
        
        if groupIdTextField.text?.count == 0 {
            searchGroupButton.isEnabled = false
        } else {
            searchGroupButton.isEnabled = true
        }
    }
}
