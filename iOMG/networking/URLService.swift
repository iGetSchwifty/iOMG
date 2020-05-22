//
//  URLService.swift
//  iNasa
//
//  Created by Tacenda on 5/21/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import Foundation

class URLService {
    static let omgPrice = URL(string: "https://www.cryptocompare.com/coins/omg/overview/USD")!
    
    private static let baseURL = "https://watcher-info.ropsten.v1.omg.network"
    static let networkStats = URL(string: "\(baseURL)/stats.get")!
}
