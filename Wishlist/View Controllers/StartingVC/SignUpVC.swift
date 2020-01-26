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
import TransitionButton


class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .cyan
        return v
    }()
    
    let backgroundImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "backgroundImage")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = false
        return v
    }()
    
    let emailTextField: CustomTextField = {
        let v = CustomTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Email-Adresse"
        v.placeholderColor = .gray
        v.placeholderFontScale = 1
        v.clearButtonMode = .always
        v.minimumFontSize = 13
        v.borderStyle = .line
        v.autocapitalizationType = .none
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    let wishlistHandleTextField: CustomTextField = {
//        let handleLeftView: UILabel = {
//            let v = UILabel()
//            v.text = "@"
//            v.font = UIFont(name: "AvenirNext-Regular", size: 17)
//            v.translatesAutoresizingMaskIntoConstraints = false
//            return v
//        }()
        let v = CustomTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Wishlist-Handle"
        v.placeholderColor = .gray
        v.placeholderFontScale = 1
        v.clearButtonMode = .always
        v.minimumFontSize = 13
        v.borderStyle = .line
        v.autocapitalizationType = .none
        v.translatesAutoresizingMaskIntoConstraints = false
//        v.leftView = handleLeftView
//        v.leftViewMode = .always
        return v
    }()
    
    let anzeigeNameTextField: CustomTextField = {
        let v = CustomTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Anzeigename: z.B. dein Vorname"
        v.placeholderColor = .gray
        v.placeholderFontScale = 1
        v.clearButtonMode = .always
        v.minimumFontSize = 13
        v.borderStyle = .line
        v.autocapitalizationType = .none
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    
    let passwordTextField: CustomTextField = {
        let v = CustomTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Passwort"
        v.placeholderColor = .gray
        v.placeholderFontScale = 1
        v.minimumFontSize = 13
        v.borderStyle = .line
        v.addTarget(self, action: #selector(SignUpViewController.passwordTextFieldDidChange(_:)),for: .editingChanged)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let passwordWiederholenTextField: CustomTextField = {
        let v = CustomTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Passwort wiederholen"
        v.placeholderColor = .gray
        v.placeholderFontScale = 1
        v.minimumFontSize = 13
        v.borderStyle = .line
        v.addTarget(self, action: #selector(SignUpViewController.passwordTextFieldDidChange(_:)),for: .editingChanged)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let backButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named:"backButton"), for: .normal)
        v.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let eyeButtonOne: UIButton = {
        let v = UIButton()
        v.addTarget(self, action: #selector(eyeButtonOneTapped), for: .touchUpInside)
        v.setImage(UIImage(named: "eyeOpen"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let eyeButtonTwo: UIButton = {
        let v = UIButton()
        v.addTarget(self, action: #selector(eyeButtonTwoTapped), for: .touchUpInside)
        v.setImage(UIImage(named: "eyeOpen"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let signUpButton: TransitionButton = {
        let v = TransitionButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Registrieren", for: .normal)
        v.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.titleLabel?.textColor = .white
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = UIColor.darkGray
        v.layer.cornerRadius = 3
        v.addTarget(self, action: #selector(signUpButtonTapped(_:)), for: .touchUpInside)
        return v
    }()
    
    let documentsLabel: UILabel = {
        let v = UILabel()
        v.text = "Durch Klicken auf 'Registrieren' akzeptiere ich die Nutzungbedingungnen und die Datenschutzrichtlinien."
        v.font = UIFont(name: "AvenirNext-Regular", size: 13)
        v.textColor = .lightGray
        v.textAlignment = .center
        v.numberOfLines = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    
    var email = ""
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Auge Button Standart auf offen setzen
        eyeButtonOne.setImage(UIImage(named: "eyeOpen"), for: .normal)
        eyeButtonTwo.setImage(UIImage(named: "eyeOpen"), for: .normal)
        self.eyeButtonOne.isHidden = true
        self.eyeButtonTwo.isHidden = true
        
        // add motion effect to background image
        Utilities.applyMotionEffect(toView: self.backgroundImage, magnitude: 20)
        
        //password hide/show
        passwordTextField.isSecureTextEntry.toggle()
        
        //password hide/show
        passwordTextField.isSecureTextEntry.toggle()
        
        //change return key
        anzeigeNameTextField.returnKeyType = .next
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .next
        passwordWiederholenTextField.returnKeyType = .done
        
        passwordTextField.textContentType = .newPassword
        passwordWiederholenTextField.textContentType = .newPassword
        
        //prefill emailTextfield with previous email
        self.emailTextField.text = email
        
        //Textfield cursor -> white
        UITextField.appearance().tintColor = .white
        
        //clear button
        anzeigeNameTextField.clearButtonMode = .always
        emailTextField.clearButtonMode = .always

        setUpViews()
//        //listen for keyboard events
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
//    //stop listening for keyboard hide/show events
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//    }


    // Check the fields and validate that the data is correct. If everything is corrct, this method return nil. Otherwise, it return the error-message as a string.
    
    func setUpViews() {
        
        view.addSubview(backgroundImage)
        view.addSubview(backButton)
        view.addSubview(scrollView)
        
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(anzeigeNameTextField)
        scrollView.addSubview(wishlistHandleTextField)
        scrollView.addSubview(passwordTextField)
        passwordTextField.addSubview(eyeButtonOne)
        scrollView.addSubview(passwordWiederholenTextField)
        passwordWiederholenTextField.addSubview(eyeButtonTwo)
        scrollView.addSubview(signUpButton)
        scrollView.addSubview(documentsLabel)
        
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -20).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -20).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        anzeigeNameTextField.topAnchor.constraint(equalTo: emailTextField.topAnchor, constant: 80).isActive = true
        anzeigeNameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        anzeigeNameTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        anzeigeNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        wishlistHandleTextField.topAnchor.constraint(equalTo: anzeigeNameTextField.topAnchor, constant: 80).isActive = true
        wishlistHandleTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        wishlistHandleTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        wishlistHandleTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: wishlistHandleTextField.topAnchor, constant: 80).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        eyeButtonOne.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor, constant: 10).isActive = true
        eyeButtonOne.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor).isActive = true
        
        passwordWiederholenTextField.topAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: 80).isActive = true
        passwordWiederholenTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        passwordWiederholenTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        passwordWiederholenTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        eyeButtonTwo.centerYAnchor.constraint(equalTo: passwordWiederholenTextField.centerYAnchor, constant: 10).isActive = true
        eyeButtonTwo.trailingAnchor.constraint(equalTo: passwordWiederholenTextField.trailingAnchor).isActive = true
        
        documentsLabel.topAnchor.constraint(equalTo: passwordWiederholenTextField.topAnchor, constant: 80).isActive = true
        documentsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        documentsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        documentsLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        signUpButton.topAnchor.constraint(equalTo: documentsLabel.topAnchor, constant: 80).isActive = true
        signUpButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        
    }
    func validateFields() ->String? {
        
        //check if all fields are filled
        if anzeigeNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwordWiederholenTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        //check if both passwords are the same
        if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) !=
            passwordWiederholenTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            
            return "The passwords do not match."
        }
        
        return nil
    }
    
    @objc func signUpButtonTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            //dismiss keyboard
            view.endEditing(true)
            
            //there is sth wrong with the fields, show error message
//            showError(error!)
        }else {
            
            //create cleaned versione of the data
            let firstName = anzeigeNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                //check for errors
                if let err = err {
                    self.view.endEditing(true)
//                    self.showError(err.localizedDescription)
                    
                }else {
                    
                    //user was created successfully; store first and last name
                    let db = Firestore.firestore()
                    
                    let userID = result!.user.uid
                    
                    db.collection("users").document(userID).setData(["firstname":firstName, "uid": result!.user.uid]) { (error) in
                        if error != nil {
//                            self.showError("Error saving user data")
                        }
                    }
                    
                    db.collection("users").document(userID).collection("wishlists").document("Main Wishlist").setData(["name": "Main Wishlist", "listIDX": 1]) { (error) in
                        if error != nil {
//                            self.showError("Error creating Main Wishlist")
                        }
                    }
                    
                    self.signUpButton.startAnimation()
                    //transition to home
                    self.transitionToHome()
                }
            
            }
        }
        
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    func transitionToHome () {

        let homeViewCotnroller =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? MainViewController
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
        if textField == anzeigeNameTextField {
            emailTextField.becomeFirstResponder()
        }else if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField {
            passwordWiederholenTextField.becomeFirstResponder()
        }else if textField == passwordWiederholenTextField {
            passwordWiederholenTextField.resignFirstResponder()
            self.signUpButton.sendActions(for: .touchUpInside)
        }
        
        return true
    }
    
    
//    //move UI if Keyboard shows/hides
//    @objc func keyboardWillChange(notification: Notification) {
//
//        if notification.name == UIResponder.keyboardWillShowNotification ||
//            notification.name == UIResponder.keyboardWillChangeFrameNotification {
//
//            // Keyboard shows
//
//                self.view.layoutIfNeeded()
//                self.stackViewConstraint.constant = 50
//                self.backButton.alpha = 1
//
//                UIView.animate(withDuration: 0.25) {
//                    self.view.layoutIfNeeded()
//                }
//
//
//        }else {
//
//            // Keyboard hides
//            self.stackViewConstraint.constant = 79
//            self.backButton.alpha = 1
//
//            UIView.animate(withDuration: 0.25) {
//                self.view.layoutIfNeeded()
//            }
//        }
//    }
    
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
        if textField == passwordWiederholenTextField {
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
        if textField == passwordWiederholenTextField {
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
        passwordWiederholenTextField.isSecureTextEntry.toggle()


            if let existingText = passwordWiederholenTextField.text, passwordWiederholenTextField.isSecureTextEntry {
                /* When toggling to secure text, all text will be purged if the user
                 continues typing unless we intervene. This is prevented by first
                 deleting the existing text and then recovering the original text. */
                passwordWiederholenTextField.deleteBackward()

                if let textRange = passwordWiederholenTextField.textRange(from: passwordWiederholenTextField.beginningOfDocument, to: passwordWiederholenTextField.endOfDocument) {
                    passwordWiederholenTextField.replace(textRange, withText: existingText)
                }
            }
        
        
        
            /* Reset the selected text range since the cursor can end up in the wrong
             position after a toggle because the text might vary in width */
            if let existingSelectedTextRange = passwordWiederholenTextField.selectedTextRange {
                passwordWiederholenTextField.selectedTextRange = nil
                passwordWiederholenTextField.selectedTextRange = existingSelectedTextRange
            }
    }
    
    @objc func passwordTextFieldDidChange(_ textField: UITextField) {

    }
}
