//
//  OMGNetworkStats.swift
//  iOMG
//
//  Created by Tacenda on 5/22/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//
struct OMGNetworkStats: Codable {
    var version: String
    var success: Bool
    var data: OMGInfoData
}

struct OMGInfoData: Codable {
    var blockInterval: InfoPacket
    var blockCount: InfoPacket
    var transactionCount: InfoPacket
    
    private enum CodingKeys: String, CodingKey {
        case blockInterval = "average_block_interval_seconds"
        case blockCount = "block_count"
        case transactionCount = "transaction_count"
    }
}

struct InfoPacket: Codable {
    var allTime: Double
    var lastTwentyFour: Double
    
    private enum CodingKeys: String, CodingKey {
        case allTime = "all_time"
        case lastTwentyFour = "last_24_hours"
    }
}
