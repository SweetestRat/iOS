//
//  GalleryCollectionViewController.swift
//  Mobile Up Gallery
//
//  Created by Владислава Гильде on 04.04.2022.
//

import UIKit
import VK_ios_sdk

private let reuseIdentifier = "Cell"

final class GalleryCollectionViewController: UICollectionViewController {

    let white = UIColor(red: 249 / 255, green: 249 / 255, blue: 249 / 255, alpha: 1)
    let black = UIColor(red: 18 / 255, green: 18 / 255, blue: 18 / 255, alpha: 1)
    let requestSender = RequestSender()
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.modalPresentationStyle = .fullScreen
        
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        
        requestSender.getPhotosData(callback: { photosArray in
            DispatchQueue.main.async {
                self.photos = photosArray
                self.collectionView.reloadData()
            }
        })
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
        
        // Configure the cell
    
        
        // download logos
        
        let url = photos[indexPath.item].url
        
        if url == "" {
            return cell
        }
        
        let dataTask = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
                    guard
                        error == nil,
                        (response as? HTTPURLResponse)?.statusCode == 200,
                        let data = data,
                        let image = UIImage(data: data)
                    else {
                        print("Network error in all stocks response")
                        return
                    }
                    
                    DispatchQueue.main.async() {
                        cell.image.image = image
                        cell.image.layer.frame = CGRect(x: 0, y: 0, width: self.photos[indexPath.item].width, height: self.photos[indexPath.item].height)
                   }
                
                }
                dataTask.resume()
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //todo
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

// MARK: - Layouts

extension GalleryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width/2)-2, height: (view.frame.height/4)-2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
