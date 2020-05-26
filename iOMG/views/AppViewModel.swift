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
    
    private let currentLimit = 100
    private var currentPage = 1
    
    private var semaphore = DispatchSemaphore(value: 1)
    init() {
        blockQueue = OperationQueue()
        blockQueue.qualityOfService = .background
        blockQueue.maxConcurrentOperationCount = 1
        
        let initOp = BlockDownloadOperation(page: currentPage, limit: currentLimit, invokeNext: self.invokeNext)
        blockQueue.addOperation(initOp)
    }
    
    func reloadExplorer() {
        blockQueue.cancelAllOperations()
        semaphore.wait()
        currentPage = 1
        semaphore.signal()
        let initOp = BlockDownloadOperation(page: currentPage, limit: currentLimit, invokeNext: self.invokeNext)
        blockQueue.addOperation(initOp)
    }
    
    private func invokeNext(_ success: Bool) {
        semaphore.wait()
        if success {
            currentPage += 1
            let nextOp = BlockDownloadOperation(page: currentPage, limit: currentLimit, invokeNext: self.invokeNext)
            blockQueue.addOperation(nextOp)
        } else {
            currentPage = 1
        }
        semaphore.signal()
    }
    
    // TODO: A timer that invokes a reload of the initalCurrentPage.
    // Guard against blockQueue.operations.count == 0 before starting
}
