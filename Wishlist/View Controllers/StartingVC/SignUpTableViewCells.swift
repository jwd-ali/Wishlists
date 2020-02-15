//
//  SignUpTableViewCell.swift
//  Wishlist
//
//  Created by Christian Konnerth on 27.01.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit
import TransitionButton
//MARK: EmailCell
class SignUpEmailCell: UITableViewCell {

    public static let reuseID = "SignUpEmailCell"
    
    let emailTextField: CustomTextField = {
        let v = CustomTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Email-Adresse"
        v.placeholderColor = .white
        v.placeholderFontScale = 0.8
        v.clearButtonMode = .always
        v.minimumFontSize = 13
        v.borderStyle = .line
        v.autocapitalizationType = .none
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        setupViews()
    }
    
    func setupViews(){
        contentView.addSubview(emailTextField)
        
        emailTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}
//MARK: HandleCell
class SignUpHandleCell: UITableViewCell {

    public static let reuseID = "SignUpHandleCell"
    
    let wishlistHandleTextField: CustomTextField = {
        let v = CustomTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Wishlist-Handle"
        v.placeholderColor = .white
        v.placeholderFontScale = 0.8
        v.clearButtonMode = .always
        v.minimumFontSize = 13
        v.borderStyle = .line
        v.autocapitalizationType = .none
        v.translatesAutoresizingMaskIntoConstraints = false
//        v.leftView = handleLeftView
//        v.leftViewMode = .always
        return v
    }()

    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        setupViews()
    }
    
    func setupViews(){
        contentView.addSubview(wishlistHandleTextField)
        
        wishlistHandleTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        wishlistHandleTextField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        wishlistHandleTextField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        wishlistHandleTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}

//MARK: AnzeigeNameCell
class SignUpAnzeigeName: UITableViewCell {

    public static let reuseID = "SignUpAnzeigeName"
    
    let anzeigeNameTextField: CustomTextField = {
        let v = CustomTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Anzeigename: z.B. dein Vorname"
        v.placeholderColor = .white
        v.placeholderFontScale = 0.8
        v.clearButtonMode = .always
        v.minimumFontSize = 13
        v.borderStyle = .line
        v.autocapitalizationType = .none
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        setupViews()
    }
    
    func setupViews(){
        contentView.addSubview(anzeigeNameTextField)
        
        anzeigeNameTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        anzeigeNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        anzeigeNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        anzeigeNameTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}

//MARK: PasswordCell
class SignUpPasswordCell: UITableViewCell, UITextFieldDelegate {

    public static let reuseID = "SignUpPasswordCell"
    
    lazy var eyeButton: UIButton = {
        let v = UIButton()
        v.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
        v.setImage(UIImage(named: "eyeOpen"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var passwordTextField: CustomTextField = {
        let v = CustomTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Passwort"
        v.placeholderColor = .white
        v.placeholderFontScale = 0.8
        v.minimumFontSize = 13
        v.borderStyle = .line
        v.addTarget(self, action: #selector(SignUpPasswordCell.passwordTextFieldDidChange(_:)),for: .editingChanged)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        passwordTextField.delegate = self
        
        eyeButton.isHidden = true
        passwordTextField.textContentType = .newPassword
        passwordTextField.isSecureTextEntry.toggle()
        
        setupViews()
    }
    
    func setupViews(){
        contentView.addSubview(passwordTextField)
        contentView.addSubview(eyeButton)
        
        passwordTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        eyeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        eyeButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
    }

    var check = true
    @objc func eyeButtonTapped(_ sender: Any) {
        
        check = !check
        
        if check == true {
            eyeButton.setImage(UIImage(named: "eyeOpen"), for: .normal)
        } else {
            eyeButton.setImage(UIImage(named: "eyeClosed"), for: .normal)
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
    
// delegate Methode für eye-Button
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       switch textField {
       case passwordTextField:
           if passwordTextField.text != "" {
               
           } else {
               eyeButton.isHidden = true
           }
           
           self.passwordTextField.borderActiveColor = .white
           
           break
       default:
           break
       }
        
       return true
   }

   func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
       
       if textField == passwordTextField {
        // only check if textfield is not empty
        if textField.text != "" {
            if Utilities.isPasswordValid(textField.text!){
                // password is valid
                self.passwordTextField.borderActiveColor = .white
            }else {
                // password is not valid
                self.passwordTextField.borderActiveColor = .red
            }
        }
       }
       return true
   }
    
    @objc func passwordTextFieldDidChange(_ textField: UITextField) {
            if textField.text == "" {
                self.eyeButton.isHidden = true
            }else {
                self.eyeButton.isHidden = false
            }
        
    }
}



//MARK: PasswordRepeatCell
class SignUpPasswordRepeatCell: UITableViewCell, UITextFieldDelegate {

    public static let reuseID = "SignUpPasswordRepeatCell"
    
    lazy var passwordWiederholenTextField: CustomTextField = {
        let v = CustomTextField()
        v.borderActiveColor = .white
        v.borderInactiveColor = .white
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.placeholder = "Passwort wiederholen"
        v.placeholderColor = .white
        v.placeholderFontScale = 0.8
        v.minimumFontSize = 13
        v.borderStyle = .line
        v.addTarget(self, action: #selector(SignUpPasswordRepeatCell.passwordTextFieldDidChange(_:)),for: .editingChanged)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var eyeButton: UIButton = {
        let v = UIButton()
        v.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
        v.setImage(UIImage(named: "eyeOpen"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        passwordWiederholenTextField.delegate = self
        
        eyeButton.isHidden = true
        passwordWiederholenTextField.textContentType = .newPassword
        passwordWiederholenTextField.isSecureTextEntry.toggle()
        
        setupViews()
    }
    
    func setupViews(){
        contentView.addSubview(passwordWiederholenTextField)
        contentView.addSubview(eyeButton)
        
        passwordWiederholenTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        passwordWiederholenTextField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        passwordWiederholenTextField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        passwordWiederholenTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        eyeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        eyeButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
        
    }
    
    var check = true
    @objc func eyeButtonTapped(_ sender: Any) {
        
        check = !check
        
        if check == true {
            eyeButton.setImage(UIImage(named: "eyeOpen"), for: .normal)
        } else {
            eyeButton.setImage(UIImage(named: "eyeClosed"), for: .normal)
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
    
    @objc func passwordTextFieldDidChange(_ textField: UITextField) {
            if textField.text == "" {
                self.eyeButton.isHidden = true
            }else {
                self.eyeButton.isHidden = false
            }
    }
}

//MARK: DocumentsCell
class SignUpDocumentCell: UITableViewCell {

    public static let reuseID = "SignUpDocumentCell"
    
    let documentsLabel: UILabel = {
        let v = UILabel()
        v.text = "Durch Klicken auf 'Registrieren' akzeptiere ich die Nutzungbedingungnen und die Datenschutzrichtlinien."
        v.font = UIFont(name: "AvenirNext-Regular", size: 13)
        v.textColor = .lightGray
        v.textAlignment = .center
        v.numberOfLines = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        setupViews()
    }
    
    func setupViews(){
        contentView.addSubview(documentsLabel)
        
        documentsLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        documentsLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        documentsLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        documentsLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}

//MARK: ButtonCell
class SignUpButtonCell: UITableViewCell {

    public static let reuseID = "SignUpButtonCell"
    
    let signUpButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Registrieren", for: .normal)
        v.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.titleLabel?.textColor = .white
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = UIColor.darkGray
        v.layer.cornerRadius = 3
        v.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return v
    }()

    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        setupViews()
    }
    
    func setupViews(){
        contentView.addSubview(signUpButton)
        
        signUpButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        signUpButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func signUpButtonTapped(){
        print("SignUpButtonTapped")
    }
}

