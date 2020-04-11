//
//  SignUpViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 22.08.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import SwiftEntryKit
import Lottie
import TextFieldEffects

class SignUpViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
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
        v.text = "Konto erstellen"
        v.font = UIFont(name: "AvenirNext-Bold", size: 23)
        v.textAlignment = .left
        v.textColor = .white
        v.adjustsFontSizeToFitWidth = true
        v.minimumScaleFactor = 0.5
        v.numberOfLines = 0
        return v
    }()
    
    let theScrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .red
        return v
    }()
    
    var scrollBottomViewConstraint: NSLayoutConstraint!
    
    let theStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.alignment = .fill
        v.distribution = .equalSpacing
        v.spacing = 30
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var stackViewBottomConstraint: NSLayoutConstraint!
    
    //MARK: Email
    
    var emailConstraint:NSLayoutConstraint!
    
    let emailView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let emailTextField: HoshiTextField = {
        let v = HoshiTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.tintColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Email-Adresse"
        v.placeholderColor = .white
        v.placeholderFontScale = 0.8
        v.minimumFontSize = 13
        v.borderStyle = .line
        v.autocapitalizationType = .none
        v.textContentType = .emailAddress
        v.keyboardType = .emailAddress
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(textFieldDidChange(_:)),for: .editingChanged)
        return v
    }()
    
    lazy var checkEmailImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "false")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var checkEmailLabel: UILabel = {
        let v = UILabel()
        v.text = "ungültige Email-Adresse"
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 13)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //MARK: Password
    
    var passwordConstraint:NSLayoutConstraint!
    
    let passwordView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let passwordTextField: HoshiTextField = {
        let v = HoshiTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.tintColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Passwort"
        v.placeholderColor = .white
        v.placeholderFontScale = 0.8
        v.minimumFontSize = 13
        v.borderStyle = .line
        v.addTarget(self, action: #selector(textFieldDidChange(_:)),for: .editingChanged)
        v.translatesAutoresizingMaskIntoConstraints = false
//        v.textContentType = .newPassword
        v.keyboardType = .default
        return v
    }()
    
    let eyeButtonOne: UIButton = {
        let v = UIButton()
        v.addTarget(self, action: #selector(eyeButtonOneTapped), for: .touchUpInside)
        v.setImage(UIImage(named: "eyeOpen"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentHorizontalAlignment = .fill
        v.contentVerticalAlignment = .fill
        v.imageView?.contentMode = .scaleAspectFit
        return v
    }()
    
    lazy var checkLetterImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "false")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var checkNumberImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "false")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var checkLengthImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "false")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var checkLetterLabel: UILabel = {
        let v = UILabel()
        v.text = "mindestens ein Groß- und Kleinbuchstaben"
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 13)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var checkNumberLabel: UILabel = {
        let v = UILabel()
        v.text = "mindestens eine Zahl"
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 13)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var checkLengthLabel: UILabel = {
        let v = UILabel()
        v.text = "mindestens acht Zeichen lang"
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 13)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //MARK: Password wiederholen
    
    var passwordWiederholenConstraint:NSLayoutConstraint!
    
    let passwordWiederholenView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let passwordWiederholenTextField: HoshiTextField = {
        let v = HoshiTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.tintColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Passwort wiederholen"
        v.placeholderColor = .white
        v.placeholderFontScale = 0.8
        v.minimumFontSize = 13
        v.borderStyle = .line
        v.addTarget(self, action: #selector(textFieldDidChange(_:)),for: .editingChanged)
        v.translatesAutoresizingMaskIntoConstraints = false
//        v.textContentType = .newPassword
        v.keyboardType = .default
        return v
    }()
    
    let eyeButtonTwo: UIButton = {
        let v = UIButton()
        v.addTarget(self, action: #selector(eyeButtonTwoTapped), for: .touchUpInside)
        v.setImage(UIImage(named: "eyeOpen"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentHorizontalAlignment = .fill
        v.contentVerticalAlignment = .fill
        v.imageView?.contentMode = .scaleAspectFit
        return v
    }()
    
    lazy var checkMatchImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "false")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var checkMatchLabel: UILabel = {
        let v = UILabel()
        v.text = "Passwörter stimmen nicht überein"
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 13)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //MARK: BackButton
    let backButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named:"backButton"), for: .normal)
        v.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return v
    }()
    
    //MARK: SignUp Button
    let signUpButton: CustomButton = {
        let v = CustomButton(type: .system)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Registrieren", for: .normal)
        v.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.titleLabel?.textColor = .white
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = UIColor.darkGray
        v.layer.cornerRadius = 3
        v.addTarget(self, action: #selector(signUpButtonTapped(_:)), for: .touchUpInside)
        return v
    }()
    
    var signUpButtonConstraint: NSLayoutConstraint!
    
    let logoAnimation = AnimationView(name: "LoadingAnimation")
    
    let signUpButtonView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // pass email from EmailVC
    var email = ""
    
    var counter = 0
    // timer for username activity indicator
    var timer = Timer()
    
    //MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eyeButtonOne.isHidden = true
        self.eyeButtonTwo.isHidden = true
        
        //password hide/show
        passwordTextField.isSecureTextEntry.toggle()
        
        //password hide/show
        passwordWiederholenTextField.isSecureTextEntry.toggle()
        
        //change return key
//        usernameTextField.returnKeyType = .next
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .next
        passwordWiederholenTextField.returnKeyType = .done
        
        // set delegates
        emailTextField.delegate = self
//        anzeigeNameTextField.delegate = self
//        usernameTextField.delegate = self
        passwordTextField.delegate = self
        passwordWiederholenTextField.delegate = self

//        // set bottom inset for ScrollView
//        theScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        
        setUpViews()
        
        self.emailTextField.text = email
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    var keyboardHeight: CGFloat?
    //MARK: keyboardObserver
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
            
            if self.passwordWiederholenTextField.isEditing {
                scrollBottomViewConstraint.constant = -(self.keyboardHeight!)
                self.theScrollView.setContentOffset(CGPoint(x: 0, y: 20), animated: true)
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
            
            if self.passwordWiederholenTextField.isEditing {
                scrollBottomViewConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
            
        }
    }
        
    //MARK: setupViews
    func setUpViews() {
        
        view.addSubview(backgroundImage)
        view.addSubview(backButton)
        view.addSubview(theScrollView)
        view.addSubview(theLabel)
        theScrollView.addSubview(theStackView)
        
        theStackView.addArrangedSubview(emailView)
        emailView.addSubview(emailTextField)
        
//        theStackView.addArrangedSubview(usernameView)
//        usernameView.addSubview(usernameTextField)
//        usernameTextField.addSubview(activityIndicator)
        
        theStackView.addArrangedSubview(passwordView)
        passwordView.addSubview(passwordTextField)
        passwordView.addSubview(eyeButtonOne)
        
        theStackView.addArrangedSubview(passwordWiederholenView)
        passwordWiederholenView.addSubview(passwordWiederholenTextField)
        passwordWiederholenView.addSubview(eyeButtonTwo)
        
        theStackView.addArrangedSubview(signUpButtonView)
        signUpButtonView.addSubview(signUpButton)
        
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
        
        theScrollView.topAnchor.constraint(equalTo: theLabel.bottomAnchor, constant: 20).isActive = true
        theScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        theScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        scrollBottomViewConstraint = theScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        scrollBottomViewConstraint.isActive = true
        
        theStackView.topAnchor.constraint(equalTo: theScrollView.topAnchor).isActive = true
        theStackView.leadingAnchor.constraint(equalTo: theScrollView.leadingAnchor).isActive = true
        theStackView.trailingAnchor.constraint(equalTo: theScrollView.trailingAnchor).isActive = true
        theStackView.widthAnchor.constraint(equalTo: theScrollView.widthAnchor).isActive = true
        stackViewBottomConstraint = theStackView.bottomAnchor.constraint(equalTo: theScrollView.bottomAnchor)
        stackViewBottomConstraint.isActive = true
        
        emailConstraint = emailView.heightAnchor.constraint(equalToConstant: 60)
        emailConstraint.isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        emailTextField.topAnchor.constraint(equalTo: emailView.topAnchor).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: emailView.leadingAnchor).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: emailView.trailingAnchor).isActive = true
        
        passwordConstraint = passwordView.heightAnchor.constraint(equalToConstant: 60)
        passwordConstraint.isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: passwordView.topAnchor).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: passwordView.leadingAnchor).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: passwordView.trailingAnchor).isActive = true
        eyeButtonOne.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -5).isActive = true
        eyeButtonOne.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor, constant: 10).isActive = true
        eyeButtonOne.heightAnchor.constraint(equalToConstant: 25).isActive = true
        eyeButtonOne.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        passwordWiederholenConstraint = passwordWiederholenView.heightAnchor.constraint(equalToConstant: 60)
        passwordWiederholenConstraint.isActive = true
        passwordWiederholenTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        passwordWiederholenTextField.topAnchor.constraint(equalTo: passwordWiederholenView.topAnchor).isActive = true
        passwordWiederholenTextField.leadingAnchor.constraint(equalTo: passwordWiederholenView.leadingAnchor).isActive = true
        passwordWiederholenTextField.trailingAnchor.constraint(equalTo: passwordWiederholenView.trailingAnchor).isActive = true
        eyeButtonTwo.trailingAnchor.constraint(equalTo: passwordWiederholenTextField.trailingAnchor, constant: -5).isActive = true
        eyeButtonTwo.centerYAnchor.constraint(equalTo: passwordWiederholenTextField.centerYAnchor, constant: 10).isActive = true
        eyeButtonTwo.heightAnchor.constraint(equalToConstant: 25).isActive = true
        eyeButtonTwo.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        signUpButtonConstraint = signUpButtonView.heightAnchor.constraint(equalToConstant: 60)
        signUpButtonConstraint.isActive = true
        signUpButton.centerYAnchor.constraint(equalTo: signUpButtonView.centerYAnchor).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: signUpButtonView.centerXAnchor).isActive = true
        signUpButton.leadingAnchor.constraint(equalTo: signUpButtonView.leadingAnchor).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: signUpButtonView.trailingAnchor).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }
    //MARK: validate fields
    var isValid = true
    func validateFields(completion: @escaping (Bool) -> Void) {
        
        self.isValid = true
        
        //check if all fields are filled
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            setupEmailTextField()
            isValid = false
        }
        
        if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            setupPasswortTextfield()
            isValid = false
        }
        if passwordWiederholenTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            setupPasswortWiederholenTextfield()
            isValid = false
        }
         
        // check if email format is correct
        if !Utilities.isValidEmail(emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) {
            setupEmailTextField()
            isValid = false
        }
        
        
         // check if password is valid
         if !Utilities.isPasswordValid(passwordTextField.text!) {
             setupPasswortTextfield()
             isValid = false
         }
          
        //check if both passwords are the same
        if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) !=
            passwordWiederholenTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            setupPasswortWiederholenTextfield()
            isValid = false
        }
        
        Auth.auth().fetchSignInMethods(forEmail: emailTextField.text!) { (methods, error) in
                
            if error != nil {
                self.isValid = false
            } else {
                
                if methods == nil {
                    // Email not registered
                }
                // Email registered
                else {
                    Utilities.showErrorPopUp(labelContent: "Fehler bei Registrierung", description: "Es existiert bereits ein Konto, das mit dieser Email verbunden ist.")
                    self.setupEmailTextField()
                    self.isValid = false
                }
            }
            completion(true)
        }
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

        let title = EKProperty.LabelContent(text: "Fehler bei Kontoerstellung", style: .init(font: UIFont(name: "AvenirNext-Bold", size: 15)!, color: EKColor(UIColor.darkGray)))
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
        
        logoAnimation.centerXAnchor.constraint(equalTo: signUpButton.centerXAnchor).isActive = true
        logoAnimation.centerYAnchor.constraint(equalTo: signUpButton.centerYAnchor).isActive = true
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
        self.signUpButton.setTitle("Registrieren", for: .normal)
        // play shake animation
        self.signUpButton.shake()
        // enable button tap
        self.signUpButton.isEnabled = true
    }
    
    //MARK: SignUp-Tappped
    @objc func signUpButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        // disable button tap
        self.signUpButton.isEnabled = false
        // reset isValid variable
        isValid = true
        // hide the buttons title
        self.signUpButton.setTitle("", for: .normal)
        // start loading animation
        setupLoadingAnimation()
        logoAnimation.play()

        validateFields { completion in

            // check if validateFields method is completed
            if completion {
                if !self.isValid {
                    // textFields are not valid
                    self.loadingFailed()
                    self.theScrollView.scrollToTop()

                }else {
                    // correct textfield input
  
                    let email = self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//                    let username = self.usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let password = self.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    self.logoAnimation.stop()
                    self.logoAnimation.removeFromSuperview()
                    self.signUpButton.setTitle("Registrieren", for: .normal)
                    self.signUpButton.isEnabled = true
                    let usernameVC = self.storyboard?.instantiateViewController(withIdentifier: "UsernameVC") as! UserNameVC
                    usernameVC.email = email
                    usernameVC.password = password
                    usernameVC.signInOption = Constants.SignInMethod.AppleExists
                    usernameVC.signInOption = Constants.SignInMethod.Email
                    self.navigationController?.pushViewController(usernameVC, animated: true)
                    
                }
            }
        }
    }
    
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    func transitionToHome () {

        let homeViewCotnroller =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? MainViewController
        let navigationController = UINavigationController(rootViewController: homeViewCotnroller!)

        view.window?.rootViewController = navigationController
        view.window?.makeKeyAndVisible()
    }
    
    //hide keyboard, wenn user außerhalb toucht
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    //automatisch Fokus auf nächstes Textfield setzen, wenn User auf "return" klickt
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField {
            passwordWiederholenTextField.becomeFirstResponder()
        }else if textField == passwordWiederholenTextField {
            passwordWiederholenTextField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: setup Password
    func setupPasswortTextfield(){
        eyeButtonOne.isHidden = false
        passwordTextField.borderInactiveColor = .white
        passwordTextField.borderActiveColor = .white
        
        passwordTextField.addSubview(checkLetterLabel)
        checkLetterLabel.addSubview(checkLetterImage)
        
        passwordTextField.addSubview(checkNumberLabel)
        checkNumberLabel.addSubview(checkNumberImage)
        
        passwordTextField.addSubview(checkLengthLabel)
        checkLengthLabel.addSubview(checkLengthImage)
        
        checkLetterLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        checkLetterLabel.leadingAnchor.constraint(equalTo: checkLetterImage.leadingAnchor, constant: 13).isActive = true
        
        checkLetterImage.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor).isActive = true
        checkLetterImage.centerYAnchor.constraint(equalTo: checkLetterLabel.centerYAnchor).isActive = true
        checkLetterImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        checkLetterImage.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        checkNumberLabel.topAnchor.constraint(equalTo: checkLetterLabel.bottomAnchor, constant: 1).isActive = true
        checkNumberLabel.leadingAnchor.constraint(equalTo: checkNumberImage.leadingAnchor, constant: 13).isActive = true
        
        checkNumberImage.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor).isActive = true
        checkNumberImage.centerYAnchor.constraint(equalTo: checkNumberLabel.centerYAnchor).isActive = true
        checkNumberImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        checkNumberImage.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        checkLengthLabel.topAnchor.constraint(equalTo: checkNumberLabel.bottomAnchor, constant: 1).isActive = true
        checkLengthLabel.leadingAnchor.constraint(equalTo: checkLengthImage.leadingAnchor, constant: 13).isActive = true
        
        checkLengthImage.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor).isActive = true
        checkLengthImage.centerYAnchor.constraint(equalTo: checkLengthLabel.centerYAnchor).isActive = true
        checkLengthImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        checkLengthImage.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        passwordConstraint.constant = 110
        
        theStackView.layoutIfNeeded()
    }
    //MARK: setup Password WH
    func setupPasswortWiederholenTextfield(){
        eyeButtonTwo.isHidden = false
            
            passwordWiederholenTextField.addSubview(checkMatchLabel)
            checkMatchLabel.addSubview(checkMatchImage)
        
            checkMatchLabel.topAnchor.constraint(equalTo: passwordWiederholenTextField.bottomAnchor, constant: 10).isActive = true
            checkMatchLabel.leadingAnchor.constraint(equalTo: checkMatchImage.leadingAnchor, constant: 13).isActive = true
            
            checkMatchImage.leadingAnchor.constraint(equalTo: passwordWiederholenTextField.leadingAnchor).isActive = true
            checkMatchImage.centerYAnchor.constraint(equalTo: checkMatchLabel.centerYAnchor).isActive = true
            checkMatchImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
            checkMatchImage.widthAnchor.constraint(equalToConstant: 10).isActive = true
            
            passwordWiederholenConstraint.constant = 80
            
            theStackView.layoutIfNeeded()
    }
    //MARK: setup Email
    func setupEmailTextField(){
        checkEmailImage.image = UIImage(named: "false")
        checkEmailLabel.text = "ungültige Email-Adresse"
        emailTextField.addSubview(checkEmailLabel)
        checkEmailLabel.addSubview(checkEmailImage)
        
        checkEmailLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        checkEmailLabel.leadingAnchor.constraint(equalTo: checkEmailImage.leadingAnchor, constant: 13).isActive = true
        
        checkEmailImage.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor).isActive = true
        checkEmailImage.centerYAnchor.constraint(equalTo: checkEmailLabel.centerYAnchor).isActive = true
        checkEmailImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        checkEmailImage.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        emailConstraint.constant = 80

        theStackView.layoutIfNeeded()
    }

    // MARK: textFieldshouldBegin
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
            
        case passwordTextField:
            setupPasswortTextfield()
            break
            
        case passwordWiederholenTextField:
            setupPasswortWiederholenTextfield()
            break
            
        default:
            break
        }
        
        return true
    }
    
    // check textField after End Editing
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField == passwordTextField {
         // only check if textfield is not empty
         if textField.text != "" {
             if Utilities.isPasswordValid(textField.text!){
                 // password is valid
                 self.passwordTextField.borderActiveColor = .white
             }else {
                 // password is not valid
//                 self.passwordTextField.borderActiveColor = .red
             }
         }
        }
        return true
    }
    
    var check = true
    @objc func eyeButtonOneTapped(_ sender: Any) {
        check = !check
        
        if check == true {
            eyeButtonOne.setImage(UIImage(named: "eyeOpen"), for: .normal)
        } else {
            eyeButtonOne.setImage(UIImage(named: "eyeClosed"), for: .normal)
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
    
    
    var check2 = true
    @objc func eyeButtonTwoTapped(_ sender: Any) {
        check2 = !check2
        
        if check2 == true {
            eyeButtonTwo.setImage(UIImage(named: "eyeOpen"), for: .normal)
        } else {
            eyeButtonTwo.setImage(UIImage(named: "eyeClosed"), for: .normal)
        }
        passwordWiederholenTextField.isSecureTextEntry.toggle()


            if let existingText = passwordWiederholenTextField.text, passwordWiederholenTextField.isSecureTextEntry {
                /* When toggling to secure text, all text will be purged if the user
                 continues typing unless we intervene. This is prevented by first
                 deleting the existing text and then recovering the original text. */
                passwordWiederholenTextField.deleteBackward()

                if let textRange = passwordWiederholenTextField.textRange(from: passwordWiederholenTextField.beginningOfDocument, to: passwordWiederholenTextField.endOfDocument) {
                    passwordWiederholenTextField.replace(textRange, withText: existingText)
                }
            }
        
        
        
            /* Reset the selected text range since the cursor can end up in the wrong
             position after a toggle because the text might vary in width */
            if let existingSelectedTextRange = passwordWiederholenTextField.selectedTextRange {
                passwordWiederholenTextField.selectedTextRange = nil
                passwordWiederholenTextField.selectedTextRange = existingSelectedTextRange
            }
    }
    //MARK: textFieldDidChange
    @objc private func textFieldDidChange(_ textField: UITextField) {
        
        switch textField {
        case passwordTextField:

            if textField.text!.count >= 8 {
                checkLengthImage.image = UIImage(named: "correct")
            }else {
                checkLengthImage.image = UIImage(named: "false")
            }

            if textField.text!.rangeOfCharacter(from: .lowercaseLetters) != nil
                && textField.text!.rangeOfCharacter(from: .uppercaseLetters) != nil{
                checkLetterImage.image = UIImage(named: "correct")
            }else {
                checkLetterImage.image = UIImage(named: "false")
            }

            if textField.text!.rangeOfCharacter(from: .decimalDigits) != nil {
                checkNumberImage.image = UIImage(named: "correct")
            }else {
                checkNumberImage.image = UIImage(named: "false")
            }
            
            // check if passwords match
            if (textField.text! == passwordWiederholenTextField.text && passwordWiederholenTextField.text != ""){
                checkMatchImage.image = UIImage(named: "correct")
                checkMatchLabel.text = "Passwörter stimmen überein"
            }else {
                checkMatchImage.image = UIImage(named: "false")
                checkMatchLabel.text = "Passwörter stimmen nicht überein"
            }
            
            break
         
        case passwordWiederholenTextField:
            // check if passwords match
            if (textField.text! == passwordTextField.text && passwordTextField.text != ""){
                checkMatchImage.image = UIImage(named: "correct")
                checkMatchLabel.text = "Passwörter stimmen überein"
            }else {
                checkMatchImage.image = UIImage(named: "false")
                checkMatchLabel.text = "Passwörter stimmen nicht überein"
            }
            
            break
            
        case emailTextField:
            
            let text = emailTextField.text ?? ""
            let trimmedText = text.trimmingCharacters(in: .whitespaces)
            emailTextField.text = trimmedText
            
            // check if email format is correct
            if Utilities.isValidEmail(textField.text!){
                checkEmailImage.image = UIImage(named: "correct")
                checkEmailLabel.text = "gültige Email-Adresse"
            }else {
              checkEmailImage.image = UIImage(named: "false")
                checkEmailLabel.text = "ungültige Email-Adresse"
            }
            
            break
            
        default:
            break
        }

    }
    

        
    // disable "space" for every textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        return true
    }
}
