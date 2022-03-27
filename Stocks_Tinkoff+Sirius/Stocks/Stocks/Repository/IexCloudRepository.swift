//
//  IexCloudRepository.swift
//  Stocks
//
//  Created by Владислава Гильде on 11.02.2022.
//

import Foundation
import UIKit

class IexCloudRepository : Repository {
        
    var customError = ""
    
    func getStocksData(callback: @escaping ([Stock], String) -> Void) {
        let url = URL(string: "https://cloud.iexapis.com/stable/stock/market/list/gainers/?token=pk_9f15933cc0354525a4c1934d298f4c8d")!
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                self.customError = "Network error"
                callback([], self.customError)
                return
            }
            
            let stocks = self.parseData(data: data)
            callback(stocks, self.customError)
        }
        
        dataTask.resume()
    }
    
    func getStocksLogoUrl(stocks: [Stock], callback: @escaping (String, Int) -> Void) {
        
        for item in 0..<stocks.count {
            
            let ticker = stocks[item].companyTicker
            
            let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(ticker)/logo/?token=pk_9f15933cc0354525a4c1934d298f4c8d")!
            
            let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    error == nil,
                    (response as? HTTPURLResponse)?.statusCode == 200,
                    let data = data
                else {
                    print("Network error :(")
                    return
                }
                
                let companyLogoUrl = self.parseLogoRequest(data: data)
                
                callback(companyLogoUrl, item)
            }
            
            dataTask.resume()
        }
    }
    
    func getStockPriceInTimePeriod(companyTicker: String, period: String, callback: @escaping ([StockDataInTimePeriod], String) -> Void) {
        
        let ticker = companyTicker
        var networkError = ""
        
        let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(ticker)/chart/\(period)/?token=pk_9f15933cc0354525a4c1934d298f4c8d")!
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                networkError = "Network error"
                callback([], networkError)
                return
            }
            
            let stockData = self.parseDataInTimePeriod(data: data)
            
            callback(stockData, networkError)
        }
        
        dataTask.resume()
    }
    
    func parseData(data: Data) -> [Stock] {

        var stocks: [Stock] = []
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSArray
            
            for jsonElement in jsonObject! {
                guard
                    let json = jsonElement as? [String: Any],
                    let companyName = json["companyName"] as? String,
                    let companySymbol = json["symbol"] as? String,
                    let price = json["latestPrice"] as? Double,
                    let priceChange = json["change"] as? Double,
                    let changePercent = json["changePercent"] as? Double
                else {
                    print("Invalid JSON format")
                    return []
                }
                
                stocks.append(Stock(companyName: companyName, companyTicker: companySymbol, price: price, change: priceChange, changePercent: changePercent, companyLogoUrl: ""))
            }
            
            return stocks
           
        } catch {
            print("! JSON parsing error" + error.localizedDescription)
            return []
        }
    }
    
    func parseLogoRequest(data: Data) -> String {
        
        var logoUrl = ""
        
        do {
            
        let jsonObject = try JSONSerialization.jsonObject(with: data)
            guard
                let json = jsonObject as? [String: Any],
                let companyLogoUrl = json["url"] as? String
            else {
                print("Invalid JSON format")
                return ""
            }
            
            logoUrl = companyLogoUrl
        } catch {
            print("! JSON parsing error" + error.localizedDescription)
            return ""
        }
        
        return logoUrl
    }
    
    func parseDataInTimePeriod(data: Data) -> [StockDataInTimePeriod] {
        
        var stockData: [StockDataInTimePeriod] = []
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSArray
            
            for jsonElement in jsonObject! {
                guard
                    let json = jsonElement as? [String: Any],
                    let open = json["open"] as? Double,
                    let close = json["close"] as? Double,
                    let high = json["high"] as? Double,
                    let low = json["low"] as? Double,
                    let date = json["date"] as? String
                else {
                    print("Invalid JSON format")
                    return []
                }
                
                stockData.append(StockDataInTimePeriod(open: open, close: close, high: high, low: low, date: date))
            }
            
            return stockData
           
        } catch {
            print("! JSON parsing error" + error.localizedDescription)
            return []
        }
    }
}
