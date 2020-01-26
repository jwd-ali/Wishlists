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

class EmailViewController: UIViewController {
    
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
    
    let kostenlosLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont(name: "AvenirNext-Regular", size: 13)
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

        setUpViews()
        
        // add motion effect to background image
        Utilities.applyMotionEffect(toView: self.backgroundImage, magnitude: 25)
    }
    
    func setUpViews() {
        
        view.addSubview(backgroundImage)
        view.addSubview(backButton)
        view.addSubview(emailTextField)
        view.addSubview(weiterButton)
        view.addSubview(kostenlosLabel)
        
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
        
        weiterButton.topAnchor.constraint(equalTo: emailTextField.topAnchor, constant: 80).isActive = true
        weiterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        weiterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        weiterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        kostenlosLabel.topAnchor.constraint(equalTo: weiterButton.topAnchor, constant: 70).isActive = true
        kostenlosLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    var email = ""
        
    @objc func weiterButtonTapped() {
    
        email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //prüfen, ob Email schon registriert ist
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
            
            //Email ist noch nicht registriert -> sign up
            if methods == nil {
                
                let SignUpView = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpViewController
                
                SignUpView.email = self.email
                
                self.navigationController?.pushViewController(SignUpView, animated: false)
                
            }
            //Email ist registriert -> login
            else {
                
                self.view.endEditing(true)
                
                let LoginView = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
                
                LoginView.email = self.email
                
                self.navigationController?.pushViewController(LoginView, animated: false)
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
