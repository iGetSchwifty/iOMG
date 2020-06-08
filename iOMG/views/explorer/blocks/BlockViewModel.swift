//
//  BlockViewModel.swift
//  iOMG
//
//  Created by Tacenda on 5/25/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//
import BigInt
import Foundation
class BlockViewModel {
    let blknum: UInt64
    let ethHeight: BigUInt
    let txCount: UInt64
    
    init(blknum: UInt64, ethHeight: BigUInt, txCount: UInt64) {
        self.blknum = blknum
        self.ethHeight = ethHeight
        self.txCount = txCount
    }
}
