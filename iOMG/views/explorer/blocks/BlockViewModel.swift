//
//  BlockViewModel.swift
//  iOMG
//
//  Created by Tacenda on 5/25/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import Foundation
class BlockViewModel {
    let blknum: UInt64
    let ethHeight: UInt64
    let txCount: UInt64
    
    init(blknum: UInt64, ethHeight: UInt64, txCount: UInt64) {
        self.blknum = blknum
        self.ethHeight = ethHeight
        self.txCount = txCount
    }
}
