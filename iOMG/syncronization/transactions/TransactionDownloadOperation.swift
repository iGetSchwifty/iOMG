//
//  TransactionDownloadOperation.swift
//  iOMG
//
//  Created by Tacenda on 5/25/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//


import Foundation
import Combine
import CoreData

final class TransactionDownloadOperation: QueuedOperation {
    private var _cancellable: AnyCancellable?
    final var disposeable: AnyCancellable? {
        return _cancellable
    }
    private var provider: NetworkingProtocol?
    private let page: Int
    private let limit: Int
    private let blknum: Int64
    private let txcount: Int64
    private var invokeNext: ((Bool) -> Void)?
    
    init(blknum: Int64, txcount: Int64, page: Int, limit: Int, invokeNext: ((Bool) -> Void)?, provider: NetworkingProtocol = NetworkingPublisher()) {
        self.provider = provider
        self.page = page
        self.limit = limit
        self.invokeNext = invokeNext
        self.blknum = blknum
        self.txcount = txcount
        super.init(priority: .normal)
    }
    
    final override func main() {
        guard !isCancelled else {
            cancel()
            return
        }

        var initRequest = URLRequest(url: URLService.transactionInfo)
        initRequest.httpMethod = "POST"
        initRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        initRequest.httpBody = try? JSONEncoder().encode(TransactionPageData(page: page, limit: limit, blknum: blknum))
        _cancellable = provider?.dataTaskPublisher(for: initRequest)
            .map({ [weak self] response -> TransactionBatchAPIResponse? in
                guard let self = self else { return nil }
                guard !self.isCancelled else {
                    self.cancel()
                    return nil
                }
                
                do {
                    return try JSONDecoder().decode(TransactionBatchAPIResponse.self, from: response)
                } catch let error {
                    print(error)
                    return nil
                }
            })
            .map({ [weak self] response -> Bool in
                guard let self = self else { return false }
                guard !self.isCancelled else {
                    self.cancel()
                    return false
                }
                if let response = response, response.data?.count ?? 0 > 0 {
                    return self.process(response: response)
                } else {
                    return false
                }
            })
            .replaceError(with: nil)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { [weak self] _ in
                guard let self = self else { return }
                self.completed()
            }, receiveValue: { [weak self] success in
                guard let self = self else { return }
                guard !self.isCancelled else {
                    self.completed()
                    return
                }
                self.invokeNext?(success ?? false)
            })
    }
    
    private func process(response: TransactionBatchAPIResponse) -> Bool {
        var returnVal = !self.checkForCache()
        let context = PersistentContainer.newBackgroundContext()
        context.performAndWait { [weak self] in
            guard let self = self else { return }
            let fetchReq: NSFetchRequest<TransactionData> = TransactionData.fetchRequest()
            fetchReq.predicate = NSPredicate(format: "%K = %ld", #keyPath(TransactionData.blknum), self.blknum)
            var foundObjects: [TransactionData]?
            do {
                foundObjects = try context.fetch(fetchReq)
            } catch let error {
                // TODO: If this was a real project we would do something meaningful with this error
                // for now we just print
                print(error)
            }
            
            // fetch block here
            var blockRef: Block?
            let blockFetch: NSFetchRequest<Block> = Block.fetchRequest()
            blockFetch.predicate = NSPredicate(format: "%K = %ld", #keyPath(Block.blknum), self.blknum)
            do {
                blockRef = try context.fetch(blockFetch).first
            } catch let error {
                // TODO: If this was a real project we would do something meaningful with this error
                // for now we just print
                print(error)
            }
            guard !self.isCancelled, let block = blockRef else {
                returnVal = false
                return
            }


            for model in response.data ?? [] {
                guard !self.isCancelled else {
                    break
                }

                if foundObjects?.contains(where: { obj -> Bool in
                    return obj.txhash == model.txhash
                }) == false {
                    let tx = TransactionData(context: context)
                    tx.metadata = model.metadata
                    tx.txbytes = model.txbytes
                    tx.txhash = model.txhash
                    tx.txtype = model.txtype
                    tx.txindex = model.txindex
                    tx.blknum = self.blknum

                    model.inputs.forEach { input in
                        let newInput = TxInput(context: context)
                        newInput.amount = input.amount
                        newInput.blknum = input.blknum
                        newInput.creating_txhash = input.creating_txhash
                        newInput.currency = input.currency
                        newInput.oindex = input.oindex
                        newInput.otype = input.otype
                        newInput.owner = input.owner
                        newInput.spending_txhash = input.spending_txhash
                        newInput.txindex = input.txindex
                        newInput.utxo_pos = input.utxo_pos
                        newInput.tx = tx
                        tx.addToInputs(newInput)
                    }

                    model.outputs.forEach { input in
                        let newOutput = TxOutput(context: context)
                        newOutput.amount = input.amount
                        newOutput.blknum = input.blknum
                        newOutput.creating_txhash = input.creating_txhash
                        newOutput.currency = input.currency
                        newOutput.oindex = input.oindex
                        newOutput.otype = input.otype
                        newOutput.owner = input.owner
                        newOutput.spending_txhash = input.spending_txhash
                        newOutput.txindex = input.txindex
                        newOutput.utxo_pos = input.utxo_pos
                        newOutput.tx = tx
                        tx.addToOutputs(newOutput)
                    }

                    tx.block = block
                }

            }

            do {
                guard !self.isCancelled else {
                    returnVal = false
                    return
                }
                guard context.hasChanges else { return }
                try context.save()
            } catch let error {
                // TODO: If this was a real project we would do something meaningful with this error
                // for now we just print
                print(error)
            }
        }
        return returnVal
    }
    
    
    private func checkForCache() -> Bool {
        let context = PersistentContainer.newBackgroundContext()
        var returnVal = false
        context.performAndWait { [weak self] in
            guard let self = self else { return }
            let fetchReq: NSFetchRequest<TransactionData> = TransactionData.fetchRequest()
            fetchReq.predicate = NSPredicate(format: "%K = %ld", #keyPath(TransactionData.blknum), self.blknum)
            do {
                let foundObjects = try context.fetch(fetchReq)
                guard foundObjects.count == self.txcount else { return }
                returnVal = true
            } catch let error {
                // TODO: If this was a real project we would do something meaningful with this error
                // for now we just print
                print(error)
            }
        }
        return returnVal
    }
}
