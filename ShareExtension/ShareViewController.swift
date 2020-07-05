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


class CustomShareViewController: UIViewController {
    
    let visualEffectView: UIVisualEffectView = {
        let blurrEffect = UIBlurEffect(style: .light)
        let v = UIVisualEffectView(effect: blurrEffect)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let backButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named:"dismissButton"), for: .normal)
        v.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        return v
    }()
    
    let actionButton: UIButton = {
        let v = UIButton(type: .system)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Action", for: .normal)
        v.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 23)
        v.titleLabel?.textColor = .white
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = UIColor.darkGray
        v.layer.cornerRadius = 3
        v.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let swipeImageView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .cyan
        v.contentMode = .scaleAspectFit
        v.isUserInteractionEnabled = true
        return v
    }()
    
    let wishView: WishView = {
        let v = WishView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let transparentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return v
    }()
    
    var wishConstraint: NSLayoutConstraint!
    
    var theWish: Wish!
    
    
    var imagesArray = [UIImage]()

    var currentImageIndex = 0
    
    var currentImage: UIImage?
    
    var dropOptions = [DropDownOption]()
    var dataSourceArray = [Wishlist]()
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .clear
        self.navigationController?.isNavigationBarHidden = true
        
        setupViews()
        
//        prevButton.isEnabled = false
//        nextButton.isEnabled = false
        
        self.wishView.addWishDelegate = self
        
        if let defaults = UserDefaults(suiteName: UserDefaults.Keys.groupKey) {
            if let data = defaults.getDataSourceArray() {
                dataSourceArray = data
                defaults.synchronize()
                print(dataSourceArray[0].name)
            }else {
                print("error 2")
            }
            
        } else {
            print("error 1")
        }
        
        actionButtonTapped()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func nextButtonTappedClosure(){
        if imagesArray.count != 0 {
            currentImage = imagesArray[self.currentImageIndex]
            currentImageIndex = (currentImageIndex + 1) % imagesArray.count
            UIView.transition(with: self.swipeImageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.swipeImageView.image = self.imagesArray[self.currentImageIndex]
            })
        }
    }
    
    @objc func prevButtonTappedClosure(){
        self.wishView.onPrevButtonTapped = {
            print("prev")
        }
        if imagesArray.count != 0 {
            currentImage = imagesArray[self.currentImageIndex]
            
            if currentImageIndex - 1 < 0 {
                currentImageIndex = imagesArray.count - 1
            }else {
                currentImageIndex = (currentImageIndex - 1) % imagesArray.count
            }
            
            UIView.transition(with: self.swipeImageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.swipeImageView.image = self.imagesArray[self.currentImageIndex]
            })
        }
    }

    //MARK: setupViews
    private func setupViews(){
        //MARK: constrain wishView
        transparentView.frame = self.view.frame
        self.view.addSubview(transparentView)
        transparentView.alpha = 0

        self.view.addSubview(self.wishView)
        wishView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        wishView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        wishView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        wishConstraint = wishView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        wishConstraint.isActive = true
    }
    
    // hide keyboard, wenn user außerhalb toucht
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("1")
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        print("2")
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
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
    
    @objc func actionButtonTapped(){
            print("yeet")
        
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
                                    print("yeet1")
                                    
                                    guard let image = image else { return }
                                    
                                    self.wishView.wishImageView.image = image
                                    
                                    self.imagesArray.append(image)
                                      
                                    
                                })
                                
                                
                            case let .failure(error, _):
                                // do something
                                print("OpenGraph-error: " + error.localizedDescription)
                            }
                            
                        }
                        
                        DispatchQueue.main.async {
                          print("yeet2")
                          self.doStuff(html: html)
                        }
                        
                    }
                }
            }
    }
    
    func doStuff(html: String?){
        
        do {
            let doc: Document = try SwiftSoup.parse(html ?? "")
            
            self.wishView.priceTextField.text = getPrice(doc: doc)

            let srcs: Elements = try doc.select("img[src]")
            let srcsStringArray: [String?] = srcs.array().map { try? $0.attr("src").description }

            for imageName in srcsStringArray {
                if (imageName?.matches("^https?://(?:[a-z0-9\\-]+\\.)+[a-z]{2,6}(?:/[^/#?]+)+\\.(?:jpg|gif|png)$"))! {
                    
                    guard let url = URL(string: imageName!) else { return }
                    
                    UIImage.loadFrom(url: url) { image in
                        
                        if let image = image {
                            self.imagesArray.append(image)
                            
                            if self.imagesArray.count == 1 {
                                self.swipeImageView.image = self.imagesArray[0]
                            }else {
//                                self.prevButton.isEnabled = true
//                                self.nextButton.isEnabled = true
                            }
                            
                        } else {
                            print("Image '\(String(describing: imageName))' does not exist!")
                        }
                    }
                }
            }
        } catch Exception.Error( _, let message) {
            print(message)
        } catch {
            print("error")
                
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
    
    func getPrice(doc: Document) -> String {
        let priceClasses: Elements? = try? doc.select("[class~=(?i)price]")
        
        guard (priceClasses?.first()) != nil else { return "" }
        
        var price = Double(0.0)
        
        guard  let priceText : String = try! priceClasses?.first()!.text() else { return "" }
        
        var priceTrimmed = priceText.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)
        priceTrimmed = priceTrimmed.replacingOccurrences(of: ",", with: ".")
        
        if let doublePrice = Double(priceTrimmed) {
            price += doublePrice
            let rounded = Double(round(100*price)/100)
            print("price: \(rounded)")
            let roundedText: String = String(format:"%.2f", rounded)
            print(roundedText)
            return roundedText
        }
        
        return ""
    }
    
    
}



