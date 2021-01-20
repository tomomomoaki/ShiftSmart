//
//  MemberListViewController.swift
//  ShiftSmart
//
//  Created by 大島友陽 on 2021/01/19.
//

import UIKit

class MemberListViewController: UIViewController {
    
    var group: Group?
    
    @IBOutlet weak var memberListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memberListTableView.delegate = self
        memberListTableView.dataSource = self
    }
}

extension MemberListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.group?.members.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MemberListTableViewCell
        //cell.group = groups[indexPath.row]
        return cell
    }
    
}

class MemberListTableViewCell: UITableViewCell {
    
    var group: Group? {
        didSet {
            if let group = group {
                
                memberNameLabel.text = group.groupName
                
            }
    
        }
    }
    
    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var shiftSubmission: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
