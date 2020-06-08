//
//  BlockBatchModel.swift
//  iOMG
//
//  Created by Tacenda on 5/24/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//
import BigInt
import Foundation
struct BlockBatchAPIResponse: Codable {
    var data: [BlockBatchModel]?
    var pageInfo: PageData
    var success: Bool
    
    private enum CodingKeys: String, CodingKey {
        case data
        case pageInfo = "data_paging"
        case success
    }
}

struct PageData: Codable {
    var page: Int
    var limit: Int
}

struct BlockBatchModel: Codable {
    var blknum: UInt64
    var hash: String
    var ethHeight: BigUInt
    var txCount: BigUInt
    
    private enum CodingKeys: String, CodingKey {
        case blknum
        case hash
        case ethHeight = "eth_height"
        case txCount = "tx_count"
    }
}
