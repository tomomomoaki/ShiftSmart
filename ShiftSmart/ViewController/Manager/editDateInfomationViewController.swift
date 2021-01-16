//
//  editDateInfomationViewController.swift
//  ShiftSmart
//
//  Created by 大島友陽 on 2021/01/04.
//

import UIKit
import Firebase
import FirebaseFirestore

class editDateInfomationViewController: UIViewController, UITextFieldDelegate {
    
    var date: String?
    private var events = [Event]()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var memberNameTextField: UITextField!
    @IBOutlet weak var createShiftButton: UIButton!
    @IBOutlet weak var startTimeDatePicker: UIDatePicker!
    @IBOutlet weak var finishTimeDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.text = date
        startTimeDatePicker.date = Date()
        
        createShiftButton.layer.cornerRadius = 10
        
    }
    
    func format(date:Date)->String{
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
        let strDate = dateformatter.string(from: date)
        
        return strDate
    }
    
    @IBAction func pushAddEventButton(_ sender: Any) {
        addEventToFirestore()
    }
    
    private func addEventToFirestore() {
        guard let memberName = memberNameTextField.text else { return }
        let date = dateLabel.text ?? ""
        
        let docData = [
            "memberName": memberName,
            "startTime": self.format(date: startTimeDatePicker.date),
            "finishTime": self.format(date: finishTimeDatePicker.date),
            "createdAt": Timestamp()
        ] as [String: Any]
        
        Firestore.firestore().collection("Events").document(date).collection("shifts").document().setData(docData) { (err) in
            if let err = err {
                print("event情報の保存に失敗しました\(err)")
                return
            }
            self.dismiss(animated: true, completion: nil)
            print("eventの保存に成功しました")
        }
        
    }
    
    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
        
    }
}
