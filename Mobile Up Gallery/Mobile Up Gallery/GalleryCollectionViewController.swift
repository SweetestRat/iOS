//
//  GalleryCollectionViewController.swift
//  Mobile Up Gallery
//
//  Created by Владислава Гильде on 04.04.2022.
//

import UIKit
import VK_ios_sdk

final class GalleryCollectionViewController: UICollectionViewController {
    
    private let photoProfileViewController = PhotoProfileViewController()

    private let alert = UIAlertController(title: "Something wrong", message: "", preferredStyle: .alert)
    private let requestSender = RequestSender()
    private var photos: [Photo] = []
    private let galleryLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationStyle = .fullScreen

        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        
        let logoutButton = UIBarButtonItem(title: "Выход", style: .plain, target: self, action: #selector(logout))
        logoutButton.tintColor = UIColor(named: "black")
        navigationItem.rightBarButtonItem = logoutButton

        navigationItem.title = "Mobile Up Gallery"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "black")]
        self.navigationController?.navigationBar.tintColor = .white
        
        requestSender.getPhotosData(callback: { photosArray in
            DispatchQueue.main.async {
                self.photos = photosArray
                self.collectionView.reloadData()
            }
        })
    }

    // MARK: - objc functions

    @objc
    func logout() {
        VKSdk.forceLogout()
        UserDefaults.standard.removeObject(forKey: "token")
        
        let mainVC = MainViewController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: false, completion: nil)
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell
        else {
            print("Unable to dequeue PhotoCell")
            return PhotoCell()
        }
        // download logos

        let url = photos[indexPath.item].url

        if url == "" {
            return cell
        }

        let dataTask = URLSession.shared.dataTask(with: URL(string: url)!) {[self] data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data,
                let image = UIImage(data: data)
            else {
                self.alert.message = error?.localizedDescription
                self.alert.present(self.alert, animated: true, completion: {})
                print("Network error")
                return
            }

            DispatchQueue.main.async {
                cell.imageView.image = image
                cell.imageView.layer.frame = CGRect(x: 0, y: 0, width: self.photos[indexPath.item].width, height: self.photos[indexPath.item].height)
                cell.image = image
            }
        }
        dataTask.resume()

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photoProfileViewController.modalPresentationStyle = .fullScreen

        let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell
        photoProfileViewController.imageView.image = cell?.image

        navigationController?.pushViewController(photoProfileViewController, animated: true)
    }
}

// MARK: - Layouts

extension GalleryCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 2) - 2, height: (view.frame.height / 4) - 2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
