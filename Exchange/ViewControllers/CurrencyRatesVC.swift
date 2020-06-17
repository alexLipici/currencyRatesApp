//
//  CurrencyRatesVC.swift
//  Exchange
//
//  Created by Alexandru Lipici on 10/06/2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class CurrencyRatesVC: BaseUIViewController {
    
    static func initFromStoryboard() -> UINavigationController? {
        
        let thisVC = UIStoryboard(name: StoryboardIdentifier.Main, bundle: nil)
            .instantiateViewController(withIdentifier: String(describing: self))
        
        return UINavigationController(rootViewController: thisVC)
    }
    
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var latestUpdateTimeLabel: UILabel!
     
    lazy var viewModel = CurrencyRatesViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        viewModel.actionsDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.stopRatesUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchRates()
    }
    
    private func setupUI() {
        
        let currency = self.viewModel.currentCurrency ?? "EUR"
        
        self.setCustomTitle("Currency: \(currency)")
        
        view.backgroundColor = .white
        
        self.latestUpdateTimeLabel.text = nil
        
        setTableView()
    }
    
    private func setTableView() {
        
        contentTableView.backgroundColor = .clear
        contentTableView.separatorStyle = .singleLine
        
        let cellIdentifier = String(describing: CurrencyPreviewCell.self)
        contentTableView.register(UINib(nibName: cellIdentifier,
                                        bundle: nil),
                                  forCellReuseIdentifier: cellIdentifier)
    }
}

extension CurrencyRatesVC: CurrencyRatesVMActionsProtocol {
    
    func networkConnectivityChanged(isConnected: Bool) {
                
        DispatchQueue.main.async {
        
            self.contentTableView.reloadData()
            
            if isConnected {
                self.viewModel.fetchRates()
            } else {
                self.viewModel.stopRatesUpdate()
            }
        }
    }
    
    func startedFetchingRates() {
        
        print("startedFetchingRates")
    }
    
    func finishedFetchingRates() {
        
        print("finishedFetchingRates")
        
        DispatchQueue.main.async {
            
            self.contentTableView.reloadData()
            
            if let fetchedTimeStamp = self.viewModel.refreshTimeStamp {
                self.latestUpdateTimeLabel.text = "Last update: \(fetchedTimeStamp)"
            }
        }
    }
    
    func updateUI() {
        
        DispatchQueue.main.async {
            
            if let currency = self.viewModel.currentCurrency {
                self.setCustomTitle("Currency: \(currency)")
            }
            
            self.contentTableView.reloadData()
            
            if let fetchedTimeStamp = self.viewModel.refreshTimeStamp {
                
                self.latestUpdateTimeLabel.text = "Last update: \(fetchedTimeStamp)"
                
            } else {
                
                self.latestUpdateTimeLabel.text = nil
            }
        }
    }
}

extension CurrencyRatesVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !viewModel.isNetworkAvailable {
            
            let emptyView = EmptyView()
            emptyView.setWith(description: "No internet connection...")
            
            tableView.backgroundView = emptyView
            
            tableView.separatorStyle = .none
            
            return 0
            
        } else if viewModel.rates.isEmpty {
            
            let emptyView = EmptyView()
            emptyView.setWith(description: "Fetching data...")
            
            tableView.backgroundView = emptyView
            
            tableView.separatorStyle = .none
            
            return 0
            
        } else {
            
            tableView.separatorStyle = .singleLine
            
            tableView.backgroundView = nil
            
            return viewModel.rates.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CurrencyPreviewCell.self),
            for: indexPath) as? CurrencyPreviewCell,
            indexPath.row < viewModel.rates.count else { return UITableViewCell() }
        
        cell.setWith(currency: viewModel.rates[indexPath.row].currency,
                     value: viewModel.rates[indexPath.row].value)
        
        return cell
    }
}
