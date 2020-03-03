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
import TransitionButton


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
        return v
    }()
    
    let theStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.alignment = .fill
        v.distribution = .equalSpacing
        v.spacing = 30
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    //MARK: Email
    
    var emailConstraint:NSLayoutConstraint!
    
    let emailView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let emailTextField: CustomTextField = {
        let v = CustomTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Email-Adresse"
        v.placeholderColor = .white
        v.placeholderFontScale = 1
        v.clearButtonMode = .always
        v.minimumFontSize = 13
        v.borderStyle = .line
        v.autocapitalizationType = .none
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
    
    //MARK: Anzeigename
    
    var anzeigeNameConstraint:NSLayoutConstraint!
    
    let anzeigeNameView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let anzeigeNameTextField: CustomTextField = {
        let v = CustomTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Anzeigename: z.B. dein Vorname"
        v.placeholderColor = .white
        v.placeholderFontScale = 1
        v.clearButtonMode = .always
        v.minimumFontSize = 13
        v.borderStyle = .line
        v.autocapitalizationType = .none
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(textFieldDidChange(_:)),for: .editingChanged)
        return v
    }()
    
    lazy var checkAnzeigeNameImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "false")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var checkAnzeigeNameLabel: UILabel = {
        let v = UILabel()
        v.text = "ungültiger Benutzername"
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 13)
        v.translatesAutoresizingMaskIntoConstraints = false
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
        return v
    }()
    
    lazy var checkUsernameImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "false")
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

    //MARK: Password
    
    var passwordConstraint:NSLayoutConstraint!
    
    let passwordView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let passwordTextField: CustomTextField = {
        let v = CustomTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Passwort"
        v.placeholderColor = .white
        v.placeholderFontScale = 1
        v.minimumFontSize = 13
        v.borderStyle = .line
        v.addTarget(self, action: #selector(textFieldDidChange(_:)),for: .editingChanged)
        v.translatesAutoresizingMaskIntoConstraints = false
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
    
    let passwordWiederholenTextField: CustomTextField = {
        let v = CustomTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Passwort wiederholen"
        v.placeholderColor = .white
        v.placeholderFontScale = 1
        v.minimumFontSize = 13
        v.borderStyle = .line
        v.addTarget(self, action: #selector(textFieldDidChange(_:)),for: .editingChanged)
        v.translatesAutoresizingMaskIntoConstraints = false
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
    
    lazy var eyeButtonOne: UIButton = {
        let v = UIButton()
        v.addTarget(self, action: #selector(eyeButtonOneTapped), for: .touchUpInside)
        v.setImage(UIImage(named: "eyeOpen"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let eyeButtonTwo: UIButton = {
        let v = UIButton()
        v.addTarget(self, action: #selector(eyeButtonTwoTapped), for: .touchUpInside)
        v.setImage(UIImage(named: "eyeOpen"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //MARK: Documents
    let documentsLabel: UILabel = {
        let v = UILabel()
        v.text = "Durch Klicken auf 'Registrieren' akzeptiere ich die Nutzungsbedingungnen und die Datenschutzrichtlinien."
        v.font = UIFont(name: "AvenirNext-Regular", size: 13)
        v.textColor = .lightGray
        v.textAlignment = .center
        v.numberOfLines = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let documentsTextView: UITextView = {
        let v = UITextView()
        v.isEditable = false
        v.backgroundColor = .clear
        v.textAlignment = .center
        v.font = UIFont(name: "AvenirNext-Regular", size: 13)
        v.textColor = .lightGray
        v.translatesAutoresizingMaskIntoConstraints = false
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
    
    var signUpButtonConstraint:NSLayoutConstraint!
    
    let signUpButtonView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    var email = ""
    
    //MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Auge Button Standart auf offen setzen
        eyeButtonOne.setImage(UIImage(named: "eyeOpen"), for: .normal)
        eyeButtonTwo.setImage(UIImage(named: "eyeOpen"), for: .normal)
        self.eyeButtonOne.isHidden = true
        self.eyeButtonTwo.isHidden = true
        
        // add motion effect to background image
        Utilities.applyMotionEffect(toView: self.backgroundImage, magnitude: 20)
        
        //password hide/show
        passwordTextField.isSecureTextEntry.toggle()
        
        //password hide/show
        passwordWiederholenTextField.isSecureTextEntry.toggle()
        
        //change return key
        anzeigeNameTextField.returnKeyType = .next
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .next
        passwordWiederholenTextField.returnKeyType = .done
        
        // set delegates
        emailTextField.delegate = self
        anzeigeNameTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        passwordWiederholenTextField.delegate = self
        documentsTextView.delegate = self
        
        
        // set passwordTextfield content type
        passwordTextField.textContentType = .newPassword
        passwordWiederholenTextField.textContentType = .newPassword

        
        
        
        // make text in DocumentsView clickable
        
        let attributedString = NSMutableAttributedString(string: "Durch Klicken auf 'Registrieren' akzeptiere ich die Nutzungsbedingungen und die Datenschutzrichtlinien.")
        attributedString.addAttribute(.link, value: "Nutzungsbedingungen", range: NSRange(location: 52, length: 19))
        attributedString.addAttribute(.link, value: "Datenschutzrichtlinien", range: NSRange(location: 80, length: 22))
        
        documentsTextView.attributedText = attributedString
        
        
        //Textfield cursor -> white
        UITextField.appearance().tintColor = .white


        setUpViews()
        
        self.emailTextField.text = email
        
        //setupEmailTextfield()
        
    }
    
        
    //MARK: setupViews
    func setUpViews() {
        
        view.addSubview(backgroundImage)
        view.addSubview(backButton)
        view.addSubview(theScrollView)
        view.addSubview(theLabel)
        theScrollView.addSubview(theStackView)
        
        theStackView.addArrangedSubview(emailView)
        view.addSubview(emailTextField)
        
        theStackView.addArrangedSubview(anzeigeNameView)
        view.addSubview(anzeigeNameTextField)
        
        theStackView.addArrangedSubview(usernameView)
        view.addSubview(usernameTextField)
        
        theStackView.addArrangedSubview(passwordView)
        view.addSubview(passwordTextField)
        view.addSubview(eyeButtonOne)
        
        theStackView.addArrangedSubview(passwordWiederholenView)
        view.addSubview(passwordWiederholenTextField)
        view.addSubview(eyeButtonTwo)
        
        theStackView.addArrangedSubview(documentsTextView)
        
        theStackView.addArrangedSubview(signUpButtonView)
        view.addSubview(signUpButton)
        
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
        theScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        theStackView.topAnchor.constraint(equalTo: theScrollView.topAnchor).isActive = true
        theStackView.leadingAnchor.constraint(equalTo: theScrollView.leadingAnchor).isActive = true
        theStackView.trailingAnchor.constraint(equalTo: theScrollView.trailingAnchor).isActive = true
        theStackView.bottomAnchor.constraint(equalTo: theScrollView.bottomAnchor).isActive = true
        theStackView.widthAnchor.constraint(equalTo: theScrollView.widthAnchor).isActive = true
        
        emailConstraint = emailView.heightAnchor.constraint(equalToConstant: 60)
        emailConstraint.isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        emailTextField.topAnchor.constraint(equalTo: emailView.topAnchor).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: emailView.leadingAnchor).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: emailView.trailingAnchor).isActive = true
        
        anzeigeNameConstraint = anzeigeNameView.heightAnchor.constraint(equalToConstant: 60)
        anzeigeNameConstraint.isActive = true
        anzeigeNameTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        anzeigeNameTextField.topAnchor.constraint(equalTo: anzeigeNameView.topAnchor).isActive = true
        anzeigeNameTextField.leadingAnchor.constraint(equalTo: anzeigeNameView.leadingAnchor).isActive = true
        anzeigeNameTextField.trailingAnchor.constraint(equalTo: anzeigeNameView.trailingAnchor).isActive = true
        
        usernameConstraint = usernameView.heightAnchor.constraint(equalToConstant: 60)
        usernameConstraint.isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: usernameView.topAnchor).isActive = true
        usernameTextField.leadingAnchor.constraint(equalTo: usernameView.leadingAnchor).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: usernameView.trailingAnchor).isActive = true
        
        passwordConstraint = passwordView.heightAnchor.constraint(equalToConstant: 60)
        passwordConstraint.isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: passwordView.topAnchor).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: passwordView.leadingAnchor).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: passwordView.trailingAnchor).isActive = true
        eyeButtonOne.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -5).isActive = true
        eyeButtonOne.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor, constant: 10).isActive = true
        
        passwordWiederholenConstraint = passwordWiederholenView.heightAnchor.constraint(equalToConstant: 60)
        passwordWiederholenConstraint.isActive = true
        passwordWiederholenTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        passwordWiederholenTextField.topAnchor.constraint(equalTo: passwordWiederholenView.topAnchor).isActive = true
        passwordWiederholenTextField.leadingAnchor.constraint(equalTo: passwordWiederholenView.leadingAnchor).isActive = true
        passwordWiederholenTextField.trailingAnchor.constraint(equalTo: passwordWiederholenView.trailingAnchor).isActive = true
        eyeButtonTwo.trailingAnchor.constraint(equalTo: passwordWiederholenTextField.trailingAnchor, constant: -5).isActive = true
        eyeButtonTwo.centerYAnchor.constraint(equalTo: passwordWiederholenTextField.centerYAnchor, constant: 10).isActive = true
        
        
        documentsTextView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        signUpButtonConstraint = signUpButtonView.heightAnchor.constraint(equalToConstant: 60)
        signUpButtonConstraint.isActive = true
        signUpButton.centerYAnchor.constraint(equalTo: signUpButtonView.centerYAnchor).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: signUpButtonView.centerXAnchor).isActive = true
        signUpButton.leadingAnchor.constraint(equalTo: signUpButtonView.leadingAnchor).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: signUpButtonView.trailingAnchor).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }
    
    func areFieldsValid() ->Bool? {
        
        var isValid = true
        
        //check if all fields are filled
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            setupEmailTextField()
            isValid = false
        }
        if anzeigeNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            setupAnzeigeNameTextField()
            isValid = false
        }

        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            setupUsernameTextField()
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
        
        //check if both passwords are the same
        if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) !=
            passwordWiederholenTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            isValid = false
        }
        
        return isValid
    }
    
    @objc func signUpButtonTapped(_ sender: Any) {
        // Validate the fields
        if areFieldsValid()! {
            print("valid")
        }else {
            print("invalid")
        }
        
//        if error != nil {
//
//            //dismiss keyboard
//            view.endEditing(true)
//
//            //there is sth wrong with the fields, show error message
////            showError(error!)
//        }else {
//
//            //create cleaned versione of the data
//            let firstName = anzeigeNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//
//            //create the user
//            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
//
//                //check for errors
//                if let err = err {
//                    self.view.endEditing(true)
////                    self.showError(err.localizedDescription)
//
//                }else {
//
//                    //user was created successfully; store first and last name
//                    let db = Firestore.firestore()
//
//                    let userID = result!.user.uid
//
//                    db.collection("users").document(userID).setData(["firstname":firstName, "uid": result!.user.uid]) { (error) in
//                        if error != nil {
////                            self.showError("Error saving user data")
//                        }
//                    }
//
//                    db.collection("users").document(userID).collection("wishlists").document("Main Wishlist").setData(["name": "Main Wishlist", "listIDX": 1]) { (error) in
//                        if error != nil {
////                            self.showError("Error creating Main Wishlist")
//                        }
//                    }
//
////                    self.signUpButton.startAnimation()
//                    //transition to home
//                    self.transitionToHome()
//                }
//
//            }
//        }
        
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
        if textField == anzeigeNameTextField {
            emailTextField.becomeFirstResponder()
        }else if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField {
            passwordWiederholenTextField.becomeFirstResponder()
        }else if textField == passwordWiederholenTextField {
            passwordWiederholenTextField.resignFirstResponder()
            self.signUpButton.sendActions(for: .touchUpInside)
        }
        
        return true
    }
    
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
    
    func setupEmailTextField(){
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
    
    func setupAnzeigeNameTextField(){
        anzeigeNameTextField.addSubview(checkAnzeigeNameLabel)
        checkAnzeigeNameLabel.addSubview(checkAnzeigeNameImage)
        
        checkAnzeigeNameLabel.topAnchor.constraint(equalTo: anzeigeNameTextField.bottomAnchor, constant: 10).isActive = true
        checkAnzeigeNameLabel.leadingAnchor.constraint(equalTo: checkAnzeigeNameImage.leadingAnchor, constant: 13).isActive = true

        checkAnzeigeNameImage.leadingAnchor.constraint(equalTo: anzeigeNameTextField.leadingAnchor).isActive = true
        checkAnzeigeNameImage.centerYAnchor.constraint(equalTo: checkAnzeigeNameLabel.centerYAnchor).isActive = true
        checkAnzeigeNameImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        checkAnzeigeNameImage.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        anzeigeNameConstraint.constant = 80
        
        theStackView.layoutIfNeeded()
    }
    
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
        
        theStackView.layoutIfNeeded()
    }
    
    //delegate Methode für Password Textfield
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
            
            
        case passwordTextField:
            setupPasswortTextfield()
            break
            
        case passwordWiederholenTextField:
            setupPasswortWiederholenTextfield()
            break
        
//        case usernameTextField:
//            setupUsernameTextField()
//            break
            
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
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        
        switch textField {
        case passwordTextField:

            if textField.text!.count > 8 {
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
            // check if email format is correct
            if Utilities.isValidEmail(textField.text!){
                checkEmailImage.image = UIImage(named: "correct")
                checkEmailLabel.text = "gültige Email-Adresse"
            }else {
              checkEmailImage.image = UIImage(named: "false")
                checkEmailLabel.text = "ungültige Email-Adresse"
            }
            
            break
            
        case anzeigeNameTextField:
            if textField.text != "" {
                checkAnzeigeNameImage.image = UIImage(named: "correct")
                checkAnzeigeNameLabel.text = "gültiger Anzeigename"
            }else {
               checkAnzeigeNameImage.image = UIImage(named: "false")
                checkAnzeigeNameLabel.text = "kein gültiger Anzeigename"
            }
            
            break
            
        case usernameTextField:
            if textField.text?.isEmpty == false {
                checkUsername(field: textField.text!) { (success) in
                    if success == true {
                        // username is taken
                        print("Username is taken")
                        self.setupUsernameTextField()
                        self.checkUsernameImage.image = UIImage(named: "false")
                        self.checkUserNameLabel.text = "Benutzername ist bereits vergeben"
                    } else {
                        // username is not taken
                        print("Username is not taken")
                        self.checkUsernameImage.image = UIImage(named: "correct")
                        self.checkUserNameLabel.text = "gültiger Benutzername"
                    }
                }
            }else {
                self.checkUsernameImage.image = UIImage(named: "false")
                self.checkUserNameLabel.text = "kein gültiger Benutzername"
            }
        default:
            break
        }

    }
    

    // helper function to check if username is in databse -> later in Datahandler
    func checkUsername(field: String, completion: @escaping (Bool) -> Void) {
        
        let db = Firestore.firestore()
        let collectionRef = db.collection("users")
        collectionRef.whereField("username", isEqualTo: field).getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else if (snapshot?.isEmpty)! {
                completion(false)
            } else {
                for document in (snapshot?.documents)! {
                    if document.data()["username"] != nil {
                        completion(true)
                    }
                }
            }
        }
    }
    
    // disable "space" for every textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if URL.absoluteString == "Nutzungsbedingungen" {
            print("nutzung")
        }else if URL.absoluteString == "Datenschutzrichtlinien" {
            print("daten")
        }
        
        return true
    }
}
