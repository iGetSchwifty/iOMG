//
//  URLService.swift
//  iNasa
//
//  Created by Tacenda on 5/21/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import Foundation

enum Env {
    case testNet
    case mainNet
    case customURL(String)
}

class URLService {
    private static let envKey = "envKey"
    static let omgPrice = URL(string: "https://www.cryptocompare.com/coins/omg/overview/USD")!
    
    private static var baseURL: String {
        var current = env()
        if current == nil {
            // TODO: Comment this
            current = mainNet
            save(env: .mainNet)
            //TODO: COMMENT THIS WHEN DEVELOPING TO NOT DEFAULT TO MAINNET
//            current = testNet
//            save(env: .testNet)
        }
        return current!
    }
    
    private static let testNet = "https://watcher-info.ropsten.v1.omg.network"
    private static let mainNet = "https://watcher-info.mainnet.v1.omg.network"
    
    static var networkStats: URL {
        return URL(string: "\(baseURL)/stats.get")!
    }
    
    static var feeInfo: URL {
        return URL(string: "\(baseURL)/fees.all")!
    }
    
    static var blockInfo: URL {
        return URL(string: "\(baseURL)/block.all")!
    }
    
    static var transactionInfo: URL {
        return URL(string: "\(baseURL)/transaction.all")!
    }
    
    static func currentEnv() -> Env {
        let currentEnv = env()
        switch currentEnv {
        case testNet:
            return .testNet
        case mainNet:
            return .mainNet
        default:
            return .customURL(currentEnv ?? "")
        }
    }

    static func save(env: Env) {
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
