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
    
    static func getEthFee(provider: NetworkingProtocol) -> AnyPublisher<FeeInfo?, Never> {
        var request = URLRequest(url: URLService.feeInfo)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return provider
            .dataTaskPublisher(for: request)
            .map { response in
                var returnObjects: FeeInfo? = nil
                // Need to parse as dict due to the fact that the api returns a number as a key value.
                let feeInfo = try? JSONSerialization.jsonObject(with: response, options: .allowFragments) as AnyObject
                if let data = feeInfo?["data"] as? [String : AnyObject], let ethData = data["1"] as? [[String : AnyObject]] {
                    let amount = ethData.first?["amount"] as? Int64
                    let subUnit = ethData.first?["subunit_to_unit"] as? Int64
                    returnObjects = FeeInfo(amount: amount, subunitValue: subUnit)
                }
                return returnObjects
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
