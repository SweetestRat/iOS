//
//  ViewController.swift
//  MobileUp Gallery
//
//  Created by Владислава Гильде on 31.03.2022.
//

import UIKit
import WebKit

class mainViewController: UIViewController {

//    var webView: WKWebView!
//    var galleryLabel: UILabel!
    var loginVKButton: UIButton!
    
    let white = UIColor(red: 249, green: 249, blue: 249, alpha: 1)
    let black = UIColor(red: 18, green: 18, blue: 18, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        webView = WKWebView()
//        galleryLabel = UILabel()
        loginVKButton = UIButton()
        
        view.backgroundColor = white
//        galleryLabel.text = "MobileUp Gallery"
//        galleryLabel.numberOfLines = 2
//        galleryLabel.textColor = black
//        galleryLabel.font = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight.bold)
//        galleryLabel.textAlignment = .left
        
//        view.addSubview(webView)
//        view.addSubview(galleryLabel)
        view.addSubview(loginVKButton)
        
    }

//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        webView.frame = view.bounds
//    }

}

