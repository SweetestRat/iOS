//
//  StockCell.swift
//  Stocks
//
//  Created by Владислава Гильде on 11.02.2022.
//

import Foundation
import UIKit

class StockCell: UITableViewCell {
    
    let ticker = UILabel()
    let change = UILabel()
    let changePercent = UILabel()
    var favouriteIconEmpty = UIButton()
    var favouriteIconFill = UIButton()
    let companyLogo = UIImageView()
    let rect = UIView()
    var favourite: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // add subviews
        
        [
            rect,
            ticker,
            companyLogo,
            change,
            changePercent,
            favouriteIconFill,
            favouriteIconEmpty
        ].compactMap { $0 }
            .forEach {
                self.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        // characteristics
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .none
        self.selectedBackgroundView = backgroundView
        self.backgroundColor = .none
        
        favouriteIconFill.isHidden = true
        favouriteIconEmpty.tintColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        favouriteIconFill.tintColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        
        favouriteIconFill.setImage(UIImage(systemName: "star.fill"), for: .normal)
        favouriteIconEmpty.setImage(UIImage(systemName: "star"), for: .normal)
        
        rect.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        rect.layer.cornerRadius = 15
        
        ticker.textColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)

        companyLogo.layer.cornerRadius = 25
        companyLogo.clipsToBounds = true
        
        change.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)        
        changePercent.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)

        // constraints
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 90),
            
            rect.widthAnchor.constraint(equalTo: self.widthAnchor),
            rect.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -20),
            rect.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rect.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            ticker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 90),
            ticker.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            
            companyLogo.widthAnchor.constraint(equalToConstant: 50),
            companyLogo.heightAnchor.constraint(equalTo: companyLogo.widthAnchor),
            companyLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            companyLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            
            change.topAnchor.constraint(equalTo: ticker.bottomAnchor, constant: 6),
            change.leadingAnchor.constraint(equalTo: ticker.leadingAnchor),
            
            changePercent.leadingAnchor.constraint(equalTo: change.trailingAnchor, constant: 3),
            changePercent.topAnchor.constraint(equalTo: change.topAnchor),
            
            favouriteIconEmpty.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            favouriteIconEmpty.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            favouriteIconFill.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            favouriteIconFill.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
