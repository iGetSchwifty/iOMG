//
//  PriceService.swift
//  iOMG
//
//  Created by Tacenda on 5/22/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import Foundation
import Combine

class PriceService {
    static func getPrice(provider: NetworkingProtocol) -> AnyPublisher<String?, Never> {
        return provider
            .dataTaskPublisher(for: URLRequest(url: URLService.omgPrice))
            .map { response in
                if let responseStr = String(data: response, encoding: .utf8),
                let range = responseStr.range(of: "~OMG~USD~") {
                    let endIndex = responseStr.index(range.lowerBound, offsetBy: 42)
                    let priceChunks = responseStr[range.upperBound...endIndex].split(separator: "~")
                    if priceChunks.count >= 2 {
                        let newPrice = String("$" + priceChunks[1])
                        return newPrice
                    }
                }
                return nil
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
