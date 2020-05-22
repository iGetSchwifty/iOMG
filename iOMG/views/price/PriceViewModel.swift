//
//  PriceViewModel.swift
//  iOMG
//
//  Created by Tacenda on 5/22/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//
import SwiftUI
import Combine
import Foundation

class PriceViewModel: ObservableObject {

    @Published var omgPrice: String = "Loading price..."
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
        PriceService.getPrice(provider: provider)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] price in
                guard let self = self else { return }
                if let price = price {
                    self.omgPrice = "\(price)"
                } else {
                    self.omgPrice = "Unable to load price. Try again later."
                }
                self.isFetching = false
            }.store(in: &disposeBag)
    }
}
