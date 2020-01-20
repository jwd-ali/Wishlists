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

class ViewController: UIViewController, UITextFieldDelegate {
    
    let backgroundImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "backgroundImage")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = false
        return v
    }()
    
    let logoImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "logoGedreht")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let wishlistLabel: UILabel = {
        let v = UILabel()
        v.text = "Wishlist"
        v.font = UIFont(name: "Noteworthy-Light", size: 45)
        v.textAlignment = .center
        v.textColor = UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1)
        v.translatesAutoresizingMaskIntoConstraints = false
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
        let v = UITextField(frame: CGRect.init(x: 0, y: 0, width: 100, height: 30))
        v.font = UIFont(name: "AvenirNext-Regular", size: 20)
        v.textColor = .white
        v.textAlignment = .left
        v.placeholder = "Email-Adresse"
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addLine(position: .LINE_POSITION_BOTTOM, color: .blue, width: 2)
        v.addPadding(.left(60))
        return v
    }()
    
    let weiterButton: CustomButton = {
        let v = CustomButton(type: .system)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("WEITER", for: .normal)
        v.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        v.titleLabel?.textColor = .white
        v.setTitleColor(.white, for: .normal)
//        v.backgroundColor = UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1)
        v.backgroundColor = UIColor.lightGray
        v.layer.cornerRadius = 3
        v.addTarget(self, action: #selector(weiterButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let kostenlosLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont(name: "AvenirNext-Medium", size: 14)
        v.textColor = .white
        v.textAlignment = .center
        v.text = "Anmelden oder kostenlos registrieren"
        return v
    }()
   

    @IBOutlet weak var logoStackView: UIStackView!
    @IBOutlet weak var logoConstraint: NSLayoutConstraint!
    @IBOutlet weak var anmeldenLabel: UILabel!
    @IBOutlet weak var bottomConstraintEmail: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Textfield cursor -> white
        UITextField.appearance().tintColor = .white
        
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        
   
        Utilities.applyMotionEffect(toView: self.backgroundImage, magnitude: 20)
        
//    //listen for keyboard events
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        view.addSubview(backgroundImage)
        view.addSubview(weiterButton)
        view.addSubview(emailTextfield)
        view.addSubview(emailImage)
        view.addSubview(logoImage)
        view.addSubview(wishlistLabel)
        
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -20).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -20).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        
        emailTextfield.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emailTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        emailTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        emailImage.leadingAnchor.constraint(equalTo: emailTextfield.leadingAnchor, constant: 10).isActive = true
        emailImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emailImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        emailImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        weiterButton.leadingAnchor.constraint(equalTo: emailTextfield.leadingAnchor).isActive = true
        weiterButton.trailingAnchor.constraint(equalTo: emailTextfield.trailingAnchor).isActive = true
        weiterButton.topAnchor.constraint(equalTo: emailTextfield.topAnchor, constant: 60).isActive = true
        weiterButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
        logoImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
        logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        wishlistLabel.topAnchor.constraint(equalTo: logoImage.topAnchor, constant: 120 + 10).isActive = true
        wishlistLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
    }
    
    // stop listening for keyboard hide/show events
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // funktion für email-syntax prüfen, siehe "sighUpVC: validateFields()
    
    var email = ""
    
    @objc func weiterButtonTapped() {

        
        email = emailTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        //prüfen, ob Email schon registriert ist
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
            
            //Email ist noch nicht registriert -> sign up
            if methods == nil {
                
                self.logoStackView.alpha = 0
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
                
                self.view.endEditing(true)
                
                let SignUpView = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpViewController
                
                SignUpView.email = self.email
                
                self.navigationController?.pushViewController(SignUpView, animated: false)
                
            }
            //Email ist registriert -> login
            else {
                
                self.logoStackView.alpha = 0
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
                
                self.view.endEditing(true)
                
                let LoginView = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
                
                LoginView.email = self.email
                
                self.navigationController?.pushViewController(LoginView, animated: false)
            }
        } 
    }
    
    
    //hide keyboard, wenn user außerhalb toucht
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //user drück auf "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //move UI if keyboard shows/hides
    @objc func keyboardWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            
            // Keyboard shows

                self.view.layoutIfNeeded()
                let heightHelper = self.bottomConstraint.constant
                self.bottomConstraint.constant = keyboardRect.height + 20
                
                self.bottomConstraintEmail.constant += keyboardRect.height + 20 - heightHelper
                self.anmeldenLabel.alpha = 0
                self.logoConstraint.constant = 45
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
            
        }else {
            // Keyboard hides

                self.view.layoutIfNeeded()
                self.bottomConstraintEmail.constant = 337
                self.bottomConstraint.constant = 255.5
                self.logoConstraint.constant = 60
                self.anmeldenLabel.alpha = 1
       
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

