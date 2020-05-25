//
//  BlockViewModel.swift
//  iOMG
//
//  Created by Tacenda on 5/25/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import Foundation
class BlockViewModel {
    let blknum: Int64
    let ethHeight: Int64
    let txCount: Int64
    
    init(blknum: Int64, ethHeight: Int64, txCount: Int64) {
        self.blknum = blknum
        self.ethHeight = ethHeight
        self.txCount = txCount
    }
}
