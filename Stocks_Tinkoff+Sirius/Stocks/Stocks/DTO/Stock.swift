//
//  Stock.swift
//  Stocks
//
//  Created by Владислава Гильде on 11.02.2022.
//

import Foundation
import UIKit

struct Stock {
    let companyName: String
    let companyTicker: String
    let price: Double
    let change: Double
    let changePercent: Double
    var favourite: Bool = false
    var companyLogoUrl: String
}
