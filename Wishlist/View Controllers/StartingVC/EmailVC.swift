//
//  EmailVC.swift
//  Wishlist
//
//  Created by Christian Konnerth on 26.01.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import TextFieldEffects
import SwiftEntryKit
import Lottie


class EmailViewController: UIViewController, UIGestureRecognizerDelegate {
    
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
        v.text = "Anmelden oder kostenlos registrieren"
        v.font = UIFont(name: "AvenirNext-Bold", size: 23)
        v.textAlignment = .left
        v.textColor = .white
        v.adjustsFontSizeToFitWidth = true
        v.minimumScaleFactor = 0.5
        v.numberOfLines = 0
        return v
    }()
    
    let emailTextField: HoshiTextField = {
        let v = HoshiTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Email-Adresse"
        v.placeholderColor = .white
        v.placeholderFontScale = 0.8
        v.minimumFontSize = 13
        v.borderStyle = .line
        v.autocapitalizationType = .none
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let kostenlosLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 13)
        v.textColor = .white
        v.textAlignment = .center
        v.text = "Anmelden oder kostenlos registrieren"
        return v
    }()
    
    let weiterButton: CustomButton = {
        let v = CustomButton(type: .system)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("WEITER", for: .normal)
        v.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.titleLabel?.textColor = .white
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = UIColor.darkGray
        v.layer.cornerRadius = 3
        v.addTarget(self, action: #selector(weiterButtonTapped), for: .touchUpInside)
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
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // activate swipe to pop VC
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self

        setUpViews()
        
        emailTextField.textContentType = .emailAddress
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder() 
    }
    
    func setUpViews() {
        
        view.addSubview(backgroundImage)
        view.addSubview(backButton)
        view.addSubview(theLabel)
        view.addSubview(emailTextField)
        view.addSubview(weiterButton)
        
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
        emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        weiterButton.topAnchor.constraint(equalTo: emailTextField.topAnchor, constant: 80).isActive = true
        weiterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        weiterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        weiterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
    }
    var email = ""
        
    
    //MARK: Error Pop-up
    func showErrorPopUp(description: String){
        var attributes = EKAttributes.topToast
        attributes.entryBackground = .color(color: EKColor(.white))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        attributes.statusBar = .dark
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.displayDuration = 5
        

        let title = EKProperty.LabelContent(text: "Fehler", style: .init(font: UIFont(name: "AvenirNext-Bold", size: 15)!, color: EKColor(UIColor.darkGray)))
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
        
        logoAnimation.centerXAnchor.constraint(equalTo: weiterButton.centerXAnchor).isActive = true
        logoAnimation.centerYAnchor.constraint(equalTo: weiterButton.centerYAnchor).isActive = true
        logoAnimation.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoAnimation.widthAnchor.constraint(equalToConstant: 50).isActive = true
        logoAnimation.loopMode = .loop
    }

    @objc func weiterButtonTapped() {
        // resign keyboard
        self.emailTextField.resignFirstResponder()
        // disable button tap
        self.weiterButton.isEnabled = false
        // hide the buttons title
        self.weiterButton.setTitle("", for: .normal)
        // start loading animation
        setupLoadingAnimation()
        logoAnimation.play()
    
        email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //prüfen, ob Email schon registriert ist
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
            
            if error != nil  && Utilities.isValidEmail(self.emailTextField.text!) {
                // some internal error while requesting emails
                
                // show error popUp
                // stop loading animation
                self.logoAnimation.stop()
                // remove animation from view
                self.logoAnimation.removeFromSuperview()
                // reset button title to "Registrieren"
                self.weiterButton.setTitle("Weiter", for: .normal)
                // play shake animation
                self.weiterButton.shake()
                // enable button tap
                self.weiterButton.isEnabled = true
                // show error popUp
                self.showErrorPopUp(description: error!.localizedDescription)
            } else {
                // no error -> check email adress
                
                //Email ist noch nicht registriert -> sign up
                if methods == nil {
                    
                    let SignUpView = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpViewController
                    // pass email to SignUpVC
                    SignUpView.email = self.email
                    
                    let weiterButtonID = "weiterButtonID"
                    self.weiterButton.heroID = weiterButtonID
                    
                    SignUpView.signUpButton.heroID = weiterButtonID
                    
                    // stop loading animation
                    self.logoAnimation.stop()
                    // remove animation from view
                    self.logoAnimation.removeFromSuperview()
                    // reset button title to "Weiter"
                    self.weiterButton.setTitle("Weiter", for: .normal)
                    // enable button tap
                    self.weiterButton.isEnabled = true
                    
                    self.navigationController?.pushViewController(SignUpView, animated: true)
                    
                }
                //Email ist registriert -> login
                else {
                    
                    // stop loading animation
                    self.logoAnimation.stop()
                    // remove animation from view
                    self.logoAnimation.removeFromSuperview()
                    // reset button title to "Weiter"
                    self.weiterButton.setTitle("Weiter", for: .normal)
                    // enable button tap
                    self.weiterButton.isEnabled = true
                    
                    self.view.endEditing(true)
                    
                    let LoginView = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
                    // pass email to LoginVC
                    LoginView.email = self.email
                    
                    self.navigationController?.pushViewController(LoginView, animated: false)
                }
            }
            
            
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // hide keyboard, wenn user außerhalb toucht
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
