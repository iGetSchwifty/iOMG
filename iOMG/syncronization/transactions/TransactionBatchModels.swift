//
//  TransactionBatchModels.swift
//  iOMG
//
//  Created by Tacenda on 5/25/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import Foundation

struct TransactionPageData: Codable {
    var page: Int
    var limit: Int
    var blknum: UInt64
}

struct TransactionBatchAPIResponse: Codable {
    var data: [TransactionBatchModel]?
    var pageInfo: PageData
    var success: Bool

    private enum CodingKeys: String, CodingKey {
        case data
        case pageInfo = "data_paging"
        case success
    }
}

struct TransactionBatchModel: Codable {
    var txindex: UInt64
    var txtype: UInt64
    var txhash: String
    var metadata: String?
    var txbytes: String
    var inputs: [TransactionAPIData]
    var outputs: [TransactionAPIData]
}

struct TransactionAPIData: Codable {
    var blknum: UInt64
    var txindex: UInt64
    var otype: UInt64
    var oindex: UInt64
    var utxo_pos: UInt64
    var owner: String
    var currency: String
    var creating_txhash: String?
    var spending_txhash: String?
    var amount: UInt64
}
