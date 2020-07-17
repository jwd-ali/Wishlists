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
//        v.minimumScaleFactor = 0.5
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
        v.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
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
    
    //MARK: Documents
    let documentsLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let logoAnimation = AnimationView(name: "LoadingAnimation")
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // google sign in delegate
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        setupViewsDon()
        
        setUpDocumentsLabel()
        
        if let defaults = UserDefaults(suiteName: UserDefaults.Keys.groupKey) {
            print(defaults.isLoggedIn())
            defaults.synchronize()
        } else {
            print("error Main")
        }
        
    }
    
    func setupViewsDon(){

        // setting these properties here, so I don't have to change your original initialization
        willkommenLabel.numberOfLines = 1
        willkommenLabel.adjustsFontSizeToFitWidth = true
        willkommenLabel.minimumScaleFactor = 0.5

        textLabel.numberOfLines = 2
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.5

        // prevent willkommenLabel from being compressed or streched
        willkommenLabel.setContentHuggingPriority(.required, for: .vertical)
        willkommenLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        // prevent oderLabel from being compressed or streched
        oderLabel.setContentHuggingPriority(.required, for: .vertical)
        oderLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        // prevent documentsLabel from being compressed or streched
        documentsLabel.setContentHuggingPriority(.required, for: .vertical)
        documentsLabel.setContentCompressionResistancePriority(.required, for: .vertical)

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
        view.addSubview(documentsLabel)

        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -20).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -20).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true

        // add a layout guide for percentage top spacing
        let topSpaceGuide = UILayoutGuide()
        view.addLayoutGuide(topSpaceGuide)

        // based on iPhone 8 ... 80-pts from top
        // will be shorter on smaller devices, taller on larger devices
        topSpaceGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topSpaceGuide.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 80.0 / 667.0).isActive = true

        willkommenLabel.topAnchor.constraint(equalTo: topSpaceGuide.bottomAnchor).isActive = true
        willkommenLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        willkommenLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true

        // textLabel top constrained to willkommenLabel bottom
        textLabel.topAnchor.constraint(equalTo: willkommenLabel.bottomAnchor, constant: 0).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true

        // textLabel height = a percentage of view height using 100-pts based on an iPhone 8
        //  priority = .defaultHigh so it can be compressed if needed (on smaller devices)
        let c = textLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 100.0 / 667.0)
        c.priority = .defaultHigh
        c.isActive = true

        // set email button height
        emailButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        // set other button heights equal to emailButton
        facebookButton.heightAnchor.constraint(equalTo: emailButton.heightAnchor).isActive = true
        googleButton.heightAnchor.constraint(equalTo: emailButton.heightAnchor).isActive = true
        appleButton.heightAnchor.constraint(equalTo: emailButton.heightAnchor).isActive = true

        // add the logo images to the buttons, and make their heights relative to button heights
        //      in case you want to change the button heights

        for (btn, img) in [(emailButton, emailImage), (facebookButton, facebookLogo), (googleButton, googleLogo), (appleButton, appleLogo)] {
            btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
            btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
            btn.addSubview(img)
            img.centerYAnchor.constraint(equalTo: btn.centerYAnchor).isActive = true
            img.leadingAnchor.constraint(equalTo: btn.leadingAnchor, constant: 10).isActive = true
            img.heightAnchor.constraint(equalTo: btn.heightAnchor, multiplier: 0.5).isActive = true
            img.widthAnchor.constraint(equalTo: img.heightAnchor).isActive = true
        }

        emailButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 20).isActive = true
        oderLabel.topAnchor.constraint(equalTo: emailButton.bottomAnchor, constant: 15).isActive = true
        facebookButton.topAnchor.constraint(equalTo: oderLabel.bottomAnchor, constant: 15).isActive = true
        googleButton.topAnchor.constraint(equalTo: facebookButton.bottomAnchor, constant: 10).isActive = true
        appleButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 10).isActive = true

        // make sure appleButton stays above documentsLabel
        appleButton.bottomAnchor.constraint(lessThanOrEqualTo: documentsLabel.topAnchor, constant: -20.0).isActive = true

        // horizontal arrangement of oderLabel and left/right lines
        oderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        oderLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true

        lineLeft.centerYAnchor.constraint(equalTo: oderLabel.centerYAnchor).isActive = true
        lineLeft.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        lineLeft.trailingAnchor.constraint(equalTo: oderLabel.leadingAnchor).isActive = true

        lineRight.centerYAnchor.constraint(equalTo: oderLabel.centerYAnchor).isActive = true
        lineRight.leadingAnchor.constraint(equalTo: oderLabel.trailingAnchor).isActive = true
        lineRight.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true

        // documentsLabel stay at bottom
        documentsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        documentsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        documentsLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true

    }
    
    //MARK: DocumentsLabel
    struct Fonts {
        
        static func boldFontWithSize(size: CGFloat) -> UIFont {
            return UIFont(name:"AvenirNext-Bold", size: size)!
        }
        
        static func regularFontWithSize(size: CGFloat) -> UIFont {
            return UIFont(name:"AvenirNext-Regular", size: size)!
        }
    }

    struct Colors {
        
        static let white = UIColor.white

    }
    
    func setUpDocumentsLabel(){
        var textArray = [String]()
        var fontArray = [UIFont]()
        var colorArray = [UIColor]()
        textArray.append("Mit 'fortfahren' akzeptierst du die")
        textArray.append("Nutzungsbedingungen")
        textArray.append("und")
        textArray.append("Datenschutzrichtlinien.")
        
        fontArray.append(Fonts.regularFontWithSize(size: 13.0))
        fontArray.append(Fonts.boldFontWithSize(size: 13.0))
        fontArray.append(Fonts.regularFontWithSize(size: 13.0))
        fontArray.append(Fonts.boldFontWithSize(size: 13.0))
        
        colorArray.append(Colors.white)
        colorArray.append(Colors.white)
        colorArray.append(Colors.white)
        colorArray.append(Colors.white)
        
        self.documentsLabel.attributedText = getAttributedString(arrayText: textArray, arrayColors: colorArray, arrayFonts: fontArray)
        
        self.documentsLabel.isUserInteractionEnabled = true
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        tapgesture.numberOfTapsRequired = 1
        self.documentsLabel.addGestureRecognizer(tapgesture)
    }
    
    //MARK:- tappedOnLabel
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = self.documentsLabel.text else { return }
        let nutzen = (text as NSString).range(of: "Nutzungsbedingungen")
        let daten = (text as NSString).range(of: "Datenschutzrichtlinien")
        
        if gesture.didTapAttributedTextInLabel(label: self.documentsLabel, inRange: nutzen) {
            
            let alertcontroller = UIAlertController(title: "Tapped on", message: "user tapped on Nutzungsbedingungen", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default) { (alert) in
                
            }
            alertcontroller.addAction(alertAction)
            self.present(alertcontroller, animated: true)
            
        } else if gesture.didTapAttributedTextInLabel(label: self.documentsLabel, inRange: daten){
            
            let alertcontroller = UIAlertController(title: "Tapped on", message: "user tapped on Datenschutzrichtlinien", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default) { (alert) in
                
            }
            alertcontroller.addAction(alertAction)
            self.present(alertcontroller, animated: true)

        }
    }
    
    //MARK:- getAttributedString
    func getAttributedString(arrayText:[String]?, arrayColors:[UIColor]?, arrayFonts:[UIFont]?) -> NSMutableAttributedString {

        let finalAttributedString = NSMutableAttributedString()

        for i in 0 ..< (arrayText?.count)! {

            let attributes = [NSAttributedString.Key.foregroundColor: arrayColors?[i], NSAttributedString.Key.font: arrayFonts?[i]]
            let attributedStr = (NSAttributedString.init(string: arrayText?[i] ?? "", attributes: attributes as [NSAttributedString.Key : Any]))

            if i != 0 {

                finalAttributedString.append(NSAttributedString.init(string: " "))
            }

            finalAttributedString.append(attributedStr)
        }

        // add paragraph attribute
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.paragraphStyle: paragraph]
        finalAttributedString.addAttributes(attributes, range: NSRange(location: 0, length: finalAttributedString.length))

        return finalAttributedString
    }
    
    
    @objc func emailButtonTapped() {
        
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
                
            if error != nil {
                self.resetButton(button: self.facebookButton, buttonTitle: "Mit Facebook fortfahren")
                // some FB error
                Utilities.showErrorPopUp(labelContent: "Fehler beim Facebook-Login", description: error!.localizedDescription)
                return
                
            }else if result?.isCancelled == true {
                
                self.resetButton(button: self.facebookButton, buttonTitle: "Mit Facebook fortfahren")
                
            }else {
                let accessToken = AccessToken.current

                guard let accessTokenString = accessToken?.tokenString else {
                    self.resetButton(button: self.facebookButton, buttonTitle: "Mit Facebook fortfahren")
                    Utilities.showErrorPopUp(labelContent: "Fehler beim Facebook-Login", description: accessToken.debugDescription)
                    return
                }

                let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
                // successfull FB-Login
                GraphRequest(graphPath: "/me", parameters: ["fields": "id, email, name"]).start { (connection, result, error) in
                    if error != nil {
                        
                        self.resetButton(button: self.facebookButton, buttonTitle: "Mit Facebook fortfahren")

                        // some FB error
                        Utilities.showErrorPopUp(labelContent: "Fehler beim Facebook-Login", description: error!.localizedDescription)
                        
                    }else {
                        
                        // get user Info
                        guard let Info = result as? [String: Any] else {
                            self.resetButton(button: self.facebookButton, buttonTitle: "Mit Facebook fortfahren")
                            Utilities.showErrorPopUp(labelContent: "Fehler beim Facebook-Login", description: result.debugDescription)
                            return
                            
                        }

                        let email = Info["email"] as? String
                         // check if user has account
                        Auth.auth().fetchSignInMethods(forEmail: email!) { (methods, error) in
                            
                            if error != nil {
                               self.resetButton(button: self.facebookButton, buttonTitle: "Mit Facebook fortfahren")
                                // show error popUp
                                Utilities.showErrorPopUp(labelContent: "Fehler", description: error!.localizedDescription)
                            } else {
                                                                                    
                                // Email ist noch nicht registriert -> sign up
                                if methods == nil {
                                    
                                    let usernameVC = self.storyboard?.instantiateViewController(withIdentifier: "UsernameVC") as! UserNameVC
                                    usernameVC.accessToken = accessToken
                                    usernameVC.signInOption = Constants.SignInMethod.Facebook
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
                                            let uid = Auth.auth().currentUser!.uid
                                            // set user status to logged-in
                                            if let defaults = UserDefaults(suiteName: UserDefaults.Keys.groupKey) {
                                                defaults.setIsLoggedIn(value: true)
                                                defaults.setUid(uid: uid)
                                                defaults.synchronize()
                                            }
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
            
            Utilities.showErrorPopUp(labelContent: "Fehler beim Google-Login", description: err.localizedDescription)
            
        }else {
            guard let authentication = user.authentication else { return }

            guard let email = user.profile.email else { return }
            
            Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
                         
                 if error != nil {
                    // reset button
                    self.resetButton(button: self.googleButton, buttonTitle: "Mit Google fortfahren")
                     // show error popUp
                     Utilities.showErrorPopUp(labelContent: "Fehler beim Google-Login", description: error!.localizedDescription)
                    
                 } else {
                     // no error -> check email adress
                     
                     // Email ist noch nicht registriert -> sign up
                     if methods == nil {
                         
                        let usernameVC = self.storyboard?.instantiateViewController(withIdentifier: "UsernameVC") as! UserNameVC
                        usernameVC.authentication = authentication
                        usernameVC.signInOption = Constants.SignInMethod.Google
                            
                        // stop loading animation
                        self.logoAnimation.stop()
                        // remove animation from view
                        self.logoAnimation.removeFromSuperview()
                        // reset button title to "Registrieren"
                        self.googleButton.setTitle("Mit Google fortfahren", for: .normal)
                        // enable button tap
                        self.googleButton.isEnabled = true
                        
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
                               let uid = Auth.auth().currentUser!.uid
                                // set user status to logged-in
                                if let defaults = UserDefaults(suiteName: UserDefaults.Keys.groupKey) {
                                    defaults.setIsLoggedIn(value: true)
                                    defaults.setUid(uid: uid)
                                    defaults.synchronize()
                                }

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
        // disable button tap
        self.appleButton.isEnabled = false
        // hide the buttons title
        self.appleButton.setTitle("", for: .normal)
        // start loading animation
        setupLoadingAnimation(button: self.appleButton)
        logoAnimation.play()
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

        guard appleIDCredential.email != nil else {
            // User already signed in with this appleId once
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                
                DataHandler.checkIfAppleUserExists(uid: (user?.user.uid)!) { (exists) in
                    if exists { // user has firebase-profile -> login
                        if error != nil {
                            self.resetButton(button: self.appleButton, buttonTitle: "Mit Google fortfahren")
                            // show error popUp
                            Utilities.showErrorPopUp(labelContent: "Fehler beim Apple-Login", description: error!.localizedDescription)
                        } else {
                            
                            let uid = Auth.auth().currentUser!.uid
                            // set user status to logged-in
                            if let defaults = UserDefaults(suiteName: UserDefaults.Keys.groupKey) {
                                defaults.setIsLoggedIn(value: true)
                                defaults.setUid(uid: uid)
                                defaults.synchronize()
                            }

                            self.transitionToHome()
                        }
                    } else { // user doesn't have firebase-profile -> create username

                        self.logoAnimation.stop()
                        self.logoAnimation.removeFromSuperview()
                        self.appleButton.setTitle("Mit Apple fortfahren", for: .normal)
                        self.appleButton.isEnabled = true
                        
                        let usernameVC = self.storyboard?.instantiateViewController(withIdentifier: "UsernameVC") as! UserNameVC
                        usernameVC.credential = credential
                        usernameVC.signInOption = Constants.SignInMethod.AppleExists
                        self.navigationController?.pushViewController(usernameVC, animated: true)
                    }
                }
        
            })
            return
        }
        
        self.logoAnimation.stop()
        self.logoAnimation.removeFromSuperview()
        self.appleButton.setTitle("Mit Apple fortfahren", for: .normal)
        self.appleButton.isEnabled = true
        
        // first time apple sign in
        let usernameVC = self.storyboard?.instantiateViewController(withIdentifier: "UsernameVC") as! UserNameVC
        usernameVC.credential = credential
        usernameVC.signInOption = Constants.SignInMethod.Apple
        self.navigationController?.pushViewController(usernameVC, animated: true)
      }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        self.resetButton(button: self.appleButton, buttonTitle: "Mit Apple fortfahren")
        // show error popUp
        Utilities.showErrorPopUp(labelContent: "Fehler beim Apple-Login", description: error.localizedDescription)

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

