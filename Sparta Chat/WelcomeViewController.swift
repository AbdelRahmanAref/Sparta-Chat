//
//  WelcomeViewController.swift
//  Sparta Chat
//
//  Created by AbdelRahman Aref on 4/21/19.
//  Copyright © 2019 AbdelRahman Aref. All rights reserved.
//

import UIKit
import ProgressHUD

class WelcomeViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK:-  IBActions

    @IBAction func loginButtonPressed(_ sender: Any) {
        dismissKeyboard()
        if emailTextField.text != "" && passwordTextField.text != ""{
            loginUser()
        }else{
            ProgressHUD.showError("email or password is missing!")
        }
    }

    @IBAction func registerButtonPressed(_ sender: Any) {
        dismissKeyboard()
        if emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != "" {
            if passwordTextField.text! == repeatPasswordTextField.text! {
                registerUser()
            } else {
                ProgressHUD.showError("password don't match!")
            }

        }else{
            ProgressHUD.showError("All fields are required!")
        }
    }

    @IBAction func backgroundTap(_ sender: Any) {
        dismissKeyboard()
    }

    //MARK:- Helper functions

    func loginUser(){
        print("login")
        ProgressHUD.show("Login..")
        FUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in

            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
                return
            }

            //present the app
            self.gotoApp()
        }

    }
    func registerUser(){
        print("register")
        // perform segue with identifier
        performSegue(withIdentifier: "welcomeToFinishRegistration", sender: self)

        cleanTextFields()
        dismissKeyboard()



    }
    func dismissKeyboard(){
        self.view.endEditing(false)
    }
    func cleanTextFields(){
        emailTextField.text = ""
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
    }

    //MARK: Go to App
    func gotoApp(){
        ProgressHUD.dismiss()
        cleanTextFields()
        dismissKeyboard()

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kUSERID : FUser.currentId()])

        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
        self.present(mainView, animated: true, completion: nil)
        
        print("show the app")
        //present the app

    }

    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "welcomeToFinishRegistration" {
            let vc = segue.destination as! FinishRegistrationViewController
            vc.email = emailTextField.text!
            vc.password = passwordTextField.text!
//            vc.avatarImage
        }
    }




}
