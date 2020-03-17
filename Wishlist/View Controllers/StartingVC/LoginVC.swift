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
import SwiftEntryKit
import Lottie

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let backgroundImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "backgroundImage")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = false
        return v
    }()
    
    let theLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Login"
        v.font = UIFont(name: "AvenirNext-Bold", size: 23)
        v.textAlignment = .left
        v.textColor = .white
        v.adjustsFontSizeToFitWidth = true
        v.minimumScaleFactor = 0.5
        v.numberOfLines = 0
        return v
    }()
    
    let emailTextField: CustomTextField = {
        let v = CustomTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Email-Adresse"
        v.placeholderColor = .white
        v.placeholderFontScale = 0.8
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
        v.placeholderColor = .white
        v.placeholderFontScale = 0.8
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
    
    let loginButton: CustomButton = {
        let v = CustomButton(type: .system)
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
    
    let logoAnimation = AnimationView(name: "LoadingAnimation")
    
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
        v.setImage(UIImage(named: "eyeOpen"), for: .normal)
        v.contentHorizontalAlignment = .fill
        v.contentVerticalAlignment = .fill
        v.imageView?.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    @IBOutlet weak var stackViewConstraint: NSLayoutConstraint!

    var email = ""
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        self.passwordTextField.addPadding(.right(15))

        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //change return key
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .done
        
        // eye button verstecken
        self.eyeButton.isHidden = true
        
        // pass email
        self.emailTextField.text = email
        
        // password hide/show
        passwordTextField.isSecureTextEntry.toggle()
        
        // Textfield cursor -> white
        UITextField.appearance().tintColor = .white
        
        // add motion effect to background image
        Utilities.applyMotionEffect(toView: self.backgroundImage, magnitude: 20)

    }
    
    func setUpViews() {
        
        view.addSubview(backgroundImage)
        view.addSubview(backButton)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(vergessenButton)
        view.addSubview(loginButton)
        view.addSubview(eyeButton)
        view.addSubview(theLabel)
        
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -20).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -20).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        theLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20).isActive = true
        theLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        theLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: theLabel.bottomAnchor, constant: 20).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.topAnchor, constant: 80).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        vergessenButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor, constant: 10).isActive = true
        vergessenButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor).isActive = true
        
        eyeButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor, constant: 10).isActive = true
        eyeButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor).isActive = true
        eyeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        eyeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        loginButton.topAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: 80).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    //MARK: Error Pop-up
    func showErrorPopUp(description: String){
        var attributes = EKAttributes.topToast
        attributes.entryBackground = .color(color: EKColor(.white))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        attributes.statusBar = .dark
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.displayDuration = 5
        

        let title = EKProperty.LabelContent(text: "Login fehlgeschlagen", style: .init(font: UIFont(name: "AvenirNext-Bold", size: 15)!, color: EKColor(UIColor.darkGray)))
        let description = EKProperty.LabelContent(text: description, style: .init(font: UIFont(name: "AvenirNext-Regular", size: 13)!, color: EKColor(UIColor.darkGray)))
        let image = EKProperty.ImageContent(image: UIImage(named: "false")!, size: CGSize(width: 20, height: 20))
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        

        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    //MARK: setup Loading-Animation
    func setupLoadingAnimation(){
       
        logoAnimation.contentMode = .scaleAspectFit
        logoAnimation.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logoAnimation)
        
        logoAnimation.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        logoAnimation.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor).isActive = true
        logoAnimation.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoAnimation.widthAnchor.constraint(equalToConstant: 50).isActive = true
        logoAnimation.loopMode = .loop
    }

    @objc func loginButtonTapped(_ sender: Any) {
        
        // disable button tap
        self.loginButton.isEnabled = false
        // hide the buttons title
        self.loginButton.setTitle("", for: .normal)
        // start loading animation
        setupLoadingAnimation()
        logoAnimation.play()
        
        let email = self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = self.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        // check if account details correct
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // stop loading animation
                self.logoAnimation.stop()
                // remove animation from view
                self.logoAnimation.removeFromSuperview()
                // reset button title to "Registrieren"
                self.loginButton.setTitle("Login", for: .normal)
                // play shake animation
                self.loginButton.shake()
                // enable button tap
                self.loginButton.isEnabled = true
                // show error popUp
                self.showErrorPopUp(description: error!.localizedDescription)
            }else {
                // correct acount details -> login
                UserDefaults.standard.setIsLoggedIn(value: true)
                UserDefaults.standard.synchronize()
                // stop animation
                self.logoAnimation.stop()
                // transition to Home-ViewController
                self.transitionToHome()
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
        navigationController?.popViewController(animated: false)
    }

    
    // hide keyboard, wenn user außerhalb toucht
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    // automatischer Fokus auf nächstes Textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == emailTextField {
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
        let forgotPasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        forgotPasswordVC.email = self.emailTextField.text!
        self.present(forgotPasswordVC, animated: true, completion: nil)
    }
}
