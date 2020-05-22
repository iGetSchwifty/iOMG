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
    @Published var currentStats: OMGNetworkStats? = nil
    private let provider: NetworkingProtocol
    private var disposeBag = Set<AnyCancellable>()
    private var isFetching = false
    
    init(provider: NetworkingProtocol = NetworkingPublisher()) {
        self.provider = provider
        fetch()
    }
    
    func reloadPrice() {
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
    }
}
