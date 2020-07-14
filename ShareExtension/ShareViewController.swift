//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Christian Konnerth on 22.03.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit
import Social
import SwiftSoup
import URLEmbeddedView
import Lottie

class CustomShareViewController: UIViewController {
    
    let wishView: WishView = {
        let v = WishView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let cancelButton: UIButton = {
        let v = UIButton(type: .system)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        v.setBackgroundImage(UIImage(systemName: "xmark.square.fill"), for: .normal)
        v.tintColor = .darkCustom
        return v
    }()
    
    let cancelImage: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage(systemName: "xmark.square.fill")
        v.tintColor = .darkCustom
        return v
    }()
    
    let coverView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 10
        v.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return v
    }()
    
    var wishConstraint: NSLayoutConstraint!
    
    var theWish: Wish!
    
    var imagesArray = [UIImage]()

    var currentImageIndex = 0
    
    var currentImage: UIImage?
    
    var dropOptions = [DropDownOption]()
    var dataSourceArray = [Wishlist]()
    
    var keyboardHeight = CGFloat(0)
    
    let loadingAnimation = AnimationView(name: "LoadingAnimation")
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .clear
        self.navigationController?.isNavigationBarHidden = true
            
        wishView.prevButton.isEnabled = false
        wishView.nextButton.isEnabled = false
        
        self.wishView.onPrevButtonTapped = self.prevButtonTappedClosure
        self.wishView.onNextButtonTapped = self.nextButtonTappedClosure
        
        self.wishView.addWishDelegate = self
      
        if let defaults = UserDefaults(suiteName: UserDefaults.Keys.groupKey) {
            print(defaults.isLoggedIn())
            if defaults.isLoggedIn(){
                if let data = defaults.getDataSourceArray(){
                    if let dropOptions = defaults.getDropOptions(){
                        setupViews()
                        setUpLoadingAnimation()
                        self.dataSourceArray = data
                        self.dropOptions = dropOptions
                        defaults.synchronize()
//                        print(dropOptions[0].name)
//                        print(dataSourceArray[0].name)
                        loadData {
                            DispatchQueue.main.async {
                              self.hideLoadingView()
                            }
                        }
                    } else {
                        print("error getting dropOptions")
                    }
                } else {
                    print("Error getting dataSourceArray")
                }
            } else {
                userIsNotLoggedInAlert()
                self.loadingAnimation.stop()
                self.loadingAnimation.removeFromSuperview()
            }
            
        } else {
            print("error 1")
        }
   
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            
    }
    
    func nextButtonTappedClosure(){
        if imagesArray.count != 0 {
            currentImage = imagesArray[self.currentImageIndex]
            currentImageIndex = (currentImageIndex + 1) % imagesArray.count
            UIView.transition(with: self.wishView.wishImageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.wishView.wishImageView.image = self.imagesArray[self.currentImageIndex]
            })
        }
    }
    
    func prevButtonTappedClosure(){
        if imagesArray.count != 0 {
            currentImage = imagesArray[self.currentImageIndex]
            
            if currentImageIndex - 1 < 0 {
                currentImageIndex = imagesArray.count - 1
            }else {
                currentImageIndex = (currentImageIndex - 1) % imagesArray.count
            }
            
            UIView.transition(with: self.wishView.wishImageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.wishView.wishImageView.image = self.imagesArray[self.currentImageIndex]
            })
        }
    }
    
    func userIsNotLoggedInAlert(){
        let alertcontroller = UIAlertController(title: "Du bist nicht angemeldet.", message: "Melde dich an deiner Wishlists-App an, um deine Wünsche zu speichern.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
            self.cancelAction()
        }
        alertcontroller.addAction(cancelAction)
        self.present(alertcontroller, animated: true)
    }

    //MARK: setupViews
    private func setupViews(){
        
        view.addSubview(wishView)
        wishView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        wishView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        wishView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        wishConstraint = wishView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        wishConstraint.isActive = true
        
        view.addSubview(cancelButton)        
        cancelButton.bottomAnchor.constraint(equalTo: wishView.topAnchor, constant: -5).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: wishView.trailingAnchor, constant: -10).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    
    }
    
    //MARK: setupLoadingAnimation
    func setUpLoadingAnimation(){
        
        view.addSubview(coverView)
        coverView.topAnchor.constraint(equalTo: wishView.topAnchor).isActive = true
        coverView.leadingAnchor.constraint(equalTo: wishView.leadingAnchor).isActive = true
        coverView.trailingAnchor.constraint(equalTo: wishView.trailingAnchor).isActive = true
        coverView.bottomAnchor.constraint(equalTo: wishView.bottomAnchor).isActive = true
        
        loadingAnimation.contentMode = .scaleAspectFit
        loadingAnimation.translatesAutoresizingMaskIntoConstraints = false
        coverView.addSubview(loadingAnimation)
        
        loadingAnimation.centerXAnchor.constraint(equalTo: coverView.centerXAnchor).isActive = true
        loadingAnimation.centerYAnchor.constraint(equalTo: coverView.centerYAnchor).isActive = true
        loadingAnimation.heightAnchor.constraint(equalToConstant: 100).isActive = true
        loadingAnimation.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loadingAnimation.loopMode = .loop
        loadingAnimation.play()
        
    }
    
    //MARK: hideLoadingView
    func hideLoadingView (){
        coverView.removeFromSuperview()
        loadingAnimation.stop()
    }
    
    //MARK: keyboardHandling
    // hide keyboard, wenn user außerhalb toucht
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
            
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]

            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey]
            
            UIView.animate(withDuration: duration as! TimeInterval, delay: 0, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(truncating: curve as! NSNumber)), animations: {
                        self.wishConstraint.constant = -(self.keyboardHeight)
                        self.view.layoutIfNeeded()
                    }, completion: nil)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
            
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]

            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey]
            
            UIView.animate(withDuration: duration as! TimeInterval, delay: 0, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(truncating: curve as! NSNumber)), animations: {
                        self.wishConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }, completion: nil)
        }
    }
    
    //MARK: cancelAction
    @objc func cancelAction () {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }

    //MARK: doneAction
    @objc func doneAction() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    //MARK: loadData
    func loadData(finished: @escaping () -> Void){
        
            var html: String?
            
            if let item = extensionContext?.inputItems.first as? NSExtensionItem,
                let itemProvider = item.attachments?.first,
                itemProvider.hasItemConformingToTypeIdentifier("public.url") {
                itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
                    if (url as? URL) != nil {
                        
                        html = (self.getHTMLfromURL(url: url as? URL))
                        print(url as Any)
                        let directoryURL = url as! NSURL
                        let urlString: String = directoryURL.absoluteString!
                        
                        OpenGraphDataDownloader.shared.fetchOGData(urlString: urlString) { result in
                            switch result {
                            case let .success(data, _):
                                // get productTitle
                                guard let title = data.pageTitle else { return }
                                print(title)
                                DispatchQueue.main.async {
                                    self.wishView.wishNameTextField.text = title
                                }
                                // get productImage
                                guard let imageURL = data.imageUrl else { return }
                                UIImage.loadFrom(url: imageURL, completion: { (image) in
                                    
                                    guard let image = image else { return }
                                    self.wishView.wishImageView.image = image
                                    self.imagesArray.append(image)
                    
                                    finished()
                                })
                      
                            case let .failure(error, _):
                                finished()
                                print("OpenGraph-error: " + error.localizedDescription)
                            }
                        }
                        DispatchQueue.main.async {
                            self.getContentFromHTML(html: html)
                        }
                        
                    }
                }
            }
    }
    //MARK: getContent
    func getContentFromHTML(html: String?){
        
        do {
            let doc: Document = try SwiftSoup.parse(html ?? "")
            // set price if not 0
            let price = Int(getPrice(doc: doc))
            if price != 0 {
                self.wishView.amount = Int(getPrice(doc: doc))
                self.wishView.priceTextField.text = self.wishView.updateAmount()
            }
            
            getImages(doc: doc)
            
        } catch Exception.Error( _, let message) {
            print(message)
        } catch {
            print("error")
        }
        
        
    }
    //MARK: getImages
    func getImages(doc: Document) {
        let srcs: Elements? = try? doc.select("img[src]")
        let srcsStringArray: [String?] = srcs!.array().map { try? $0.attr("src").description }

        for imageName in srcsStringArray {
            if (imageName?.matches("^https?://(?:[a-z0-9\\-]+\\.)+[a-z]{2,6}(?:/[^/#?]+)+\\.(?:jpg|gif|png)$"))! {
                
                guard let url = URL(string: imageName!) else { return }
                
                UIImage.loadFrom(url: url) { image in
           
                    if let image = image {
                        self.imagesArray.append(image)
                        
                        if self.imagesArray.count == 1 {
                            self.wishView.wishImageView.image = self.imagesArray[0]
                        }else {
                            self.wishView.prevButton.isEnabled = true
                            self.wishView.nextButton.isEnabled = true
                        }
                        
                    } else {
                        print("Image '\(String(describing: imageName))' does not exist!")
                    }
                }
            }
        }
    }
    
    func getHTMLfromURL(url: URL?) -> String{
        let myURLString = url
        guard let myURL = myURLString else {
            print("Error: \(String(describing: url)) doesn't seem to be a valid URL")
            return ""
        }

        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
            return myHTMLString
        } catch let error {
            print("Error: \(error)")
        }
        
        return ""
    }
    //MARK: getPrice
    func getPrice(doc: Document) -> Double {
        let priceClasses: Elements? = try? doc.select("[class~=(?i)price]")
        
        guard (priceClasses?.first()) != nil else { return 0.00 }
        
        var price = Double(0.0)
        
        guard  let priceText : String = try! priceClasses?.first()!.text() else { return 0.00 }
        
        var priceTrimmed = priceText.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)
        priceTrimmed = priceTrimmed.replacingOccurrences(of: ",", with: ".")
        
        if let doublePrice = Double(priceTrimmed) {
            price += doublePrice
            let rounded = Double(round(100*price)/100)
            // return value * 100 so updateAmount calculates correct Int Value
            return rounded*100
        }
        
        return 0.00
    }
    
    
}



