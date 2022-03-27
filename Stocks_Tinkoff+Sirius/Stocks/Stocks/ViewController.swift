//
//  ViewController.swift
//  Stocks
//
//  Created by Владислава Гильде on 07.02.2022.
//

import UIKit
import Charts

class ViewController: UIViewController, ChartViewDelegate, UITableViewDataSource, UITableViewDelegate {

    var gainers: UILabel!
    var tableView: UITableView!
    var stocks: [Stock] = []
    var reloadRowIndex: Int!
    var candleChartView: CandleStickChartView!
    var iexcloudRepository: IexCloudRepository!
    var stockProfileViewController: StockProfileViewController!
    var activityIndicator: UIActivityIndicatorView!
    let networkErrorAlert = UIAlertController(title: "Network error", message: nil, preferredStyle: .alert)
    let failedToLoadDataErrorAlert = UIAlertController(title: "Failed to load data", message: nil, preferredStyle: .alert)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
            .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        
        networkErrorAlert.addAction(.init(title: "Cancel", style: .destructive, handler: nil))
        networkErrorAlert.addAction(.init(title: "Reload", style: .default, handler: { _ in self.sendRequest() }))
        
        failedToLoadDataErrorAlert.addAction(.init(title: "Cancel", style: .destructive, handler: nil))
        failedToLoadDataErrorAlert.addAction(.init(title: "Reload", style: .default, handler: { _ in self.sendRequest() }))
        
        // characteristics
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        gainers = UILabel()
        stockProfileViewController = StockProfileViewController()
        iexcloudRepository = IexCloudRepository()
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StockCell.self, forCellReuseIdentifier: "tableCell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .none
        tableView.layer.cornerRadius = 15
        
        gainers.text = "GAINERS"
        gainers.font = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.bold)
        gainers.textColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        
        addSubviews()
        setConstraints()
        

        //for testing
        
//        do {
//            if let bundle = Bundle.main.path(forResource: "gainersData", ofType: "test"),
//            let jsonData = try String(contentsOfFile: bundle).data(using: .utf8) {
//                let data = iexcloudRepository.parseData(data: jsonData)
//                stocks = data
//                tableView.reloadData()
//                activityIndicator.stopAnimating()
//            }
//        } catch {
//            print(error)
//        }
        
        sendRequest()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let reloadIndex = reloadRowIndex else { return }
        tableView.reloadRows(at: [IndexPath(row: reloadIndex, section: 0)], with: .fade)
        
        stocks.sort(by: { $0.favourite == true && $0.favourite != $1.favourite })
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }
    
    func addSubviews() {
        [
            candleChartView,
            tableView,
            gainers,
            activityIndicator
        ].compactMap { $0 }
        .forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: gainers.bottomAnchor, constant: 40),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            tableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -68),
            tableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            gainers.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            gainers.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func searchStockIndex(ticker: String, stocks: [Stock]) -> Int? {
        return stocks.firstIndex { $0.companyTicker == ticker }
    }
    
    func sendRequest() {
        iexcloudRepository.getStocksData(callback: {(stockslist, error) in
            DispatchQueue.main.sync {
                self.stocks = stockslist
                self.tableView.reloadData()
                
                if error == "Network error" {
                    self.present(self.networkErrorAlert, animated: true, completion: nil)
                }
                
                if stockslist.count == 0 {
                    self.present(self.failedToLoadDataErrorAlert, animated: true, completion: nil)
                }
            }

            self.iexcloudRepository.getStocksLogoUrl(stocks: self.stocks) { (logoUrl, item) in
                DispatchQueue.main.async {
                    self.stocks[item].companyLogoUrl = logoUrl
                    self.tableView.reloadRows(at: [IndexPath(row: item, section: 0)], with: .fade)
                    self.activityIndicator.stopAnimating()
                }
            }
        })
        
    }
 
    // MARK: - System methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as? StockCell
        else {
            print("Unable to dequeue StockCell")
            return StockCell()
        }
        
        // characteristics
        
        cell.ticker.text = stocks[indexPath.row].companyTicker
        
        cell.change.text = String(stocks[indexPath.row].change)
        
        if cell.change.text != nil {
        cell.change.text = stocks[indexPath.row].change > 0 ?
        ("+" + cell.change.text!) :
        cell.change.text!
        }
        
        cell.change.textColor = stocks[indexPath.row].change > 0 ?
        UIColor(red: 38/255, green: 142/255, blue: 36/255, alpha: 1) :
        UIColor(red: 198/255, green: 60/255, blue: 30/255, alpha: 1)
        
        let changePercentRounded = Double(round(1000*stocks[indexPath.row].changePercent)/10)
        cell.changePercent.text = "(" + String(changePercentRounded) + "%)"
        cell.changePercent.textColor = cell.change.textColor
        
        cell.favourite = stocks[indexPath.row].favourite
        
        if cell.favourite {
            cell.favouriteIconFill.isHidden = false
            cell.favouriteIconEmpty.isHidden = true
        } else {
            cell.favouriteIconFill.isHidden = true
            cell.favouriteIconEmpty.isHidden = false
        }
        
        // download logos
        
        let url = stocks[indexPath.row].companyLogoUrl
        
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
                        cell.companyLogo.image = image
                   }
                
                }
                dataTask.resume()
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        stockProfileViewController.modalPresentationStyle = .fullScreen
        stockProfileViewController.companyTicker.text = stocks[indexPath.row].companyTicker
        stockProfileViewController.companyName.text = stocks[indexPath.row].companyName
        stockProfileViewController.price.text = String(stocks[indexPath.row].price) + "$"
        
        stockProfileViewController.change.text = stocks[indexPath.row].change > 0 ?
        ("+" + String(stocks[indexPath.row].change)) :
        String(stocks[indexPath.row].change)
        stockProfileViewController.change.textColor = stocks[indexPath.row].change > 0 ?
        UIColor(red: 38/255, green: 142/255, blue: 36/255, alpha: 1) :
        UIColor(red: 198/255, green: 60/255, blue: 30/255, alpha: 1)
        
        let changePercentRounded = Double(round(1000*stocks[indexPath.row].changePercent)/10)
        stockProfileViewController.changePercent.text = "(" + String(changePercentRounded) + "%)"
        stockProfileViewController.changePercent.textColor = stocks[indexPath.row].change > 0 ?
        UIColor(red: 38/255, green: 142/255, blue: 36/255, alpha: 1) :
        UIColor(red: 198/255, green: 60/255, blue: 30/255, alpha: 1)
        stockProfileViewController.suggestedStocks = stocks
        
        stockProfileViewController.callbackFunction = { (ticker) in
            DispatchQueue.main.async {
            guard let index = self.searchStockIndex(ticker: ticker, stocks: self.stocks) else { return }
            self.stocks[index].favourite = !self.stocks[index].favourite
            self.reloadRowIndex = index
            }
        }
        
        stockProfileViewController.favourite = self.stocks[indexPath.row].favourite
        
        if self.stockProfileViewController.favourite {
            stockProfileViewController.favouriteButtonFill.isHidden = false
            stockProfileViewController.favouriteButtonEmpty.isHidden = true
        } else {
            stockProfileViewController.favouriteButtonFill.isHidden = true
            stockProfileViewController.favouriteButtonEmpty.isHidden = false
        }
        
        self.show(stockProfileViewController, sender: self)
    }
}
