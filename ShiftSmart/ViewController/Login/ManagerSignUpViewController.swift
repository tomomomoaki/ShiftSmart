//
//  ManagerSignUpViewController.swift
//  ShiftSmart
//
//  Created by 大島友陽 on 2021/01/13.
//

import UIKit
import Firebase

class ManagerSignUpViewController: UIViewController {
    
    @IBOutlet weak var managerImageButton: UIButton!
    @IBOutlet weak var managerUserNameTextField: UITextField!
    @IBOutlet weak var managerGroupNameTextField: UITextField!
    @IBOutlet weak var managerEmailTextField: UITextField!
    @IBOutlet weak var managerPasswordTextField: UITextField!
    @IBOutlet weak var managerRegisterButton: UIButton!
    @IBOutlet weak var alreadyHaveManagerAccountButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managerImageButton.layer.cornerRadius = 85
        managerImageButton.layer.borderWidth = 1
        managerRegisterButton.layer.cornerRadius = 20
        
        managerUserNameTextField.delegate = self
        managerGroupNameTextField.delegate = self
        managerEmailTextField.delegate = self
        managerPasswordTextField.delegate = self
        
        managerRegisterButton.isEnabled = false
        managerRegisterButton.backgroundColor = .gray
        
    }
    
    @IBAction func tappedAlreadyHaveManagerAccountButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ManagerLogIn", bundle: nil)
        let managerLoginViewController = storyboard.instantiateViewController(withIdentifier: "ManagerLogInViewController")
        self.navigationController?.pushViewController(managerLoginViewController, animated: true)
    }
    
    @IBAction func tappedManagerImageButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func tappedManagerRegisterButton(_ sender: Any) {
        guard let managerImage = managerImageButton.imageView?.image else { return }
        guard let uploadImage = managerImage.jpegData(compressionQuality: 0.3) else { return }
        
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("user_images").child(fileName)
        
        storageRef.putData(uploadImage, metadata: nil) { (metaData, err) in
            if let err = err {
                print("manager画像の保存に失敗しました\(err)")
                return
            }
            
            print("manager画像の保存に成功しました")
            storageRef.downloadURL { (url, err) in
                if let err = err {
                    print("Firestorageからのダウンロードに失敗しました\(err)")
                    return
                }
                
                guard let urlString = url?.absoluteString else { return }
                self.createManagerUserToFirestore(managerProfileImageUrl: urlString)
            }
        }
    }
    
    private func createManagerUserToFirestore(managerProfileImageUrl: String) {
        guard let email = managerEmailTextField.text else { return }
        guard let password = managerPasswordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("manager認証情報の登録に失敗しました\(err)")
                return
            }
            print("manager認証情報の登録に成功しました")
            
            guard let uid = res?.user.uid else { return }
            guard let userName = self.managerUserNameTextField.text else { return }
            
            let docData = [
                "email": email,
                "userName": userName,
                "createdAt": Timestamp(),
                "profileImageUrl": managerProfileImageUrl,
                "admin": true
            ] as [String : Any]
            
            Firestore.firestore().collection("Users").document(uid).setData(docData) {(err) in
                if let err = err {
                    print("manager情報の保存に失敗しました\(err)")
                    return
                }
                print("manager情報の保存に成功しました")
                self.dismiss(animated: true, completion: nil)
                self.createGroupToFirestore(uid: uid)
            }
        }
    }
    
    private func createGroupToFirestore(uid: String) {
        guard let groupName = managerGroupNameTextField.text else { return }
        let members = [uid]
        let groupId = randomString(length: 10)
        
        let docData = [
            "groupName": groupName,
            "members": members,
            "createdAt": Timestamp()
        ] as [String : Any]
        
        Firestore.firestore().collection("Groups").document(groupId).setData(docData) {(err) in
            if let err = err {
                print("group情報の保存に失敗しました\(err)")
                return
            }
            print("group情報の保存に成功しました")
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


extension ManagerSignUpViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let userNameIsEmpty = managerUserNameTextField.text?.isEmpty ?? false
        let groupNameIsEmpty = managerGroupNameTextField.text?.isEmpty ?? false
        let emailIsEmpty = managerEmailTextField.text?.isEmpty ?? false
        let passwordIsEmpty = managerPasswordTextField.text?.isEmpty ?? false
        
        if userNameIsEmpty || groupNameIsEmpty || emailIsEmpty || passwordIsEmpty {
            managerRegisterButton.isEnabled = false
            managerRegisterButton.backgroundColor = .gray
        } else {
            managerRegisterButton.isEnabled = true
            managerRegisterButton.backgroundColor = .orange
        }
    }
}

extension ManagerSignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            managerImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            managerImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        managerImageButton.setTitle("", for: .normal)
        managerImageButton.imageView?.contentMode = .scaleAspectFill
        managerImageButton.contentHorizontalAlignment = .fill
        managerImageButton.contentVerticalAlignment = .fill
        managerImageButton.clipsToBounds = true
        
        dismiss(animated: true, completion: nil)
    }
}
