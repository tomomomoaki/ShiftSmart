//
//  DateInfomationViewController.swift
//  ShiftSmart
//
//  Created by 大島友陽 on 2021/01/04.
//

import UIKit
import Firebase

class GroupListViewController: UIViewController {
    
    private var user: User?
    
    @IBOutlet weak var groupListTableView: UITableView!
    @IBOutlet weak var addGroupBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupListTableView.delegate = self
        groupListTableView.dataSource = self
        
        confirmLoginUser()
        fetchUserInfoFromFirestore()
    }
    
    private func fetchUserInfoFromFirestore() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Users").document(uid).getDocument { (userSnapshot, err) in
            if let err = err {
                print("ユーザーの情報の取得に失敗しました\(err)")
                return
            }
            guard let dic = userSnapshot?.data() else { return }
            print("userSnapshot:", dic)
            //let user = User(dic: dic)
        }
    }
    
    @IBAction func tappedAddGroupBarButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddGroup", bundle: nil)
        let addGroupViewController = storyboard.instantiateViewController(withIdentifier: "AddGroupViewController") as! AddGroupViewController
        let nav = UINavigationController(rootViewController: addGroupViewController)
        self.present(nav, animated: true, completion: nil)
    }
    
    
    private func confirmLoginUser() {
        if Auth.auth().currentUser?.uid == nil{
            
            pushLoginViewController()
        }
    }
    
    private func pushLoginViewController() {
        let storyboard = UIStoryboard(name: "FirstScreen", bundle: nil)
        let firstScreenViewController = storyboard.instantiateViewController(withIdentifier: "FirstScreenViewController") as! FirstScreenViewController
        let nav = UINavigationController(rootViewController: firstScreenViewController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}

extension GroupListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}

class GroupListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var groupNameLabel: NSLayoutConstraint!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
