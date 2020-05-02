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
    
    let nextButton: UIButton = {
        let v = UIButton(type: .system)
        v.setImage(UIImage(systemName: "arrow.right.square.fill"), for: .normal)
        v.tintColor = UIColor.darkCustom
        v.imageView?.contentMode = .scaleAspectFit
        v.contentHorizontalAlignment = .fill
        v.contentVerticalAlignment = .fill
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let prevButton: UIButton = {
        let v = UIButton(type: .system)
        v.setImage(UIImage(systemName: "arrow.left.square.fill"), for: .normal)
        v.tintColor = UIColor.darkCustom
        v.imageView?.contentMode = .scaleAspectFit
        v.contentHorizontalAlignment = .fill
        v.contentVerticalAlignment = .fill
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(prevButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let wishView: WishView = {
        let v = WishView()
        v.theStackView.addBackgroundColorWithTopCornerRadius(color: .white)
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
        
        prevButton.isEnabled = false
        nextButton.isEnabled = false
        
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
        
        
    }
    
    @objc func nextButtonTapped(){
        if imagesArray.count != 0 {
            currentImage = imagesArray[self.currentImageIndex]
            currentImageIndex = (currentImageIndex + 1) % imagesArray.count
            UIView.transition(with: self.swipeImageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.swipeImageView.image = self.imagesArray[self.currentImageIndex]
            })
        }
    }
    
    @objc func prevButtonTapped(){
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
        view.addSubview(visualEffectView)
        // constrain blurrEffectView
        visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(actionButton)
        actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        actionButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(swipeImageView)
        swipeImageView.topAnchor.constraint(equalTo: view.topAnchor, constant:  100).isActive = true
        swipeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        swipeImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        swipeImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(nextButton)
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 30).isActive = true
        nextButton.topAnchor.constraint(equalTo: swipeImageView.bottomAnchor, constant: 30).isActive = true
        
        view.addSubview(prevButton)
        prevButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        prevButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        prevButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30).isActive = true
        prevButton.topAnchor.constraint(equalTo: swipeImageView.bottomAnchor, constant: 30).isActive = true
        
        //MARK: constrain wishView
        transparentView.frame = self.view.frame
        self.view.addSubview(transparentView)
        transparentView.alpha = 0
        
        self.view.addSubview(self.wishView)
        wishView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        wishView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        wishConstraint = wishView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        wishConstraint.isActive = true
        
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
                                // do something
                                guard let title = data.pageTitle else { return }
            
                                print(title)
                                
                                guard let imageURL = data.imageUrl else { return }
                                UIImage.loadFrom(url: imageURL, completion: { (image) in
                                    self.swipeImageView.image = image
                                })
                            case let .failure(error, _):
                                // do something
                                print(error.localizedDescription)
                            }
                            
                        }
                        
                        self.doStuff(html: html)
                    }
                }
            }
    }
    
    func doStuff(html: String?){
        
        var imageCounter = 0
        
        do {
            let doc: Document = try SwiftSoup.parse(html ?? "")

            let priceClasses: Elements? = try doc.select("[class~=(?i)price]")

                for priceClass: Element in priceClasses!.array() {
                let priceText : String = try priceClass.text()
                print(try priceClass.className())
                print("pricetext: \(priceText)")
            }

            let srcs: Elements = try doc.select("img[src]")
            let srcsStringArray: [String?] = srcs.array().map { try? $0.attr("src").description }

            for imageName in srcsStringArray {
                if (imageName?.matches("^https?://(?:[a-z0-9\\-]+\\.)+[a-z]{2,6}(?:/[^/#?]+)+\\.(?:jpg|gif|png)$"))! {
                    
                    guard let url = URL(string: imageName!) else { return }
                    
                    UIImage.loadFrom(url: url) { image in
                        
                        if let image = image {
                            self.imagesArray.append(image)
                            imageCounter += 1
                            
                            if imageCounter == 1 {
                                self.swipeImageView.image = self.imagesArray[0]
                            }else if imageCounter == 2 {
                                self.prevButton.isEnabled = true
                                self.nextButton.isEnabled = true
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
    
    
}



