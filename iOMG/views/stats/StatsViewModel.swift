//
//  StatsViewModel.swift
//  iOMG
//
//  Created by Tacenda on 5/22/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

class StatsViewModel: ObservableObject {
    let reloadExplorer: (() -> Void)?
    @Published var currentStats: OMGNetworkStats? = nil
    @Published var currentFeeInfo: String? = nil
    private let provider: NetworkingProtocol
    private var disposeBag = Set<AnyCancellable>()
    private var isFetching = false
    private var isFetchingFee = false
    
    init(reloadExplorer: (() -> Void)?, provider: NetworkingProtocol = NetworkingPublisher()) {
        self.provider = provider
        self.reloadExplorer = reloadExplorer
        fetch()
    }
    
    func reload() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.fetch()
        }
    }
    
    private func fetch() {
        guard isFetching == false else { return }
        isFetching = true
        StatsService.getStats(provider: provider)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stats in
                guard let self = self else { return }
                self.isFetching = false
                
                guard let stats = stats else {
                    //  TODO: Do something here...
                    return
                }
                self.currentStats = stats
            }.store(in: &disposeBag)
        
        fetchFeeInfo()
    }
    
    private func fetchFeeInfo() {
        guard isFetchingFee == false else { return }
        isFetchingFee = true
        StatsService.getEthFee(provider: provider)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] feeInfo in
                guard let self = self else { return }
                self.isFetchingFee = false
                
                guard let feeInfo = feeInfo else {
                    //  TODO: Do something here...
                    return
                }
                let tokenType: String
                if feeInfo.currency == "0x0000000000000000000000000000000000000000" {
                    tokenType = "ETH"
                } else if feeInfo.currency == "0xd26114cd6ee289accf82350c8d8487fedb8a0c07" {
                    tokenType = "OMG"
                } else {
                    tokenType = ""
                }
                if let amount = feeInfo.amount, let subUnit = feeInfo.subunitValue {
                    let feeValue = Double(amount) / Double(subUnit)
                    self.currentFeeInfo = "Current fee: \(Double(round(1000000*feeValue)/1000000)) \(tokenType)"
                } else {
                    self.currentFeeInfo = "Current fee is unknown"
                }
            }.store(in: &disposeBag)
    }
}
