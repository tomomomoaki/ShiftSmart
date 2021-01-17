//
//  AddGroupViewController.swift
//  ShiftSmart
//
//  Created by 大島友陽 on 2021/01/15.
//

import UIKit
import Firebase

class AddGroupViewController: UIViewController {
    
    private var groups = [Group]()
    
    @IBOutlet weak var groupIdTextField: UITextField!
    @IBOutlet weak var searchGroupButton: UIButton!
    @IBOutlet weak var resultGroupNameLabel: UILabel!
    @IBOutlet weak var addGroupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultGroupNameLabel.isHidden = true
        addGroupButton.isHidden = true
        addGroupButton.layer.cornerRadius = 20
        
        groupIdTextField.delegate = self
    }
    
    @IBAction func tappedSearchGroupButton(_ sender: Any) {
        groups.removeAll()
        guard let groupId = groupIdTextField.text else { return }
        
        Firestore.firestore().collection("Groups").getDocuments { (snapshots, err) in
            if let err = err {
                print("グループ情報の検索に失敗しました\(err)")
                return
            }
            
            snapshots?.documents.forEach({ (Document) in
                let dic = Document.data()
                let group = Group.init(dic: dic)
                self.groups.append(group)
            })
            
            self.groups.forEach { (group) in
                if group.groupId == groupId {
                    self.resultGroupNameLabel.isHidden = false
                    self.resultGroupNameLabel.text = group.groupName
                    self.addGroupButton.isHidden = false
                }
            }
            if self.resultGroupNameLabel.isHidden {
                self.resultGroupNameLabel.isHidden = false
                self.resultGroupNameLabel.text = "お探しのグループは見当たりません"
            }
            
            
        }
    }
    
    @IBAction func tappedAddGroupButton(_ sender: Any) {
        
    }
}

extension AddGroupViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.resultGroupNameLabel.isHidden = true
        self.addGroupButton.isHidden = true
    }
}
