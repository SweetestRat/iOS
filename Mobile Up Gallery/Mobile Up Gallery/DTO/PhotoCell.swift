//
//  PhotoCell.swift
//  Mobile Up Gallery
//
//  Created by Владислава Гильде on 05.04.2022.
//

import UIKit

final class PhotoCell: UICollectionViewCell {
    var imageView = UIImageView()
    var image = UIImage()
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.layer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
