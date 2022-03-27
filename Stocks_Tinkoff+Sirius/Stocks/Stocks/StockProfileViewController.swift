//
//  ProfileViewController.swift
//  Stocks
//
//  Created by Владислава Гильде on 12.02.2022.
//

import Foundation
import UIKit
import Charts

class StockProfileViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    var profileBar: UIView!
    var companyTicker = UILabel()
    var companyName = UILabel()
    var price = UILabel()
    var change = UILabel()
    var changePercent = UILabel()
    var suggestedLabel: UILabel!
    var suggestedTableView: UITableView!
    var candleStickChartView: CandleStickChartView!
    var fiveDaysButton: UIButton!
    var oneMonthButton: UIButton!
    var threeMonthButton: UIButton!
    var sixMonthButton: UIButton!
    var backButton: UIButton!
    var selectedButton: String = "6m"
    var favourite: Bool = false
    var favouriteButtonFill = UIButton()
    var favouriteButtonEmpty = UIButton()
    var suggestedStocks: [Stock] = []
    var stocksDataInTimePeriod: [StockDataInTimePeriod]!
    var candleChartDataEntries: [CandleChartDataEntry]!
    var candleChartDataSet: CandleChartDataSet!
    var iexcloudRepository: IexCloudRepository!
    var activityIndicator: UIActivityIndicatorView!
    var callbackFunction: ((String) -> Void)!
    let networkErrorAlert = UIAlertController(title: "Network error", message: nil, preferredStyle: .alert)
    let failedToLoadChartDataErrorAlert = UIAlertController(title: "Failed to load chart data", message: nil, preferredStyle: .alert)
    
    override func viewDidLoad() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        view.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        
        networkErrorAlert.addAction(.init(title: "Cancel", style: .destructive, handler: nil))
        networkErrorAlert.addAction(.init(title: "Reload", style: .default, handler: { _ in self.sendRequest() }))
        
        failedToLoadChartDataErrorAlert.addAction(.init(title: "Cancel", style: .destructive, handler: nil))
        failedToLoadChartDataErrorAlert.addAction(.init(title: "Reload", style: .default, handler: { _ in self.sendRequest() }))
        
        profileBar = UIView()
        candleStickChartView = CandleStickChartView()
        iexcloudRepository = IexCloudRepository()
        suggestedTableView = UITableView()
        suggestedLabel = UILabel()
        fiveDaysButton = UIButton()
        oneMonthButton = UIButton()
        threeMonthButton = UIButton()
        sixMonthButton = UIButton()
        backButton = UIButton()
        
        profileBar.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(goBackwards), for: .touchUpInside)
        backButton.tintColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        
        favouriteButtonEmpty.tintColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        favouriteButtonFill.tintColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        
        favouriteButtonFill.setImage(UIImage(systemName: "star.fill"), for: .normal)
        favouriteButtonEmpty.setImage(UIImage(systemName: "star"), for: .normal)
        
        favouriteButtonFill.addTarget(self, action: #selector(removeFromFavourites), for: .touchUpInside)
        favouriteButtonEmpty.addTarget(self, action: #selector(addToFavourites), for: .touchUpInside)
        
        fiveDaysButton.setTitle("5d", for: .normal)
        oneMonthButton.setTitle("1m", for: .normal)
        threeMonthButton.setTitle("3m", for: .normal)
        sixMonthButton.setTitle("6m", for: .normal)
        
        fiveDaysButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        oneMonthButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        threeMonthButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        sixMonthButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        
        fiveDaysButton.setTitleColor(UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1), for: .normal)
        oneMonthButton.setTitleColor(UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1), for: .normal)
        threeMonthButton.setTitleColor(UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1), for: .normal)
        sixMonthButton.setTitleColor(UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1), for: .normal)
        
        fiveDaysButton.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        oneMonthButton.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        threeMonthButton.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        sixMonthButton.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        
        fiveDaysButton.layer.cornerRadius = 10
        oneMonthButton.layer.cornerRadius = 10
        threeMonthButton.layer.cornerRadius = 10
        sixMonthButton.layer.cornerRadius = 10
        
        fiveDaysButton.addTarget(self, action: #selector(fiveDaysButtonSelected), for: .touchUpInside)
        oneMonthButton.addTarget(self, action: #selector(oneMonthButtonSelected), for: .touchUpInside)
        threeMonthButton.addTarget(self, action: #selector(threeMonthButtonSelected), for: .touchUpInside)
        sixMonthButton.addTarget(self, action: #selector(sixMonthButtonSelected), for: .touchUpInside)
        
        suggestedLabel.text = "Top by growth today"
        suggestedLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        suggestedLabel.textColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        
        candleStickChartView.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        candleStickChartView.layer.cornerRadius = 15
        candleStickChartView.clipsToBounds = true
        candleStickChartView.legend.enabled = false
        candleStickChartView.xAxis.labelPosition = .bottom
        candleStickChartView.rightAxis.enabled = false
        candleStickChartView.leftAxis.axisLineColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        candleStickChartView.xAxis.axisLineColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        candleStickChartView.leftAxis.labelTextColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        candleStickChartView.xAxis.labelTextColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        
        suggestedTableView.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        suggestedTableView.layer.cornerRadius = 15
        suggestedTableView.dataSource = self
        suggestedTableView.delegate = self
        suggestedTableView.register(StockCell.self, forCellReuseIdentifier: "suggestedTableCell")
        suggestedTableView.separatorStyle = .none
        suggestedTableView.showsVerticalScrollIndicator = false
        
        companyTicker.font = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.bold)
        companyTicker.textColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        
        companyName.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.regular)
        companyName.textColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        
        price.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        price.textColor =  UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        
        change.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        
        changePercent.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        
        suggestedStocks.sort { $0.change > $1.change }
        
        addSubviews()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // for testing
        
//        do {
//            if let bundle = Bundle.main.path(forResource: "stocksCandlesForChart", ofType: "test"),
//            let jsonData = try String(contentsOfFile: bundle).data(using: .utf8) {
//                let data = iexcloudRepository.parseDataInTimePeriod(data: jsonData)
//                stocksDataInTimePeriod = data
//                candleChartDataEntries = getEntries(data: stocksDataInTimePeriod)
//                drawChart(entries: candleChartDataEntries)
//                activityIndicator.stopAnimating()
//            }
//        } catch {
//            print(error)
//        }
        
        sendRequest()
    }
    
    func addSubviews() {
        [
            profileBar,
            backButton,
            candleStickChartView,
            suggestedLabel,
            suggestedTableView,
            companyTicker,
            favouriteButtonFill,
            favouriteButtonEmpty,
            companyName,
            price,
            change,
            changePercent,
            fiveDaysButton,
            oneMonthButton,
            threeMonthButton,
            sixMonthButton,
            activityIndicator
        ].compactMap { $0 }
        .forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
           
            profileBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            profileBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.20),
            profileBar.topAnchor.constraint(equalTo: view.topAnchor),
            profileBar.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            backButton.heightAnchor.constraint(equalTo: companyTicker.heightAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: companyTicker.topAnchor),
            
            favouriteButtonFill.heightAnchor.constraint(equalTo: companyTicker.heightAnchor),
            favouriteButtonFill.leadingAnchor.constraint(equalTo: companyTicker.trailingAnchor, constant: 8),
            favouriteButtonFill.topAnchor.constraint(equalTo: companyTicker.topAnchor),
            
            favouriteButtonEmpty.heightAnchor.constraint(equalTo: companyTicker.heightAnchor),
            favouriteButtonEmpty.leadingAnchor.constraint(equalTo: companyTicker.trailingAnchor, constant: 8),
            favouriteButtonEmpty.topAnchor.constraint(equalTo: companyTicker.topAnchor),
            
            candleStickChartView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            candleStickChartView.topAnchor.constraint(equalTo: profileBar.bottomAnchor, constant: 20),
            candleStickChartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            candleStickChartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            candleStickChartView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.4),
            
            activityIndicator.centerXAnchor.constraint(equalTo: candleStickChartView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: candleStickChartView.centerYAnchor),
            
            oneMonthButton.widthAnchor.constraint(equalToConstant: 50),
            oneMonthButton.heightAnchor.constraint(equalToConstant: 25),
            oneMonthButton.topAnchor.constraint(equalTo: candleStickChartView.bottomAnchor, constant: 15),
            oneMonthButton.trailingAnchor.constraint(equalTo: candleStickChartView.centerXAnchor, constant: -6),
            
            fiveDaysButton.widthAnchor.constraint(equalTo: oneMonthButton.widthAnchor),
            fiveDaysButton.heightAnchor.constraint(equalTo: oneMonthButton.heightAnchor),
            fiveDaysButton.topAnchor.constraint(equalTo: oneMonthButton.topAnchor),
            fiveDaysButton.trailingAnchor.constraint(equalTo: oneMonthButton.leadingAnchor, constant: -12),
            
            threeMonthButton.widthAnchor.constraint(equalTo: oneMonthButton.widthAnchor),
            threeMonthButton.heightAnchor.constraint(equalTo: oneMonthButton.heightAnchor),
            threeMonthButton.topAnchor.constraint(equalTo: oneMonthButton.topAnchor),
            threeMonthButton.leadingAnchor.constraint(equalTo: candleStickChartView.centerXAnchor, constant: 6),
            
            sixMonthButton.widthAnchor.constraint(equalTo: oneMonthButton.widthAnchor),
            sixMonthButton.heightAnchor.constraint(equalTo: oneMonthButton.heightAnchor),
            sixMonthButton.topAnchor.constraint(equalTo: oneMonthButton.topAnchor),
            sixMonthButton.leadingAnchor.constraint(equalTo: threeMonthButton.trailingAnchor, constant: 12),
            
            suggestedLabel.topAnchor.constraint(equalTo: oneMonthButton.bottomAnchor, constant: 20),
            suggestedLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            suggestedTableView.topAnchor.constraint(equalTo: suggestedLabel.bottomAnchor, constant: 20),
            suggestedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            suggestedTableView.widthAnchor.constraint(equalTo: candleStickChartView.widthAnchor),
            suggestedTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            companyTicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            companyTicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 45),
            
            companyName.leadingAnchor.constraint(greaterThanOrEqualTo: companyTicker.trailingAnchor, constant: 65),
            companyName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            companyName.centerYAnchor.constraint(equalTo: companyTicker.centerYAnchor),
            
            price.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            price.topAnchor.constraint(equalTo: companyTicker.bottomAnchor, constant: 20),
            
            changePercent.topAnchor.constraint(equalTo: price.topAnchor),
            changePercent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            change.topAnchor.constraint(equalTo: price.topAnchor),
            change.trailingAnchor.constraint(equalTo: changePercent.leadingAnchor, constant: -3)
            ])
    }
    
    func getEntries(data: [StockDataInTimePeriod]) -> [CandleChartDataEntry] {
        var entries: [CandleChartDataEntry] = []
        
        for item in 0..<data.count {
            let entry = CandleChartDataEntry(x: Double(item), shadowH: stocksDataInTimePeriod[item].high, shadowL: stocksDataInTimePeriod[item].low, open: stocksDataInTimePeriod[item].open, close: stocksDataInTimePeriod[item].close, data: stocksDataInTimePeriod[item].date)
            
            entries.append(entry)
        }
        
        return entries
    }
    
    func sendRequest() {
        iexcloudRepository.getStockPriceInTimePeriod(companyTicker: self.companyTicker.text!, period: selectedButton) { (stockData, error) in
            DispatchQueue.main.async {
                self.stocksDataInTimePeriod = stockData
                self.candleChartDataEntries = self.getEntries(data: self.stocksDataInTimePeriod)
                self.drawChart(entries: self.candleChartDataEntries)
                self.activityIndicator.stopAnimating()
                
                if error == "Network error" {
                    self.present(self.networkErrorAlert, animated: true, completion: nil)
                }
                
                if stockData.count == 0 {
                    self.present(self.failedToLoadChartDataErrorAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func drawChart(entries: [CandleChartDataEntry]) {
        candleChartDataSet = CandleChartDataSet(entries: entries)
        candleChartDataSet.decreasingColor = UIColor(red: 198/255, green: 60/255, blue: 30/255, alpha: 1)
        candleChartDataSet.increasingColor = UIColor(red: 38/255, green: 142/255, blue: 36/255, alpha: 1)
        candleChartDataSet.increasingFilled = true
        candleChartDataSet.shadowColorSameAsCandle = true
        candleChartDataSet.drawValuesEnabled = false
        candleChartDataSet.neutralColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        
        let data = CandleChartData(dataSet: candleChartDataSet)
        candleStickChartView.data = data
    }
    
    @objc func goBackwards() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func removeFromFavourites() {
        favouriteButtonFill.isHidden = true
        favouriteButtonEmpty.isHidden = false
        favourite = false
        
        let index = searchSuggestedIndex(ticker: companyTicker.text!, suggestedStocks: suggestedStocks)!
        suggestedStocks[index].favourite = !suggestedStocks[index].favourite
        suggestedTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        let ticker = String(companyTicker.text ?? "")
        callbackFunction(ticker)
    }
    
    @objc func addToFavourites() {
        favouriteButtonFill.isHidden = false
        favouriteButtonEmpty.isHidden = true
        favourite = true
        
        let index = searchSuggestedIndex(ticker: companyTicker.text!, suggestedStocks: suggestedStocks)!
        suggestedStocks[index].favourite = !suggestedStocks[index].favourite
        suggestedTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        let ticker = String(companyTicker.text ?? "")
        callbackFunction(ticker)
    }
    
    func searchStockIndex(ticker: String, stocks: [Stock]) -> Int? {
        return stocks.firstIndex { $0.companyTicker == ticker }
    }
    
    func searchSuggestedIndex(ticker: String, suggestedStocks: [Stock]) -> Int? {
        return suggestedStocks.firstIndex { $0.companyTicker == ticker}
    }
    
    @objc func fiveDaysButtonSelected() {
        selectedButton = "5d"
        
        fiveDaysButton.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        fiveDaysButton.setTitleColor(UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1), for: .normal)
        
        oneMonthButton.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        oneMonthButton.setTitleColor(UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1), for: .normal)
        threeMonthButton.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        threeMonthButton.setTitleColor(UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1), for: .normal)
        sixMonthButton.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        sixMonthButton.setTitleColor(UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1), for: .normal)
        
        guard var stockDataSlice = stocksDataInTimePeriod else { return }
        stockDataSlice = stockDataSlice.suffix(5)
        self.candleChartDataEntries = self.getEntries(data: stockDataSlice)
        self.drawChart(entries: self.candleChartDataEntries)
    }
    
    @objc func oneMonthButtonSelected() {
        selectedButton = "1m"
        
        oneMonthButton.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        oneMonthButton.setTitleColor(UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1), for: .normal)
        
        fiveDaysButton.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        fiveDaysButton.setTitleColor(UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1), for: .normal)
        threeMonthButton.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        threeMonthButton.setTitleColor(UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1), for: .normal)
        sixMonthButton.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        sixMonthButton.setTitleColor(UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1), for: .normal)
        
        guard var stockDataSlice = stocksDataInTimePeriod else { return }
        stockDataSlice = stockDataSlice.suffix(30)
        self.candleChartDataEntries = self.getEntries(data: stockDataSlice)
        self.drawChart(entries: self.candleChartDataEntries)
    }
    
    @objc func threeMonthButtonSelected() {
        selectedButton = "3m"
        
        threeMonthButton.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        threeMonthButton.setTitleColor(UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1), for: .normal)
        
        fiveDaysButton.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        fiveDaysButton.setTitleColor(UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1), for: .normal)
        oneMonthButton.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        oneMonthButton.setTitleColor(UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1), for: .normal)
        sixMonthButton.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        sixMonthButton.setTitleColor(UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1), for: .normal)
        
        guard var stockDataSlice = stocksDataInTimePeriod else { return }
        stockDataSlice = stockDataSlice.suffix(90)
        self.candleChartDataEntries = self.getEntries(data: stockDataSlice)
        self.drawChart(entries: self.candleChartDataEntries)
    }
    
    @objc func sixMonthButtonSelected() {
        selectedButton = "6m"
        
        sixMonthButton.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        sixMonthButton.setTitleColor(UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1), for: .normal)
        
        fiveDaysButton.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        fiveDaysButton.setTitleColor(UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1), for: .normal)
        oneMonthButton.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        oneMonthButton.setTitleColor(UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1), for: .normal)
        threeMonthButton.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        threeMonthButton.setTitleColor(UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1), for: .normal)
        
        guard var stockDataSlice = stocksDataInTimePeriod else { return }
        stockDataSlice = stockDataSlice.suffix(180)
        self.candleChartDataEntries = self.getEntries(data: stockDataSlice)
        self.drawChart(entries: self.candleChartDataEntries)
    }
    
    
    // MARK: - System functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestedStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = suggestedTableView.dequeueReusableCell(withIdentifier: "suggestedTableCell", for: indexPath) as? StockCell
        else {
            print("Unable to dequeue StockCell")
            return StockCell()
        }
        
        // characteristics
        
        cell.ticker.text = suggestedStocks[indexPath.row].companyTicker
        
        cell.change.text = String(suggestedStocks[indexPath.row].change)
        
        if cell.change.text != nil {
        cell.change.text = suggestedStocks[indexPath.row].change > 0 ?
        ("+" + cell.change.text!) :
        cell.change.text!
        }
        
        cell.change.textColor = suggestedStocks[indexPath.row].change > 0 ?
        UIColor(red: 38/255, green: 142/255, blue: 36/255, alpha: 1) :
        UIColor(red: 198/255, green: 60/255, blue: 30/255, alpha: 1)
        
        let changePercentRounded = Double(round(1000*suggestedStocks[indexPath.row].changePercent)/10)
        cell.changePercent.text = "(" + String(changePercentRounded) + "%)"
        cell.changePercent.textColor = cell.change.textColor
        
        if suggestedStocks[indexPath.row].favourite {
            cell.favouriteIconFill.isHidden = false
            cell.favouriteIconEmpty.isHidden = true
        } else {
            cell.favouriteIconFill.isHidden = true
            cell.favouriteIconEmpty.isHidden = false
        }
        
        //download logos
        
        let url = suggestedStocks[indexPath.row].companyLogoUrl
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        companyTicker.text = suggestedStocks[indexPath.row].companyTicker
        companyName.text = suggestedStocks[indexPath.row].companyName
        price.text = String(suggestedStocks[indexPath.row].price) + "$"
        
        change.text = suggestedStocks[indexPath.row].change > 0 ?
        ("+" + String(suggestedStocks[indexPath.row].change)) :
        String(suggestedStocks[indexPath.row].change)
        change.textColor = suggestedStocks[indexPath.row].change > 0 ?
        UIColor(red: 38/255, green: 142/255, blue: 36/255, alpha: 1) :
        UIColor(red: 198/255, green: 60/255, blue: 30/255, alpha: 1)
        
        let changePercentRounded = Double(round(1000*suggestedStocks[indexPath.row].changePercent)/10)
        changePercent.text = "(" + String(changePercentRounded) + "%)"
        changePercent.textColor = suggestedStocks[indexPath.row].change > 0 ?
        UIColor(red: 38/255, green: 142/255, blue: 36/255, alpha: 1) :
        UIColor(red: 198/255, green: 60/255, blue: 30/255, alpha: 1)
        
        favourite = self.suggestedStocks[indexPath.row].favourite
        
        if favourite {
            favouriteButtonFill.isHidden = false
            favouriteButtonEmpty.isHidden = true
        } else {
            favouriteButtonFill.isHidden = true
            favouriteButtonEmpty.isHidden = false
        }
        
        
    }
    
}
