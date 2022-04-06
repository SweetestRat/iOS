//
//  ViewController.swift
//  Mobile Up Gallery
//
//  Created by Владислава Гильде on 31.03.2022.
//

import UIKit
import VK_ios_sdk
import CoreData

final class MainViewController: UIViewController {
    var galleryLabel: UILabel!
    var loginVKButton: UIButton!
    var galleryCollectionVC: GalleryCollectionViewController!
    var galleryNavigationController: UINavigationController!
    var container: NSPersistentContainer!
    var token: String!
    
    let white = UIColor(red: 249 / 255, green: 249 / 255, blue: 249 / 255, alpha: 1)
    let black = UIColor(red: 18 / 255, green: 18 / 255, blue: 18 / 255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.width/2)-2, height: (view.frame.height/4)-2)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.scrollDirection = .vertical
        
        galleryCollectionVC = GalleryCollectionViewController(collectionViewLayout: layout)
        galleryNavigationController = UINavigationController(rootViewController: galleryCollectionVC)
        galleryNavigationController.modalPresentationStyle = .fullScreen
//        galleryNavigationController.title = "Navigation Controller"
        
        let vkInstance = VKSdk.initialize(withAppId: "8122135")
        vkInstance?.uiDelegate = self as VKSdkUIDelegate
        vkInstance?.register(self as VKSdkDelegate)
        
        VKSdk.forceLogout() // for testing
        
        galleryLabel = UILabel()
        loginVKButton = UIButton()

        view.backgroundColor = white
        galleryLabel.text = "MobileUp Gallery"
        galleryLabel.numberOfLines = 2
        galleryLabel.textColor = black
        galleryLabel.font = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight.bold)
        galleryLabel.textAlignment = .left

        loginVKButton.backgroundColor = black
        loginVKButton.setTitle("Вход через VK", for: .normal)
        loginVKButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        loginVKButton.tintColor = white
        loginVKButton.layer.cornerRadius = 8

        loginVKButton.addTarget(self, action: #selector(vkAuth), for: .touchUpInside)

        [
            galleryLabel,
            loginVKButton,
        ].compactMap { $0 }
            .forEach {
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }

        NSLayoutConstraint.activate([
            galleryLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48),
            galleryLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 6),
            galleryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            galleryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 164),

            loginVKButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48),
            loginVKButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 14),
            loginVKButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginVKButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
        ])
    }

    @objc
    func vkAuth() {
        VKSdk.wakeUpSession([], complete: { [self] (state: VKAuthorizationState, error: Error?) in

            print("waking up session")
            if state != .authorized {
                VKSdk.authorize([])
            } else {
                present(self.galleryNavigationController, animated: true, completion: {})
            }
            
            if error != nil {
                let errorAlert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                present(errorAlert, animated: true, completion: {})
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if VKSdk.isLoggedIn() {
        present(galleryNavigationController, animated: true, completion: {})
        }
    }
    
    
}

extension MainViewController: VKSdkDelegate, VKSdkUIDelegate {
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        present(controller, animated: true, completion: {})
    }

    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
    }

    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil {
            print("Пользователь успешно авторизован")
            VKSdk.setAccessToken(result.token)
            token = VKSdk.accessToken().accessToken
            UserDefaults.standard.set(token, forKey: "token")
        } else if result.error != nil {
            print("Пользователь отменил авторизацию или произошла ошибка")
        }
    }

    func vkSdkUserAuthorizationFailed() {
    }
}
