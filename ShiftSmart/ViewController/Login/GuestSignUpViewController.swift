//
//  GuestSignUpViewController.swift
//  ShiftSmart
//
//  Created by 大島友陽 on 2021/01/13.
//

import UIKit
import Firebase

class GuestSignUpViewController: UIViewController {

    @IBOutlet weak var guestImageButton: UIButton!
    @IBOutlet weak var guestUserNameTextField: UITextField!
    @IBOutlet weak var guestEmailTextField: UITextField!
    @IBOutlet weak var guestPasswordTextField: UITextField!
    @IBOutlet weak var guestRegisterButton: UIButton!
    @IBOutlet weak var alreadyHaveGuestAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guestImageButton.layer.cornerRadius = 85
        guestImageButton.layer.borderWidth = 1
        guestRegisterButton.layer.cornerRadius = 20
        
        guestUserNameTextField.delegate = self
        guestEmailTextField.delegate = self
        guestPasswordTextField.delegate = self
        
        guestRegisterButton.isEnabled = false
        guestRegisterButton.backgroundColor = .gray
        
    }

    @IBAction func tappedAlreadyHaveGuestAccountButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "GuestLogIn", bundle: nil)
        let guestLoginViewController = storyboard.instantiateViewController(withIdentifier: "GuestLogInViewController")
        self.navigationController?.pushViewController(guestLoginViewController, animated: true)
    }
    
    @IBAction func tappedGuestImageButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func tappedGuestRegisterButton(_ sender: Any) {
        guard let guestImage = guestImageButton.imageView?.image else { return }
        guard let uploadImage = guestImage.jpegData(compressionQuality: 0.3) else { return }
        
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("user_images").child(fileName)
        
        storageRef.putData(uploadImage, metadata: nil) { (metaData, err) in
            if let err = err {
                print("guest画像の保存に失敗しました\(err)")
                return
            }
            
            print("guest画像の保存に成功しました")
            storageRef.downloadURL { (url, err) in
                if let err = err {
                    print("Firestorageからのダウンロードに失敗しました\(err)")
                    return
                }
                
                guard let urlString = url?.absoluteString else { return }
                self.createGuestUserToFirestore(guestProfileImageUrl: urlString)
            }
        }
    }
    
    private func createGuestUserToFirestore(guestProfileImageUrl: String) {
        guard let email = guestEmailTextField.text else { return }
        guard let password = guestPasswordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("guest認証情報の登録に失敗しました\(err)")
                return
            }
            print("guest認証情報の登録に成功しました")
            
            guard let uid = res?.user.uid else { return }
            guard let userName = self.guestUserNameTextField.text else { return }
            
            let docData = [
                "email": email,
                "userName": userName,
                "createdAt": Timestamp(),
                "profileImageUrl": guestProfileImageUrl,
                "admin": false,
                "groups": []
            ] as [String : Any]
            
            Firestore.firestore().collection("Users").document(uid).setData(docData) {(err) in
                if let err = err {
                    print("guest情報の保存に失敗しました\(err)")
                    return
                }
                print("guest情報の保存に成功しました")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension GuestSignUpViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {

        let userNameIsEmpty = guestUserNameTextField.text?.isEmpty ?? false
        let emailIsEmpty = guestEmailTextField.text?.isEmpty ?? false
        let passwordIsEmpty = guestPasswordTextField.text?.isEmpty ?? false
        
        if userNameIsEmpty || emailIsEmpty || passwordIsEmpty {
            guestRegisterButton.isEnabled = false
            guestRegisterButton.backgroundColor = .gray
        } else {
            guestRegisterButton.isEnabled = true
            guestRegisterButton.backgroundColor = .blue
        }
    }
}


extension GuestSignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            guestImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            guestImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        guestImageButton.setTitle("", for: .normal)
        guestImageButton.imageView?.contentMode = .scaleAspectFill
        guestImageButton.contentHorizontalAlignment = .fill
        guestImageButton.contentVerticalAlignment = .fill
        guestImageButton.clipsToBounds = true
        
        dismiss(animated: true, completion: nil)
    }
}

