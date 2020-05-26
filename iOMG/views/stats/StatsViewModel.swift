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
    @Published var currentFeeInfo: FeeInfo? = nil
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
                self.currentFeeInfo = feeInfo
            }.store(in: &disposeBag)
    }
}
