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
import Firebase
import RevealingSplashView
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import Lottie
import GoogleSignIn
import AuthenticationServices
import CryptoKit



class FirstLaunchViewController: UIViewController, UITextFieldDelegate, GIDSignInDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    
    
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
        v.text = "Willkommen bei Wishlists."
        v.font = UIFont(name: "AvenirNext-Bold", size: 23)
        v.numberOfLines = 0
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
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
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
    
    let emailButton: CustomButton = {
        let v = CustomButton(type: .system)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Mit Email fortfahren", for: .normal)
        v.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.titleLabel?.textColor = .white
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = UIColor.darkGray
        v.layer.cornerRadius = 3
        v.addTarget(self, action: #selector(weiterButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let oderLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 13)
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
        v.addTarget(self, action: #selector(facebookButtonTapped), for: .touchUpInside)
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
        v.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
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
        v.addTarget(self, action: #selector(appleButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let appleLogo: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "apple")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    let logoAnimation = AnimationView(name: "LoadingAnimation")
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Textfield cursor -> white
        UITextField.appearance().tintColor = .white
        
        // add motion effect to background image
        Utilities.applyMotionEffect(toView: self.backgroundImage, magnitude: 20)
        
        // google sign in delegate
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        setUpViews()
        
    }
    
    //MARK: setupViews
    func setUpViews(){
        
        view.addSubview(backgroundImage)
        view.addSubview(willkommenLabel)
        view.addSubview(textLabel)
        view.addSubview(emailButton)
        emailButton.addSubview(emailImage)
        view.addSubview(oderLabel)
        view.addSubview(lineLeft)
        view.addSubview(lineRight)
        view.addSubview(facebookButton)
        facebookButton.addSubview(facebookLogo)
        view.addSubview(googleButton)
        googleButton.addSubview(googleLogo)
        view.addSubview(appleButton)
        appleButton.addSubview(appleLogo)
        
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -20).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -20).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        
        willkommenLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        willkommenLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        willkommenLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        
        textLabel.topAnchor.constraint(equalTo: willkommenLabel.bottomAnchor, constant: 30).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        emailButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        emailButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        emailButton.topAnchor.constraint(equalTo: textLabel.topAnchor, constant: 100).isActive = true
        emailButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        emailImage.centerYAnchor.constraint(equalTo: emailButton.centerYAnchor).isActive = true
        emailImage.leadingAnchor.constraint(equalTo: emailButton.leadingAnchor, constant: 10).isActive = true
        emailImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        emailImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        oderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        oderLabel.bottomAnchor.constraint(equalTo: emailButton.bottomAnchor, constant: 40).isActive = true
        oderLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        lineLeft.centerYAnchor.constraint(equalTo: oderLabel.centerYAnchor).isActive = true
        lineLeft.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        lineLeft.trailingAnchor.constraint(equalTo: oderLabel.leadingAnchor).isActive = true
        
        lineRight.centerYAnchor.constraint(equalTo: oderLabel.centerYAnchor).isActive = true
        lineRight.leadingAnchor.constraint(equalTo: oderLabel.trailingAnchor).isActive = true
        lineRight.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        facebookButton.leadingAnchor.constraint(equalTo: emailButton.leadingAnchor).isActive = true
        facebookButton.trailingAnchor.constraint(equalTo: emailButton.trailingAnchor).isActive = true
        facebookButton.bottomAnchor.constraint(equalTo: oderLabel.bottomAnchor, constant: 55 + 10).isActive = true
        facebookButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        facebookLogo.centerYAnchor.constraint(equalTo: facebookButton.centerYAnchor).isActive = true
        facebookLogo.leadingAnchor.constraint(equalTo: facebookButton.leadingAnchor, constant: 10).isActive = true
        facebookLogo.heightAnchor.constraint(equalToConstant: 25).isActive = true
        facebookLogo.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        googleButton.leadingAnchor.constraint(equalTo: emailButton.leadingAnchor).isActive = true
        googleButton.trailingAnchor.constraint(equalTo: emailButton.trailingAnchor).isActive = true
        googleButton.bottomAnchor.constraint(equalTo: facebookButton.bottomAnchor, constant: 55 + 10).isActive = true
        googleButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        googleLogo.centerYAnchor.constraint(equalTo: googleButton.centerYAnchor).isActive = true
        googleLogo.leadingAnchor.constraint(equalTo: googleButton.leadingAnchor, constant: 10).isActive = true
        googleLogo.heightAnchor.constraint(equalToConstant: 25).isActive = true
        googleLogo.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        appleButton.leadingAnchor.constraint(equalTo: emailButton.leadingAnchor).isActive = true
        appleButton.trailingAnchor.constraint(equalTo: emailButton.trailingAnchor).isActive = true
        appleButton.bottomAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 55 + 10).isActive = true
        appleButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        appleLogo.centerYAnchor.constraint(equalTo: appleButton.centerYAnchor).isActive = true
        appleLogo.leadingAnchor.constraint(equalTo: appleButton.leadingAnchor, constant: 10).isActive = true
        appleLogo.heightAnchor.constraint(equalToConstant: 25).isActive = true
        appleLogo.widthAnchor.constraint(equalToConstant: 25).isActive = true
 
    }
    
    
    @objc func weiterButtonTapped() {
        
        let emailVC = self.storyboard?.instantiateViewController(withIdentifier: "EmailVC") as! EmailViewController
        
        let weiterButtonID = "weiterButtonID"
        self.emailButton.heroID = weiterButtonID
        
        emailVC.weiterButton.heroID = weiterButtonID
        
        self.navigationController?.pushViewController(emailVC, animated: true)

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
    
    //MARK: setup Loading-Animation
    func setupLoadingAnimation(button: UIButton){
       
        logoAnimation.contentMode = .scaleAspectFit
        logoAnimation.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logoAnimation)
        
        logoAnimation.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        logoAnimation.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        logoAnimation.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoAnimation.widthAnchor.constraint(equalToConstant: 50).isActive = true
        logoAnimation.loopMode = .loop
    }
    
    //MARK: resetButton
    func resetButton(button: UIButton, buttonTitle: String){
        // stop loading animation
        self.logoAnimation.stop()
        // remove animation from view
        self.logoAnimation.removeFromSuperview()
        // reset button title to "Registrieren"
        button.setTitle(buttonTitle, for: .normal)
        // play shake animation
        button.shake()
        // enable button tap
        button.isEnabled = true
    }
    
    //MARK: Facebook Login
    @objc func facebookButtonTapped(){

        // disable button tap
        self.facebookButton.isEnabled = false
        // hide the buttons title
        self.facebookButton.setTitle("", for: .normal)
        // start loading animation
        setupLoadingAnimation(button: self.facebookButton)
        logoAnimation.play()
        
        
        
        LoginManager().logIn(permissions: ["email", "public_profile"], from: self) { (result, error) in
            
            let accessToken = AccessToken.current

            guard let accessTokenString = accessToken?.tokenString else {
                Utilities.showErrorPopUp(labelContent: "Fehler beim Facebook-Login", description: accessToken.debugDescription)
                return
            }

            let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
            
            if error != nil {
                
                self.resetButton(button: self.facebookButton, buttonTitle: "Mit Facebook fortfahren")
                // some FB error
                Utilities.showErrorPopUp(labelContent: "Fehler beim Facebook-Login", description: error!.localizedDescription)
                return
                
            }else if result?.isCancelled == true {
                
                self.resetButton(button: self.facebookButton, buttonTitle: "Mit Facebook fortfahren")
                
            }else {
                // successfull FB-Login
                GraphRequest(graphPath: "/me", parameters: ["fields": "id, email, name"]).start { (connection, result, error) in
                    print(result!)
                    if error != nil {
                        
                        self.resetButton(button: self.facebookButton, buttonTitle: "Mit Facebook fortfahren")

                        // some FB error
                        Utilities.showErrorPopUp(labelContent: "Fehler beim Facebook-Login", description: error!.localizedDescription)
                    }else {
                        print(result!)
                        // check if user has account
                        guard let Info = result as? [String: Any] else { return }

                        let email = Info["email"] as? String
                        
                        print(email!)
                           
                        Auth.auth().fetchSignInMethods(forEmail: email!) { (methods, error) in
                            
                            if error != nil {
                               self.resetButton(button: self.facebookButton, buttonTitle: "Mit Facebook fortfahren")
                                // show error popUp
                                Utilities.showErrorPopUp(labelContent: "Fehler", description: error!.localizedDescription)
                            } else {
                                // no error -> check email adress
                                                                                    
                                // Email ist noch nicht registriert -> sign up
                                if methods == nil {
                                    
                                    let usernameVC = self.storyboard?.instantiateViewController(withIdentifier: "UsernameVC") as! UserNameVC
                                    usernameVC.accessToken = accessToken
                                    usernameVC.signInOption = "facebook"
                                    self.resetButton(button: self.facebookButton, buttonTitle: "Mit Facebook fortfahren")
                                    self.navigationController?.pushViewController(usernameVC, animated: true)
                                    
                                }
                                // Email is registered -> login
                                else {
                                    
                                    Auth.auth().signIn(with: credentials, completion: { (user, error) in
                                        if error != nil {
                                            self.resetButton(button: self.facebookButton, buttonTitle: "Mit Facebook fortfahren")
                                            Utilities.showErrorPopUp(labelContent: "Fehler beim Login", description: error!.localizedDescription)
                                        } else {
                                            
                                            // set user status to logged-in
                                            UserDefaults.standard.setIsLoggedIn(value: true)
                                            UserDefaults.standard.synchronize()

                                            //transition to home
                                            self.transitionToHome()
                                        }
                                    })
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: Google-Login
    @objc func googleButtonTapped(){
        // disable button tap
        self.googleButton.isEnabled = false
        // hide the buttons title
        self.googleButton.setTitle("", for: .normal)
        // start loading animation
        setupLoadingAnimation(button: self.googleButton)
        logoAnimation.play()
        // call sign-method
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {

            self.resetButton(button: self.googleButton, buttonTitle: "Mit Google fortfahren")
            
            Utilities.showErrorPopUp(labelContent: "Fehler", description: err.localizedDescription)
            
        }else {
            guard let authentication = user.authentication else { return }

            guard let email = user.profile.email else { return }
            
            Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
                         
                 if error != nil {
                    // reset button
                    self.resetButton(button: self.googleButton, buttonTitle: "Mit Google fortfahren")
                     // show error popUp
                     Utilities.showErrorPopUp(labelContent: "Fehler", description: error!.localizedDescription)
                    
                 } else {
                     // no error -> check email adress
                     
                     // Email ist noch nicht registriert -> sign up
                     if methods == nil {
                         
                        let usernameVC = self.storyboard?.instantiateViewController(withIdentifier: "UsernameVC") as! UserNameVC
                        usernameVC.authentication = authentication
                        usernameVC.signInOption = "google"
                            
                        self.resetButton(button: self.googleButton, buttonTitle: "Mit Google fortfahren")
                        
                        self.navigationController?.pushViewController(usernameVC, animated: true)
                         
                     }
                     // Email ist registriert -> login
                     else {
                    
                        let credentials = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                                        accessToken: authentication.accessToken)
                        
                        Auth.auth().signIn(with: credentials, completion: { (user, error) in
                            if error != nil {
                                self.resetButton(button: self.googleButton, buttonTitle: "Mit Google fortfahren")
                                Utilities.showErrorPopUp(labelContent: "Fehler beim Login", description: error!.localizedDescription)
                            } else {
                                
                                // set user status to logged-in
                                UserDefaults.standard.setIsLoggedIn(value: true)
                                UserDefaults.standard.synchronize()

                                //transition to home
                                self.transitionToHome()
                            }
                        })
                     }
                 }
            }
        }
    }
    
//MARK: Apple-Login

    @objc func appleButtonTapped(){
        startSignInWithAppleFlow()
    }
    
    // Unhashed nonce.
    var currentNonce: String?
    
    // delegate functions
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
      if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        guard let nonce = currentNonce else {
          fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
          print("Unable to fetch identity token")
          return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
          return
        }

        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
//        print("email: " + appleIDCredential.email!)
        let email = appleIDCredential.email
        
        Auth.auth().fetchSignInMethods(forEmail: email!) { (methods, error) in
                     
             if error != nil {
                // reset button
                self.resetButton(button: self.appleButton, buttonTitle: "Mit Apple fortfahren")
                 // show error popUp
                Utilities.showErrorPopUp(labelContent: "Fehler", description: error!.localizedDescription)
             } else {
                 // no error -> check email adress
                                     
                 // stop loading animation
                 self.logoAnimation.stop()
                 // remove animation from view
                 self.logoAnimation.removeFromSuperview()
                 // reset button title to "Registrieren"
                 self.appleButton.setTitle("Mit Apple fortfahren", for: .normal)
                 // enable button tap
                 self.appleButton.isEnabled = true
                 
                 // Email not registered -> sign up
                 if methods == nil {
                     
                     print("signed in")
                     let usernameVC = self.storyboard?.instantiateViewController(withIdentifier: "UsernameVC") as! UserNameVC
                     usernameVC.credential = credential
                     usernameVC.signInOption = "apple"
                     self.navigationController?.pushViewController(usernameVC, animated: true)
                     
                 } else { // Email not registered -> Login
                    
                    Auth.auth().signIn(with: credential, completion: { (user, error) in
                        if error != nil {
                            Utilities.showErrorPopUp(labelContent: "Fehler beim Login", description: error!.localizedDescription)
                        } else {
                            
                            // set user status to logged-in
                            UserDefaults.standard.setIsLoggedIn(value: true)
                            UserDefaults.standard.synchronize()
                            
                            // stop animation
                            self.logoAnimation.stop()

                            //transition to home
                            self.transitionToHome()
                        }
                    })
                }
            }
         }
      }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
      // Handle error.
      print("Sign in with Apple errored: \(error)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }



    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    @available(iOS 13, *)
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
    
    
//MARK: TransitionToHome
    func transitionToHome () {

        let homeVC =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? MainViewController
        let navigationController = UINavigationController(rootViewController: homeVC!)

        view.window?.rootViewController = navigationController
        view.window?.makeKeyAndVisible()
    }
}

