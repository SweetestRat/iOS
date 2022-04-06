//
//  PhotoProfileViewController.swift
//  Mobile Up Gallery
//
//  Created by Владислава Гильде on 04.04.2022.
//

import UIKit

final class PhotoProfileViewController: UIViewController {
    
    var shareButton: UIBarButtonItem!
    var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    let navigationBar = UINavigationBar()

    override func viewDidLoad() {
        view.backgroundColor = .white
        shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareAction))
        navigationItem.rightBarButtonItem = shareButton
        self.navigationController?.navigationBar.tintColor = .black
        
        imageView.backgroundColor = .systemBlue
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    // MARK: - objc functions
    
    @objc
    func shareAction() {
        let shareController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
    }
    
    @objc
    func popToPrevious() {
        self.navigationController?.popViewController(animated: true)
    }
}
