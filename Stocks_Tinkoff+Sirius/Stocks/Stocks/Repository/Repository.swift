//
//  IexCloudRepository.swift
//  Stocks
//
//  Created by Владислава Гильде on 11.02.2022.
//

import Foundation

protocol Repository {
    func getStocksData(callback: @escaping ([Stock], String) -> Void)
    func parseData(data: Data)  -> [Stock]
    
    func parseLogoRequest(data: Data) -> String
    func getStocksLogoUrl(stocks: [Stock], callback: @escaping (String, Int) -> Void)
    
    func getStockPriceInTimePeriod(companyTicker: String, period: String, callback: @escaping ([StockDataInTimePeriod], String) -> Void)
    func parseDataInTimePeriod(data: Data) -> [StockDataInTimePeriod]
}
