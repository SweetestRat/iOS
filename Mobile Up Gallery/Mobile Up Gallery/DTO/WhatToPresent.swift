//
//  WhatToPresent.swift
//  Mobile Up Gallery
//
//  Created by Владислава Гильде on 04.04.2022.
//

import UIKit
import VK_ios_sdk

final class WhatToPresent {
    
    let galleryNavigationController = UINavigationController(rootViewController: GalleryCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()))
    
    func getRootController() -> UIViewController {
        if UserDefaults.standard.string(forKey: "token") != nil{
            return galleryNavigationController
        } else {
            return MainViewController()
        }
    }
}
