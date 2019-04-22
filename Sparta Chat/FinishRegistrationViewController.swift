//
//  FinishRegistrationViewController.swift
//  Sparta Chat
//
//  Created by AbdelRahman Aref on 4/21/19.
//  Copyright © 2019 AbdelRahman Aref. All rights reserved.
//

import UIKit
import ProgressHUD

class FinishRegistrationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!

    var email : String!
    var password: String!
    var avatarImage : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(email, password)
    }
    
    //MARK: IBAction

    @IBAction func cancelButtonPressed(_ sender: Any) {
        cleanTextFields()
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)

    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        dismissKeyboard()
        ProgressHUD.show("Registering...")

        if nameTextField.text != "" && surnameTextField.text != "" && countryTextField.text != "" && cityTextField.text != "" && phoneTextField.text != "" {
            FUser.registerUserWith(email: email!, password: password!, firstName: nameTextField.text!, lastName: surnameTextField.text!) { (error) in
                if error != nil {
                    ProgressHUD.dismiss()
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                self.registerUser()
            }
        }else {
            ProgressHUD.showError("All fields are required")
        }

    }


    //MARK: Helper

    func registerUser(){
        let fullName = nameTextField.text! + " " + surnameTextField.text!
        var tempDicitionary : Dictionary = [kFIRSTNAME: nameTextField.text!, kLASTNAME: surnameTextField.text!, kFULLNAME: fullName, kCOUNTRY: countryTextField.text!, kCITY: cityTextField.text!, kPHONE: phoneTextField.text!] as [String: Any]

        if avatarImage == nil {
            imageFromInitials(firstName: nameTextField.text!, lastName: surnameTextField.text!) { (avatarInitials) in
                let avatarIMG = avatarInitials.jpegData(compressionQuality: 0.5)
                let avatar = avatarIMG!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                tempDicitionary[kAVATAR] = avatar

                self.finishRegisteration(withValues: tempDicitionary)
            }
        }else {
            let avatarData = avatarImage?.jpegData(compressionQuality: 0.5)
            let avatar = avatarData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            tempDicitionary[kAVATAR] = avatar

            self.finishRegisteration(withValues: tempDicitionary)
        }
    }

    func finishRegisteration(withValues: [String: Any]){
        updateCurrentUserInFirestore(withValues: withValues) { (error) in
            if error != nil {
                DispatchQueue.main.async {
                    ProgressHUD.showError(error?.localizedDescription)
                }
                return
            }

            ProgressHUD.dismiss()
            //go to the app
            self.goToApp()
        }
    }

    func goToApp(){
        cleanTextFields()
        dismissKeyboard()

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kUSERID : FUser.currentId()])

        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
        self.present(mainView, animated: true, completion: nil)

    }
    func dismissKeyboard(){
        self.view.endEditing(false)
    }
    func cleanTextFields(){
        nameTextField.text = ""
        surnameTextField.text = ""
        countryTextField.text = ""
        cityTextField.text = ""
        phoneTextField.text = ""
    }
}

