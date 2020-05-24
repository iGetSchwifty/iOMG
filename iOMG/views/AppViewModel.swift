//
//  AppViewModel.swift
//  iOMG
//
//  Created by Tacenda on 5/24/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//
import Foundation

class AppViewModel {
    let blockQueue: OperationQueue
    init() {
        blockQueue = OperationQueue()
        blockQueue.qualityOfService = .background
        blockQueue.maxConcurrentOperationCount = 1
        
        let initOp = BlockDownloadOperation(page: 1, limit: 250, invokeNext: self.invokeNext)
        blockQueue.addOperation(initOp)
    }
    
    private func invokeNext() {
        print("Tight")
    }
}
