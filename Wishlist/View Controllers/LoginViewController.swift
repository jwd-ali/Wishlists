//
//  LoginViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 22.08.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    


    @IBOutlet weak var eyeButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var eyeOpenButton: UIButton!
    @IBOutlet weak var stackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    var email = ""
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UIView.animate(withDuration: 0.20) {
            self.view.layoutIfNeeded()
        }
        
        self.passwordTextField.rightPadding = 15
        
        //Auge Button Standart auf offen setzen
        eyeOpenButton.setImage(UIImage(named: "eyeOpen"), for: .normal)

        
        passwordTextField.delegate = self
        
        //change return key
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .done
        
        //eye button verstecken
        self.eyeOpenButton.isHidden = true
        
        //passwort vergessen button erstellen
        createForgetButton()
        
        //pass email
        self.emailTextField.text = email
        
        //hide error
        errorLabel.alpha = 0
        
        //clear button
        emailTextField.clearButtonMode = .always
        
        //password hide/show
        passwordTextField.isSecureTextEntry.toggle()
        
        //Textfield cursor -> white
        UITextField.appearance().tintColor = .white
        
        //listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    }
    

    
    //delegate Methode für eye-Button
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case passwordTextField:
            if passwordTextField.text != "" {
                eyeOpenButton.isHidden = false
            } else {
                eyeOpenButton.isHidden = true
            }
            
            break
        default:
            break
        }
        return true
    }
    //delegate Methode für eye-Button
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField == passwordTextField {
            if passwordTextField.text != "" {
                eyeOpenButton.isHidden = true
            } else {
                eyeOpenButton.isHidden = true
            }
        }
        return true
    }

    //"vergessen"-Button hinzufügen
    func createForgetButton () {
        let button = UIButton(type: .system)
        button.setTitle("Vergessen?", for: .normal)
        button.addTarget(self, action: #selector(self.vergessenTapped(_:)), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Avenir Next", size: 19.0)
        passwordTextField.rightView = button
        passwordTextField.rightViewMode = .unlessEditing
        
    }
    
    @objc func vergessenTapped(_ sender: Any) {
        
    }
    

    
    //stop listening for keyboard hide/show events
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    

    @IBAction func loginButtonTapped(_ sender: Any) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        

        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }else {
                
                self.transitionToHome()
            }
        }
        
    }
    
    func transitionToHome () {
        
        let homeViewCotnroller =
            storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? ExampleViewController
        
        view.window?.rootViewController = homeViewCotnroller
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        view.endEditing(true)
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "StartVC") as! ViewController
        
        self.navigationController?.pushViewController(VC, animated: false)
    }
    
    //hide keyboard, wenn user außerhalb toucht
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
//    //automatischer Fokus auf nächstes Textfield
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        if textField == emailTextField {
//            passwordTextField.becomeFirstResponder()
//        }else if textField == passwordTextField {
//            textField.resignFirstResponder()
//            self.loginButton.sendActions(for: .touchUpInside)
//        }
//
//        return true
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        for textField in self.view.subviews where textField is UITextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    //move UI if Keyboard shows/hides
    @objc func keyboardWillChange(notification: Notification) {
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            
            // Keyboard shows
            
            self.view.layoutIfNeeded()
            self.eyeButtonConstraint.constant = 224+75
            self.stackViewConstraint.constant = 175
            self.backButton.alpha = 1
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
            
        }else {
            // Keyboard hides
            self.eyeButtonConstraint.constant = 224
            self.stackViewConstraint.constant = 100
            self.backButton.alpha = 1
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    var check = true
    @IBAction func eyeOpenButtonTapped(_ sender: Any) {
        check = !check
        
        if check == true {
            eyeOpenButton.setImage(UIImage(named: "eyeOpen"), for: .normal)
        } else {
            eyeOpenButton.setImage(UIImage(named: "eyeClosed"), for: .normal)
        }
        passwordTextField.isSecureTextEntry.toggle()


            if let existingText = passwordTextField.text, passwordTextField.isSecureTextEntry {
                /* When toggling to secure text, all text will be purged if the user
                 continues typing unless we intervene. This is prevented by first
                 deleting the existing text and then recovering the original text. */
                passwordTextField.deleteBackward()

                if let textRange = passwordTextField.textRange(from: passwordTextField.beginningOfDocument, to: passwordTextField.endOfDocument) {
                    passwordTextField.replace(textRange, withText: existingText)
                }
            }
        
        
        
            /* Reset the selected text range since the cursor can end up in the wrong
             position after a toggle because the text might vary in width */
            if let existingSelectedTextRange = passwordTextField.selectedTextRange {
                passwordTextField.selectedTextRange = nil
                passwordTextField.selectedTextRange = existingSelectedTextRange
            }
    }
    
    @IBAction func passwordDidChange(_ sender: Any) {
        if self.passwordTextField.text == "" {
            self.eyeOpenButton.isHidden = true
        }else {
            self.eyeOpenButton.isHidden = false
        }
    }
}
