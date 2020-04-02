//
//  UserNameVC.swift
//  Wishlist
//
//  Created by Christian Konnerth on 16.03.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import TextFieldEffects
import SwiftEntryKit
import Lottie
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import GoogleSignIn

class UserNameVC: UIViewController, UITextFieldDelegate {

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
        v.text = "Benutzername erstellen"
        v.font = UIFont(name: "AvenirNext-Bold", size: 23)
        v.textAlignment = .left
        v.textColor = .white
        v.adjustsFontSizeToFitWidth = true
        v.minimumScaleFactor = 0.5
        v.numberOfLines = 0
        return v
    }()
    
    let confirmButton: CustomButton = {
        let v = CustomButton(type: .system)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("BESTÄTIGEN", for: .normal)
        v.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.titleLabel?.textColor = .white
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = UIColor.darkGray
        v.layer.cornerRadius = 3
        v.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
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
    
    //MARK: Username
    
    var usernameConstraint:NSLayoutConstraint!
    
    let usernameView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.style = UIActivityIndicatorView.Style.medium
        v.color = .white
        v.hidesWhenStopped = true
        return v
    }()
    
    let usernameTextField: CustomTextField = {
        let v = CustomTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Benutzername"
        v.placeholderColor = .white
        v.placeholderFontScale = 1
        v.minimumFontSize = 13
        v.borderStyle = .line
        v.autocapitalizationType = .none
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(textFieldDidChange(_:)),for: .editingChanged)
        v.returnKeyType = .done
        return v
    }()
    
    lazy var checkUsernameImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "false")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var usernameCorrectImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "correct")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    
    lazy var checkUserNameLabel: UILabel = {
        let v = UILabel()
        v.text = "kein gültiger Benutzername"
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 13)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // timer for username activity indicator
    var timer = Timer()
    
    var signInOption: Constants.SignInMethod?
    // accessToken for FB-Signin
    var accessToken: AccessToken?
    // authentication for Google-Signup
    var authentication: GIDAuthentication?
    // credential for Apple-Signup
    var credential: OAuthCredential?
    // email and password for Email-Signup
    var email: String?
    var password: String?
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        usernameTextField.autocorrectionType = .no
        setUpViews()
    }
    
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameTextField.becomeFirstResponder()
    }
    
    //MARK: textFieldDidChange
    @objc private func textFieldDidChange(_ textField: UITextField) {
        
        timer.invalidate() // reset timer
        
        self.checkUsernameImage.removeFromSuperview()
        self.usernameCorrectImage.removeFromSuperview()
        self.checkUserNameLabel.removeFromSuperview()
        self.usernameConstraint.constant = 60
        self.view.layoutIfNeeded()
        
        if textField.text?.isEmpty == true {
            self.checkUsernameImage.removeFromSuperview()
            self.setupUsernameTextField()
            self.checkUsernameImage.image = UIImage(named: "false")
            self.checkUserNameLabel.text = "kein gültiger Benutzername"
        }
        

        // start the timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    //MARK: timerAction
    @objc func timerAction() {
        // start action if textfield is not empty
        if usernameTextField.text! != "" {
            // start loading indicator
            activityIndicator.startAnimating()
            DataHandler.checkUsername(field: usernameTextField.text!) { (success) in
                if success == true {
                    // username is taken
                    self.setupUsernameTextField()
                    self.checkUsernameImage.image = UIImage(named: "false")
                    self.checkUserNameLabel.text = "Benutzername ist bereits vergeben"
                    // stop timer
                    self.timer.invalidate()
                    // stop loading indicator
                    self.activityIndicator.stopAnimating()
                } else {
                    // username is not taken
                    self.checkUsernameImage.removeFromSuperview()
                    // add "correct"-image to view
                    self.setupCheckUsernameImage()
                    // stop timer
                    self.timer.invalidate()
                    // stop loading indicator
                    self.activityIndicator.stopAnimating()
                }
            }
        }else {
            self.timer.invalidate()
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    //MARK: setupViews
    func setUpViews() {
        
        view.addSubview(backgroundImage)
        view.addSubview(backButton)
        view.addSubview(confirmButton)
        view.addSubview(theLabel)
        view.addSubview(usernameView)
        usernameView.addSubview(usernameTextField)
        usernameTextField.addSubview(activityIndicator)
        
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
        
        usernameConstraint = usernameView.heightAnchor.constraint(equalToConstant: 60)
        usernameConstraint.isActive = true
        usernameView.topAnchor.constraint(equalTo: theLabel.topAnchor, constant: 60).isActive = true
        usernameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        usernameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: usernameView.topAnchor).isActive = true
        usernameTextField.leadingAnchor.constraint(equalTo: usernameView.leadingAnchor).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: usernameView.trailingAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: usernameTextField.centerYAnchor, constant: 10).isActive = true
        activityIndicator.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor, constant: -5).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 15).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        confirmButton.topAnchor.constraint(equalTo: usernameView.bottomAnchor, constant: 20).isActive = true
        confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    //MARK: setup Username
    func setupUsernameTextField(){
        usernameTextField.addSubview(checkUserNameLabel)
        checkUserNameLabel.addSubview(checkUsernameImage)
        
        checkUserNameLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10).isActive = true
        checkUserNameLabel.leadingAnchor.constraint(equalTo: checkUsernameImage.leadingAnchor, constant: 13).isActive = true

        checkUsernameImage.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor).isActive = true
        checkUsernameImage.centerYAnchor.constraint(equalTo: checkUserNameLabel.centerYAnchor).isActive = true
        checkUsernameImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        checkUsernameImage.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        usernameConstraint.constant = 80
        
        confirmButton.layoutIfNeeded()
    }
    
    //MARK: setup checkUsernameImage
    func setupCheckUsernameImage(){
        usernameCorrectImage.image = UIImage(named: "correct")
        usernameTextField.addSubview(usernameCorrectImage)
        
        usernameCorrectImage.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor,constant: -5).isActive = true
        usernameCorrectImage.centerYAnchor.constraint(equalTo: usernameTextField.centerYAnchor, constant: 10).isActive = true
        usernameCorrectImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
        usernameCorrectImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    //MARK: setup Loading-Animation
    func setupLoadingAnimation(){
       
        logoAnimation.contentMode = .scaleAspectFit
        logoAnimation.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logoAnimation)
        
        logoAnimation.centerXAnchor.constraint(equalTo: confirmButton.centerXAnchor).isActive = true
        logoAnimation.centerYAnchor.constraint(equalTo: confirmButton.centerYAnchor).isActive = true
        logoAnimation.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoAnimation.widthAnchor.constraint(equalToConstant: 50).isActive = true
        logoAnimation.loopMode = .loop
    }
    
    //MARK: Loading failed
    func loadingFailed(){
        // stop loading animation
        self.logoAnimation.stop()
        // remove animation from view
        self.logoAnimation.removeFromSuperview()
        // reset button title to "Registrieren"
        self.confirmButton.setTitle("BESTÄTIGEN", for: .normal)
        // play shake animation
        self.confirmButton.shake()
        // enable button tap
        self.confirmButton.isEnabled = true
    }
    
    //MARK: validate fields
    var isValid = true
    func validateFields(completion: @escaping (Bool) -> Void) {
        // check if username is not empty
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            setupUsernameTextField()
            isValid = false
        }
        // check if username is valid
        DataHandler.checkUsername(field: usernameTextField.text!) { success in
            if success {
                // username is taken
                self.setupUsernameTextField()
                self.checkUsernameImage.image = UIImage(named: "false")
                self.checkUserNameLabel.text = "Benutzername ist bereits vergeben"
                self.isValid = false
            }

            completion(true) // call the completion closure with the success status
        }
    }
    
    //MARK: confirmButtonTapped
    @objc func confirmButtonTapped(){
        self.view.endEditing(true)
        // disable button tap
        self.confirmButton.isEnabled = false
        // reset isValid variable
        isValid = true
        // hide the buttons title
        self.confirmButton.setTitle("", for: .normal)
        // start loading animation
        setupLoadingAnimation()
        logoAnimation.play()
        
        let username = self.usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        validateFields { completion in
            // check if validateFields method is completed
            if completion {
                if !self.isValid {
                    // textFields are not valid
                    self.loadingFailed()
                    
                }else if self.signInOption == Constants.SignInMethod.Facebook { //MARK: Facebook-Login
                    
                    guard let accessTokenString = self.accessToken?.tokenString else {
                        return
                    }
                    let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
                    
                    DataHandler.signUpWithSocial(credentials: credentials, username: username, finished: { (done) in

                        if done { // success
                            // stop animation
                            self.logoAnimation.stop()

                            //transition to home
                            self.transitionToHome()
                            
                        } else { // failure
                            self.loadingFailed()
                        }

                    })
                    
                } else if self.signInOption == Constants.SignInMethod.Google { //MARK: Google-Login
                    
                    let credentials = GoogleAuthProvider.credential(withIDToken: self.authentication!.idToken,
                                                                   accessToken: self.authentication!.accessToken)
                      
                    DataHandler.signUpWithSocial(credentials: credentials, username: username, finished: { (done) in

                        if done { // success
                            // stop animation
                            self.logoAnimation.stop()

                            //transition to home
                            self.transitionToHome()
                            
                        } else { // failure
                            self.loadingFailed()
                        }
                    })
                } else if self.signInOption == Constants.SignInMethod.Apple { //MARK: Apple-Login
                    
                    DataHandler.signUpWithSocial(credentials: self.credential, username: username, finished: { (done) in

                        if done { // success
                            // stop animation
                            self.logoAnimation.stop()

                            //transition to home
                            self.transitionToHome()
                            
                        } else { // failure
                            self.loadingFailed()
                        }
                    })
                } else if self.signInOption == Constants.SignInMethod.AppleExists {
                    
                    DataHandler.signInWithApple(username: username) { (done) in
                        if done { // success
                            // stop animation
                            self.logoAnimation.stop()

                            //transition to home
                            self.transitionToHome()
                            
                        } else { // failure
                            self.loadingFailed()
                        }
                    }
                } else if self.signInOption == Constants.SignInMethod.Email {
                    DataHandler.signUpWithEmail(email: self.email!, password: self.password!, username: username) { (done) in
                        if done { // success
                            // stop animation
                            self.logoAnimation.stop()

                            //transition to home
                            self.transitionToHome()
                            
                        } else { // failure
                            self.loadingFailed()
                        }
                    }
                }
            }
        }
    }
    
    func transitionToHome () {

        let homeViewCotnroller =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? MainViewController
        let navigationController = UINavigationController(rootViewController: homeViewCotnroller!)

        view.window?.rootViewController = navigationController
        view.window?.makeKeyAndVisible()
    }
    
    // disable "space" for every textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        return true
    }
    
    //hide keyboard, wenn user außerhalb toucht
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // done key action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            self.confirmButton.sendActions(for: .touchUpInside)
        }
        return true
    }

}
