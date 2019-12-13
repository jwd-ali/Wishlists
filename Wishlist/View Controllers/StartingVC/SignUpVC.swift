//
//  SignUpViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 22.08.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var errorLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButtton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var eyeButtonTwo: UIButton!
    @IBOutlet weak var eyeButtonOne: UIButton!
    @IBOutlet weak var passwortWiederholenTextField: UITextField!
    
    var email = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //custom spacing in stackview for errorLabel
        stackView.setCustomSpacing(15, after: signUpButtton)
        
        //Auge Button Standart auf offen setzen
        eyeButtonOne.setImage(UIImage(named: "eyeOpen"), for: .normal)
        eyeButtonTwo.setImage(UIImage(named: "eyeOpen"), for: .normal)
        self.eyeButtonOne.isHidden = true
        self.eyeButtonTwo.isHidden = true
        
        //password hide/show
        passwordTextField.isSecureTextEntry.toggle()
        
        //password hide/show
        passwordTextField.isSecureTextEntry.toggle()
        
        //change return key
        firstNameTextField.returnKeyType = .next
        lastNameTextField.returnKeyType = .next
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .next
        passwortWiederholenTextField.returnKeyType = .done
        
        passwordTextField.textContentType = .newPassword
        passwortWiederholenTextField.textContentType = .newPassword

        
        
        UIView.animate(withDuration: 0.20) {
            self.view.layoutIfNeeded()
        }
        
        
        //prefill emailTextfield with previous email
        self.emailTextField.text = email
        
        //Textfield cursor -> white
        UITextField.appearance().tintColor = .white
        
        //hide error label
        errorLabel.alpha = 0
        
        //clear button
        firstNameTextField.clearButtonMode = .always
        lastNameTextField.clearButtonMode = .always
        emailTextField.clearButtonMode = .always

        
        //listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    //stop listening for keyboard hide/show events
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }


    // Check the fields and validate that the data is correct. If everything is corrct, this method return nil. Otherwise, it return the error-message as a string.
    func validateFields() ->String? {
        
        //check if all fields are filled
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwortWiederholenTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        //check if both passwords are the same
        if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) !=
            passwortWiederholenTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            
            return "The passwords do not match."
        }
        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            //dismiss keyboard
            view.endEditing(true)
            
            //there is sth wrong with the fields, show error message
            showError(error!)
        }else {
            
            //create cleaned versione of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                //check for errors
                if let err = err {
                    self.view.endEditing(true)
                    self.showError(err.localizedDescription)
                    
                }else {
                    
                    //user was created successfully; store first and last name
                    let db = Firestore.firestore()
                    
                    let userID = result!.user.uid
                    
                    db.collection("users").document(userID).setData(["firstname":firstName, "lastname": lastName, "uid": result!.user.uid]) { (error) in
                        if error != nil {
                            self.showError("Error saving user data")
                        }
                    }
                    
                    db.collection("users").document(userID).collection("wishlists").document("Main Wishlist").setData(["name": "Main Wishlist"]) { (error) in
                        if error != nil {
                            self.showError("Error creating Main Wishlist")
                        }
                    }
                    
                    
                    //transition to home
                    self.transitionToHome()
                }
            
            }
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        view.endEditing(true)
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "StartVC") as! ViewController
        
        self.navigationController?.pushViewController(VC, animated: false)
    }
    
    
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    
    }
    
    func transitionToHome () {

    let homeViewCotnroller =
    storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? ExampleViewController
    let navigationController = UINavigationController(rootViewController: homeViewCotnroller!)

    view.window?.rootViewController = navigationController
    view.window?.makeKeyAndVisible()
    }
    
    //hide keyboard, wenn user außerhalb toucht
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    //automatisch Fokus auf nächstes Textfield setzen, wenn User auf "return" klickt
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        }else if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
        }else if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField {
            passwortWiederholenTextField.becomeFirstResponder()
        }else if textField == passwortWiederholenTextField {
            passwortWiederholenTextField.resignFirstResponder()
            self.signUpButtton.sendActions(for: .touchUpInside)
        }
        
        return true
    }
    
    
    //move UI if Keyboard shows/hides
    @objc func keyboardWillChange(notification: Notification) {
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            
            // Keyboard shows
             
                self.view.layoutIfNeeded()
                self.stackViewConstraint.constant = 50
                self.backButton.alpha = 1
                
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            
            
        }else {
            
            // Keyboard hides
            self.stackViewConstraint.constant = 79
            self.backButton.alpha = 1
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    //delegate Methode für eye-Button
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case passwordTextField:
            if passwordTextField.text != "" {
                eyeButtonOne.isHidden = false
            } else {
                eyeButtonOne.isHidden = false
            }

            break
        default:
            break
        }
        if textField == passwortWiederholenTextField {
            eyeButtonTwo.isHidden = false
        }
        return true
    }
    //delegate Methode für eye-Button
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {

        if textField == passwordTextField {
            if passwordTextField.text != "" {
                eyeButtonOne.isHidden = false
            } else {
                eyeButtonOne.isHidden = false
            }
        }
        if textField == passwortWiederholenTextField {
            eyeButtonTwo.isHidden = false
        }
        return true
    }
    
    var check = true
    @IBAction func eyeButtonOneTapped(_ sender: Any) {
        check = !check
        
        if check == true {
            eyeButtonOne.setImage(UIImage(named: "eyeOpen"), for: .normal)
        } else {
            eyeButtonOne.setImage(UIImage(named: "eyeClosed"), for: .normal)
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
    
    
    var check2 = true
    @IBAction func eyeButtonTwoTapped(_ sender: Any) {
        check2 = !check2
        
        if check2 == true {
            eyeButtonTwo.setImage(UIImage(named: "eyeOpen"), for: .normal)
        } else {
            eyeButtonTwo.setImage(UIImage(named: "eyeClosed"), for: .normal)
        }
        passwortWiederholenTextField.isSecureTextEntry.toggle()


            if let existingText = passwortWiederholenTextField.text, passwortWiederholenTextField.isSecureTextEntry {
                /* When toggling to secure text, all text will be purged if the user
                 continues typing unless we intervene. This is prevented by first
                 deleting the existing text and then recovering the original text. */
                passwortWiederholenTextField.deleteBackward()

                if let textRange = passwortWiederholenTextField.textRange(from: passwortWiederholenTextField.beginningOfDocument, to: passwortWiederholenTextField.endOfDocument) {
                    passwortWiederholenTextField.replace(textRange, withText: existingText)
                }
            }
        
        
        
            /* Reset the selected text range since the cursor can end up in the wrong
             position after a toggle because the text might vary in width */
            if let existingSelectedTextRange = passwortWiederholenTextField.selectedTextRange {
                passwortWiederholenTextField.selectedTextRange = nil
                passwortWiederholenTextField.selectedTextRange = existingSelectedTextRange
            }
    }
}
