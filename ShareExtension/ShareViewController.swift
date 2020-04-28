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
        let v = UIButton()
        v.setImage(UIImage(systemName: "arrow.left.square.fill"), for: .normal)
        v.tintColor = UIColor.darkCustom
        v.imageView?.contentMode = .scaleAspectFit
        v.contentHorizontalAlignment = .fill
        v.contentVerticalAlignment = .fill
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(prevButtonTapped), for: .touchUpInside)
        return v
    }()
    
    
    var imagesArray = [UIImage]()

    var currentImageIndex = 0
    
    var currentImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .clear
        self.navigationController?.isNavigationBarHidden = true
        
        setupViews()
        
    }
    
    @objc func nextButtonTapped(){
        currentImage = imagesArray[self.currentImageIndex]
        currentImageIndex = (currentImageIndex + 1) % imagesArray.count
        UIView.transition(with: self.swipeImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.swipeImageView.image = self.imagesArray[self.currentImageIndex]
        })
    }
    
    @objc func prevButtonTapped(){
        
    }
    

    
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
        
    }
    
    
    @objc private func cancelAction () {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }

    @objc private func doneAction() {
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
                        
                        self.doStuff(html: html)
                    }
                }
            }
    }
    
    func doStuff(html: String?){
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
                            print("append")
                           self.imagesArray.append(image)
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


public extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

extension UIImage {

    public static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

}

extension UIColor {
    
    static let darkCustom = UIColor(red: 31.0/255.0, green: 32.0/255.0, blue: 34.0/255.0, alpha: 1.0)
}
