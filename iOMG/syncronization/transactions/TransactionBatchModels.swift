//
//  TransactionBatchModels.swift
//  iOMG
//
//  Created by Tacenda on 5/25/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import Foundation
import BigInt

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
    var txindex: BigUInt
    var txtype: BigUInt
    var txhash: String
    var metadata: String?
    var txbytes: String
    var inputs: [TransactionAPIData]
    var outputs: [TransactionAPIData]
}

struct TransactionAPIData: Codable {
    var blknum: UInt64
    var txindex: BigUInt
    var otype: BigUInt
    var oindex: BigUInt
    var utxo_pos: BigUInt
    var owner: String
    var currency: String
    var creating_txhash: String?
    var spending_txhash: String?
    var amount: BigUInt
}
