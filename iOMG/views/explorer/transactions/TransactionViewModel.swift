//
//  TransactionViewModel.swift
//  iOMG
//
//  Created by Tacenda on 5/25/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//
import Combine
import Foundation
import CoreData

class TransactionViewModel: NSObject, NSFetchedResultsControllerDelegate, ObservableObject  {
    let blknum: UInt64
    let ethHeight: UInt64
    let txCount: UInt64
    let transactionQueue: OperationQueue
    
    @Published var transactions: [TransactionData] = []
    
    private let currentLimit = 100
    private var currentPage = 1
    
    private var controller: NSFetchedResultsController<TransactionData>?
    
    private var semaphore = DispatchSemaphore(value: 1)
    init(blknum: UInt64, ethHeight: UInt64, txCount: UInt64) {
        self.blknum = blknum
        self.ethHeight = ethHeight
        self.txCount = txCount
        transactionQueue = OperationQueue()
        transactionQueue.qualityOfService = .background
        transactionQueue.maxConcurrentOperationCount = 1
        super.init()
        refreshFromCoreData()
    }
    
    func onAppear() {
        let initOp = TransactionDownloadOperation(blknum: blknum,
                                                  txcount: txCount,
                                                  page: currentPage,
                                                  limit: currentLimit,
                                                  invokeNext: invokeNext)
        transactionQueue.addOperation(initOp)
    }
    
    private func invokeNext(_ success: Bool) {
        semaphore.wait()
        if success {
            currentPage += 1
           let nextOp = TransactionDownloadOperation(blknum: blknum,
                                                     txcount: txCount,
                                                     page: currentPage,
                                                     limit: currentLimit,
                                                     invokeNext: invokeNext)
           transactionQueue.addOperation(nextOp)
        } else {
            currentPage = 1
        }
        semaphore.signal()
    }
    
    private func refreshFromCoreData() {
        let context = PersistentContainer.viewContext
        let request: NSFetchRequest<TransactionData> = TransactionData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(TransactionData.txindex), ascending: true)]
        request.predicate = NSPredicate(format: "%K = %ld", #keyPath(TransactionData.blknum), blknum)
        self.controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.controller?.delegate = self
        do {
            try self.controller?.performFetch()
        } catch let error {
            print(error)
        }
        updateTransactions()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        objectWillChange.send()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateTransactions()
    }
    
    private func updateTransactions() {
        DispatchQueue.main.async {
            var newTxs = self.controller?.fetchedObjects ?? []
            newTxs.sort(by: { (lhs, rhs) -> Bool in
                return UInt64(lhs.txindex ?? "") ?? 0 < UInt64(rhs.txindex ?? "") ?? 0
            })
            self.transactions = newTxs
        }
    }
}
