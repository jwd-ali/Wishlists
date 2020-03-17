//
//  ForgotPasswordVC.swift
//  Wishlist
//
//  Created by Christian Konnerth on 17.03.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit
import TextFieldEffects
import FirebaseAuth
import FirebaseDatabase
import Firebase
import Lottie
import SwiftEntryKit

class ForgotPasswordVC: UIViewController {
    
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
        v.text = "Passwort zurücksetzen"
        v.font = UIFont(name: "AvenirNext-Bold", size: 23)
        v.numberOfLines = 0
        v.textAlignment = .left
        v.textColor = .white
        v.adjustsFontSizeToFitWidth = true
        v.minimumScaleFactor = 0.5
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
    
    let resetButton: CustomButton = {
        let v = CustomButton(type: .system)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Zurücksetzen", for: .normal)
        v.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.titleLabel?.textColor = .white
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = UIColor.darkGray
        v.layer.cornerRadius = 3
        v.addTarget(self, action: #selector(resetButtonTappped), for: .touchUpInside)
        return v
    }()
    
    let backButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named:"dismissButton"), for: .normal)
        v.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let logoAnimation = AnimationView(name: "LoadingAnimation")
    
    var email: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.text = email

        setUpViews()
    }
    

   
    func setUpViews() {
        
        view.addSubview(backgroundImage)
        view.addSubview(backButton)
        view.addSubview(theLabel)
        view.addSubview(emailTextField)
        view.addSubview(resetButton)
        
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -20).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -20).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        
        
        
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        theLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20).isActive = true
        theLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        theLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: theLabel.bottomAnchor, constant: 20).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        resetButton.topAnchor.constraint(equalTo: emailTextField.topAnchor, constant: 80).isActive = true
        resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
    }
    
    //hide keyboard, wenn user außerhalb toucht
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func backButtonTapped(){
        self.dismiss(animated: true, completion: nil)
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
        

        let title = EKProperty.LabelContent(text: "Zurücksetzen fehlgeschlagen", style: .init(font: UIFont(name: "AvenirNext-Bold", size: 15)!, color: EKColor(UIColor.darkGray)))
        let description = EKProperty.LabelContent(text: description, style: .init(font: UIFont(name: "AvenirNext-Regular", size: 13)!, color: EKColor(UIColor.darkGray)))
        let image = EKProperty.ImageContent(image: UIImage(named: "false")!, size: CGSize(width: 20, height: 20))
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        

        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    //MARK: Success Pop-up
    func showSuccessPopUp(description: String){
        var attributes = EKAttributes.topToast
        attributes.entryBackground = .color(color: EKColor(.white))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        attributes.statusBar = .dark
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.displayDuration = 5
        

        let title = EKProperty.LabelContent(text: "Passwort zurückgesetzt", style: .init(font: UIFont(name: "AvenirNext-Bold", size: 15)!, color: EKColor(UIColor.darkGray)))
        let description = EKProperty.LabelContent(text: description, style: .init(font: UIFont(name: "AvenirNext-Regular", size: 13)!, color: EKColor(UIColor.darkGray)))
        let image = EKProperty.ImageContent(image: UIImage(named: "correct")!, size: CGSize(width: 20, height: 20))
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
        
        logoAnimation.centerXAnchor.constraint(equalTo: resetButton.centerXAnchor).isActive = true
        logoAnimation.centerYAnchor.constraint(equalTo: resetButton.centerYAnchor).isActive = true
        logoAnimation.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoAnimation.widthAnchor.constraint(equalToConstant: 50).isActive = true
        logoAnimation.loopMode = .loop
    }
    
    @objc func resetButtonTappped(){
        print("reset tapped")
        // disable button tap
        self.resetButton.isEnabled = false
        // hide the buttons title
        self.resetButton.setTitle("", for: .normal)
        // start loading animation
        setupLoadingAnimation()
        logoAnimation.play()
        
        self.email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().sendPasswordReset(withEmail: email!) { error in
            if error != nil {
                // stop loading animation
                self.logoAnimation.stop()
                // remove animation from view
                self.logoAnimation.removeFromSuperview()
                // reset button title to "Registrieren"
                self.resetButton.setTitle("Zurücksetzen", for: .normal)
                // play shake animation
                self.resetButton.shake()
                // enable button tap
                self.resetButton.isEnabled = true
                // show error popUp
                self.showErrorPopUp(description: error!.localizedDescription)
            } else {
                self.showSuccessPopUp(description: "Wir schicken dir in kürze eine Email für dein neues Passwort. Das kann einige Minuten dauern.")
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
}
