//
//  LoginViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 22.08.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit
import FirebaseAuth
import TextFieldEffects
import TransitionButton

class LoginViewController: UIViewController, UITextFieldDelegate {
    
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
    
    let passwordTextField: CustomTextField = {
        let v = CustomTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Passwort"
        v.placeholderColor = .gray
        v.placeholderFontScale = 1
        v.clearButtonMode = UITextField.ViewMode.always
        v.minimumFontSize = 13
        v.borderStyle = .line
        v.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)),for: .editingChanged)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let vergessenButton: UIButton = {
        let v = UIButton(type: .system)
        v.setTitle("Vergessen?", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.addTarget(self, action: #selector(vergessenTapped), for: .touchUpInside)
        v.titleLabel?.font = UIFont(name: "Avenir Next", size: 17.0)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let loginButton: TransitionButton = {
        let v = TransitionButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("LOGIN", for: .normal)
        v.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.titleLabel?.textColor = .white
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = UIColor.darkGray
        v.layer.cornerRadius = 3
        v.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        return v
    }()
    
    let errorLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont(name: "AvenirNext-Regular", size: 15)
        v.textColor = .red
        v.textAlignment = .center
        v.numberOfLines = 0
        return v
    }()
    
    let backButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named:"backButton"), for: .normal)
        v.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let eyeButton: UIButton = {
        let v = UIButton()
        v.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()

    @IBOutlet weak var stackViewConstraint: NSLayoutConstraint!

    var email = ""
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        self.passwordTextField.rightPadding = 15
        
        // Auge Button Standart auf offen setzen
        eyeButton.setImage(UIImage(named: "eyeOpen"), for: .normal)

        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //change return key
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .done
        
        // eye button verstecken
        self.eyeButton.isHidden = true
        
        // pass email
        self.emailTextField.text = email
        
        // hide error
        errorLabel.alpha = 0
        
        // password hide/show
        passwordTextField.isSecureTextEntry.toggle()
        
        // Textfield cursor -> white
        UITextField.appearance().tintColor = .white
        
        // add motion effect to background image
        Utilities.applyMotionEffect(toView: self.backgroundImage, magnitude: 25)

    }
    
    func setUpViews() {
        
        view.addSubview(backgroundImage)
        view.addSubview(backButton)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(vergessenButton)
        view.addSubview(loginButton)
        view.addSubview(errorLabel)
        view.addSubview(eyeButton)
        
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -20).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -20).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 130).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.topAnchor, constant: 80).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        vergessenButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor, constant: 10).isActive = true
        vergessenButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor).isActive = true
        
        eyeButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor, constant: 10).isActive = true
        eyeButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor).isActive = true
        
        loginButton.topAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: 80).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        errorLabel.topAnchor.constraint(equalTo: loginButton.topAnchor, constant: 80).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true
        
    }

    @objc func loginButtonTapped(_ sender: Any) {
        
        let email = self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = self.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        // start button animation
        loginButton.startAnimation()
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgorundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgorundQueue.async {
            // check if account details correct
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    DispatchQueue.main.async {
                        // error -> stop animation
                        self.loginButton.stopAnimation(animationStyle: .shake, revertAfterDelay: 0) {
                            self.errorLabel.text = error!.localizedDescription
                            self.errorLabel.alpha = 1
                        }
                    }
                }else {
                    // correct acount details -> login
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        UserDefaults.standard.synchronize()
                        
                        self.transitionToHome()
                    }
                }
            }
        }
    }
    
    func transitionToHome () {

        let homeVC =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? MainViewController
        let navigationController = UINavigationController(rootViewController: homeVC!)

        view.window?.rootViewController = navigationController
        view.window?.makeKeyAndVisible()
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    
    // hide keyboard, wenn user außerhalb toucht
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    // automatischer Fokus auf nächstes Textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == emailTextField {
            print("hi")
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField {
            textField.resignFirstResponder()
            self.loginButton.sendActions(for: .touchUpInside)
        }

        return true
    }
    
    // toggle password
    var check = true
    @objc func eyeButtonTapped() {
        check = !check
        
        if check == true {
            eyeButton.setImage(UIImage(named: "eyeOpen"), for: .normal)
        } else {
            eyeButton.setImage(UIImage(named: "eyeClosed"), for: .normal)
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
    
    // delegate Methode für eye-Button
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case passwordTextField:
            if passwordTextField.text != "" {
                eyeButton.isHidden = false
                vergessenButton.isHidden = true
            } else {
                eyeButton.isHidden = true
            }
            
            break
        default:
            break
        }
        return true
    }
    // delegate Methode für eye-Button
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField == passwordTextField {
            self.eyeButton.isHidden = true
            self.vergessenButton.isHidden = false
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == "" {
            self.eyeButton.isHidden = true
            self.vergessenButton.isHidden = false
        }else {
            self.vergessenButton.isHidden = true
            self.eyeButton.isHidden = false
        }
    }
    
    @objc func vergessenTapped() {
        print("vergessenButtonTapped")
    }
}
