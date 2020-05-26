//
//  URLService.swift
//  iNasa
//
//  Created by Tacenda on 5/21/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import Foundation

fileprivate enum Env {
    case testNet
    case mainNet
    case customURL(String)
}

class URLService {
    static let envKey = "envKey"
    static let omgPrice = URL(string: "https://www.cryptocompare.com/coins/omg/overview/USD")!
    
    private static var baseURL: String {
        var current = env()
        if current == nil {
            // TODO: Comment this
            //current = mainNet
            //save(env: .mainNet)
            current = testNet
            save(env: .testNet)
        }
        return current!
    }
    
    private static let testNet = "https://watcher-info.ropsten.v1.omg.network"
    private static let mainNet = "https://watcher-info.mainnet.v1.omg.network"
    
    static let networkStats = URL(string: "\(baseURL)/stats.get")!
    static let feeInfo = URL(string: "\(baseURL)/fees.all")!
    static let blockInfo = URL(string: "\(baseURL)/block.all")!
    static let transactionInfo = URL(string: "\(baseURL)/transaction.all")!

    private static func save(env: Env) {
        let urlToSave: String
        switch env {
        case .testNet:
            urlToSave = testNet
        case .mainNet:
            urlToSave = mainNet // change to mainnet when public mainnet goes live..
        case .customURL(let custom):
            urlToSave = custom
        }
        UserDefaults.standard.set(urlToSave, forKey: envKey)
        do {
            FileManager.default.createFile(atPath: try envPath(),
                                           contents: urlToSave.data(using: .utf8),
                                           attributes: nil)
        } catch let error {
            print(error)
        }
    }

    private static func envPath() throws -> String {
        let defaultFM = FileManager.default
        let fileUrl = try defaultFM.url(for: .applicationSupportDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: true)

        return fileUrl.path + "/env"
    }

    private static func env() -> String? {
        do {
            if let data = FileManager.default.contents(atPath: try envPath()) {
                return String(data: data, encoding: .utf8)
            }
        } catch let error {
            print(error)
        }
        return UserDefaults.standard.string(forKey: envKey)
    }
}
