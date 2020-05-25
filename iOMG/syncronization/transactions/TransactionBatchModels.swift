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
    var block: Int64
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
    var txindex: Int
    var txtype: Int
    var txhash: String
    var metadata: String?
    var txbytes: String
    var inputs: [TransactionData]
    var outputs: [TransactionData]
}

struct TransactionData: Codable {
    var blknum: Int64
    var txindex: Int
    var otype: Int
    var oindex: Int
    var utxo_pos: Int64
    var owner: String
    var currency: String
    var creating_txhash: String?
    var spending_txhash: String?
    var amount: Int64
}
