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
   

    @IBOutlet weak var logoStackView: UIStackView!
    @IBOutlet weak var logoConstraint: NSLayoutConstraint!
    @IBOutlet weak var anmeldenLabel: UILabel!
    @IBOutlet weak var bottomConstraintEmail: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTestTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var weiterButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        setUpElements()
        
        //Textfield cursor -> white
        UITextField.appearance().tintColor = .white
        
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        
   
        Utilities.applyMotionEffect(toView: self.backgroundImage, magnitude: 20)
        
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
    
    //funktion für email-syntax prüfen, siehe "sighUpVC: validateFields()
    
    var email = ""
    
    @IBAction func weiterButtonTapped(_ sender: Any) {

        
        email = emailTestTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
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

