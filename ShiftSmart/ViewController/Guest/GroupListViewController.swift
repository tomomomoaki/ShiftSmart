//
//  DateInfomationViewController.swift
//  ShiftSmart
//
//  Created by 大島友陽 on 2021/01/04.
//

import UIKit
import Firebase

class GroupListViewController: UIViewController {
    
    private var groups = [Group]()
    private var user: User? {
        didSet {
            navigationItem.title = user?.userName
        }
    }
    private var groupListner: ListenerRegistration?
    
    @IBOutlet weak var groupListTableView: UITableView!
    @IBOutlet weak var addGroupBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupListTableView.delegate = self
        groupListTableView.dataSource = self
        
        confirmLoginUser()
        fetchGroupsInfoFromFirestore()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchLogInUserInfo()
    }
    
    func fetchGroupsInfoFromFirestore() {
        groupListner?.remove()
        groups.removeAll()
        groupListTableView.reloadData()
        
        groupListner = Firestore.firestore().collection("Groups")
            .addSnapshotListener { (snapshots, err) in
                
                if let err = err {
                    print("groupの情報の取得に失敗しました\(err)")
                    return
                }
                snapshots?.documentChanges.forEach({ (documentChange) in
                    switch documentChange.type {
                    case .added:
                        self.handleAddedDocumentChange(documentChange: documentChange)
                    case .modified, .removed:
                        print("nothing to do")
                    }
                })
        }
    }
    
    private func handleAddedDocumentChange(documentChange: DocumentChange) {
        let dic = documentChange.document.data()
        let group = Group(dic: dic)
        group.documentId = documentChange.document.documentID
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let isContain = group.members.contains(uid)
        
        if !isContain { return }
        
        self.groups.append(group)
        self.groupListTableView.reloadData()
        
    }
    
    private func fetchLogInUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Users").document(uid).getDocument { (userSnapshot, err) in
            if let err = err {
                print("ユーザーの情報の取得に失敗しました\(err)")
                return
            }
            guard let userSnapshot = userSnapshot, let dic = userSnapshot.data() else { return }
            let user = User(dic: dic)
            self.user = user
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
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupListTableViewCell
        cell.group = groups[indexPath.row]
        return cell
    }
}

class GroupListTableViewCell: UITableViewCell {
    
    var group: Group? {
        didSet {
            if let group = group {
                
                groupNameLabel.text = group.groupName
                
            }
    
        }
    }
    
    @IBOutlet weak var groupNameLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
