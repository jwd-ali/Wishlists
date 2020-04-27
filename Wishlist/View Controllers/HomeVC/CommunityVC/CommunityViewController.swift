//
//  CommunityViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 01.03.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit
import SwiftSoup

class CommunityViewController: UIViewController {
    
    let backGroundImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "backgroundImage")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let backButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named: "backButton"), for: .normal)
        v.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        v.setImageTintColor(.white)
        return v
    }()
    
    let actionButton: CustomButton = {
        let v = CustomButton(type: .system)
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
    
    let priceLabel: UILabel = {
        let v = UILabel()
        v.text = ""
        v.font = UIFont(name: "AvenirNext-Bold", size: 23)
        v.numberOfLines = 0
        v.textAlignment = .center
        v.textColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let theImageView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .cyan
        return v
    }()
    
    
    
    let images = [UIImage]()
    
    var currentImage = 0

    override func viewDidLoad() {
        
        setupView()
        super.viewDidLoad()
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {


            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                if currentImage == images.count - 1 {
                    currentImage = 0

                }else{
                    currentImage += 1
                }
                theImageView.image = images[currentImage]

            case UISwipeGestureRecognizer.Direction.right:
                if currentImage == 0 {
                    currentImage = images.count - 1
                }else{
                    currentImage -= 1
                }
                theImageView.image = images[currentImage]
            default:
                break
            }
        }
    }
    
    
    
    func setupView() {
        
        view.addSubview(backGroundImage)
        view.addSubview(backButton)
        view.addSubview(actionButton)
        view.addSubview(priceLabel)
        view.addSubview(theImageView)
        
        backGroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backGroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backGroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backGroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        actionButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        theImageView.topAnchor.constraint(equalTo: view.topAnchor, constant:  100).isActive = true
        theImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        theImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        theImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        priceLabel.topAnchor.constraint(equalTo: theImageView.bottomAnchor, constant: 80).isActive = true
        priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    @objc func actionButtonTapped(){
        
        let url = "https://www.overkillshop.com/de/c2h4-interstellar-liaison-panelled-zip-up-windbreaker-r001-b012-vanward-black-grey.html"
        
        let url2 = "https://www.asos.com/de/asos-design/asos-design-schwarzer-backpack-mit-ringdetail-und-kroko-muster/prd/14253083?clr=schwarz&colourWayId=16603012&SearchQuery=&cid=4877"
        
        let url3 = "https://www.adidas.de/adistar-trikot/CV7089.html"
        
        let URLs = [url, url2, url3]
        
        do {
            

            let html: String = Utilities.getHTMLfromURL(url: URLs[0])
            let doc: Document = try SwiftSoup.parse(html)
            
            let priceClasses: Elements = try doc.select("[class~=(?i)price]")

            for priceClass: Element in priceClasses.array() {
                let priceText : String = try priceClass.text()
                print(try priceClass.className())
                print("pricetext: \(priceText)")
            }
            
            let srcs: Elements = try doc.select("img[src]")
            let srcsStringArray: [String?] = srcs.array().map { try? $0.attr("src").description }
            
            for imageName in srcsStringArray {
                print(imageName!)
            }
    
        } catch Exception.Error( _, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}



