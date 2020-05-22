//
//  StatsService.swift
//  iOMG
//
//  Created by Tacenda on 5/22/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//
//

import Foundation
import Combine

class StatsService {
    static func getStats(provider: NetworkingProtocol) -> AnyPublisher<OMGNetworkStats?, Never> {
        var request = URLRequest(url: URLService.networkStats)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return provider
            .dataTaskPublisher(for: request)
            .map { response in
                do {
                    return try JSONDecoder().decode(OMGNetworkStats.self, from: response)
                } catch let error {
                    print(error)
                    return nil
                }
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
