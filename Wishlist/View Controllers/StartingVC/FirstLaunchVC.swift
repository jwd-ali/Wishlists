//
//  ViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 21.08.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import RevealingSplashView

class FirstLaunchViewController: UIViewController, UITextFieldDelegate {
    
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "zauberstab")!, iconInitialSize: CGSize(width: 120, height: 120), backgroundColor: .white)
    
    
    let backgroundImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "backgroundImage")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = false
        return v
    }()

    
    let willkommenLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Willkommen bei Wishlist."
        v.font = UIFont(name: "AvenirNext-Bold", size: 26)
        v.textAlignment = .left
        v.textColor = .white
        v.adjustsFontSizeToFitWidth = true
        v.minimumScaleFactor = 0.5
        return v
    }()
    
    let textLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Werde Mitglied unserer Community und erfülle deine größten Wünsche."
        v.font = UIFont(name: "AvenirNext-Regular", size: 16)
        v.textColor = .white
        v.textAlignment = .left
        v.numberOfLines = 0
        return v
    }()
    
    let emailImage: UIImageView = {
        let v = UIImageView()
        if #available(iOS 13.0, *) {
            v.image = UIImage(systemName: "envelope")
            v.tintColor = .white
        } else {
            // Fallback on earlier versions
        }
        v.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let emailTextfield: UITextField = {
        let v = UITextField(frame: CGRect.init(x: 100, y: 200, width: 100, height: 30))
        v.font = UIFont(name: "AvenirNext-Regular", size: 16)
        v.backgroundColor = .clear
        v.borderStyle = .none
        v.textColor = .white
        v.textAlignment = .left
        v.placeholder = "Email-Adresse"
        v.translatesAutoresizingMaskIntoConstraints = false
        v.autocapitalizationType = .none
        v.addLine(position: .LINE_POSITION_BOTTOM, color: .white, width: 2)
        v.addPadding(.left(60))
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
    
    let kostenlosLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont(name: "AvenirNext-Regular", size: 13)
        v.textColor = .white
        v.textAlignment = .center
        v.text = "Anmelden oder kostenlos registrieren"
        return v
    }()
    
    let oderLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.textColor = .white
        v.textAlignment = .center
        v.text = "ODER"
        return v
    }()
    
    let lineLeft: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage(named: "line")
        return v
    }()
    
    let lineRight: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage(named: "line")
        return v
    }()
    
    let facebookButton: CustomButton = {
        let v = CustomButton(type: .system)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Mit Facebook fortfahren", for: .normal)
        v.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.titleLabel?.textColor = .white
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = UIColor(red: 105/255, green: 141/255, blue: 210/255, alpha: 1)
        v.layer.cornerRadius = 3
        return v
    }()
    
    let facebookLogo: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "facebook")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    let googleButton: CustomButton = {
        let v = CustomButton(type: .system)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Mit Google forfahren", for: .normal)
        v.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.setTitleColor(.darkGray, for: .normal)
        v.backgroundColor = .white
        v.layer.cornerRadius = 3
        return v
    }()
    
    let googleLogo: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "google")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    let appleButton: CustomButton = {
        let v = CustomButton(type: .system)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Mit Apple forfahren", for: .normal)
        v.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        v.layer.cornerRadius = 3
        return v
    }()
    
    let appleLogo: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "apple")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Textfield cursor -> white
        UITextField.appearance().tintColor = .white
        
        // add motion effect to background image
        Utilities.applyMotionEffect(toView: self.backgroundImage, magnitude: 25)
        
        setUpViews()
        
        revealingSplashView.startAnimation()
    }
    
    
    func setUpViews(){
        
        view.addSubview(backgroundImage)
        view.addSubview(willkommenLabel)
        view.addSubview(textLabel)
        view.addSubview(weiterButton)
        view.addSubview(emailTextfield)
        emailTextfield.addSubview(emailImage)
        view.addSubview(kostenlosLabel)
        view.addSubview(oderLabel)
        view.addSubview(lineLeft)
        view.addSubview(lineRight)
        view.addSubview(facebookButton)
        facebookButton.addSubview(facebookLogo)
        view.addSubview(googleButton)
        googleButton.addSubview(googleLogo)
        view.addSubview(appleButton)
        appleButton.addSubview(appleLogo)
        
        view.addSubview(revealingSplashView)
        
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -20).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -20).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        
        willkommenLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        willkommenLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        willkommenLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        
        textLabel.topAnchor.constraint(equalTo: willkommenLabel.topAnchor, constant: 50).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        kostenlosLabel.topAnchor.constraint(equalTo: textLabel.topAnchor, constant: 120).isActive = true
        kostenlosLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        emailTextfield.topAnchor.constraint(equalTo: kostenlosLabel.topAnchor, constant: 35).isActive = true
        emailTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        emailTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        emailImage.leadingAnchor.constraint(equalTo: emailTextfield.leadingAnchor, constant: 10).isActive = true
        emailImage.centerYAnchor.constraint(equalTo: emailTextfield.centerYAnchor).isActive = true
        emailImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        emailImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        weiterButton.leadingAnchor.constraint(equalTo: emailTextfield.leadingAnchor).isActive = true
        weiterButton.trailingAnchor.constraint(equalTo: emailTextfield.trailingAnchor).isActive = true
        weiterButton.topAnchor.constraint(equalTo: emailTextfield.topAnchor, constant: 60).isActive = true
        weiterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        oderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        oderLabel.bottomAnchor.constraint(equalTo: weiterButton.bottomAnchor, constant: 40).isActive = true
        oderLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        lineLeft.centerYAnchor.constraint(equalTo: oderLabel.centerYAnchor).isActive = true
        lineLeft.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        lineLeft.trailingAnchor.constraint(equalTo: oderLabel.leadingAnchor).isActive = true
        
        lineRight.centerYAnchor.constraint(equalTo: oderLabel.centerYAnchor).isActive = true
        lineRight.leadingAnchor.constraint(equalTo: oderLabel.trailingAnchor).isActive = true
        lineRight.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        facebookButton.leadingAnchor.constraint(equalTo: emailTextfield.leadingAnchor).isActive = true
        facebookButton.trailingAnchor.constraint(equalTo: emailTextfield.trailingAnchor).isActive = true
        facebookButton.bottomAnchor.constraint(equalTo: oderLabel.bottomAnchor, constant: 55 + 10).isActive = true
        facebookButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        facebookLogo.centerYAnchor.constraint(equalTo: facebookButton.centerYAnchor).isActive = true
        facebookLogo.leadingAnchor.constraint(equalTo: facebookButton.leadingAnchor, constant: 10).isActive = true
        facebookLogo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        facebookLogo.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        googleButton.leadingAnchor.constraint(equalTo: emailTextfield.leadingAnchor).isActive = true
        googleButton.trailingAnchor.constraint(equalTo: emailTextfield.trailingAnchor).isActive = true
        googleButton.bottomAnchor.constraint(equalTo: facebookButton.bottomAnchor, constant: 55 + 10).isActive = true
        googleButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        googleLogo.centerYAnchor.constraint(equalTo: googleButton.centerYAnchor).isActive = true
        googleLogo.leadingAnchor.constraint(equalTo: googleButton.leadingAnchor, constant: 10).isActive = true
        googleLogo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        googleLogo.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        appleButton.leadingAnchor.constraint(equalTo: emailTextfield.leadingAnchor).isActive = true
        appleButton.trailingAnchor.constraint(equalTo: emailTextfield.trailingAnchor).isActive = true
        appleButton.bottomAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 55 + 10).isActive = true
        appleButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        appleLogo.centerYAnchor.constraint(equalTo: appleButton.centerYAnchor).isActive = true
        appleLogo.leadingAnchor.constraint(equalTo: appleButton.leadingAnchor, constant: 10).isActive = true
        appleLogo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        appleLogo.widthAnchor.constraint(equalToConstant: 30).isActive = true
 
    }
    
    // funktion für email-syntax prüfen, siehe "sighUpVC: validateFields()
    
    var email = ""
    
    @objc func weiterButtonTapped() {
    
        email = emailTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
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
                
                self.navigationController?.pushViewController(LoginView, animated: true)
            }
        } 
    }
    
    
    // hide keyboard, wenn user außerhalb toucht
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // user drück auf "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

