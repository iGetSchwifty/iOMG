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
        initRequest.httpBody = try? JSONEncoder().encode(TransactionPageData(page: page, limit: limit, block: blknum))
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
//                if let response = response, response.data?.count ?? 0 > 0 {
//                    return self.process(response: response)
//                } else {
//                    return false
//                }
                return false
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
        var returnVal = false
//        var returnVal = !self.checkForCache(block: response.data?.first)
//        let context = PersistentContainer.newBackgroundContext()
//        context.performAndWait { [weak self] in
//            guard let self = self else { return }
//            let fetchReq: NSFetchRequest<Block> = Block.fetchRequest()
//            fetchReq.sortDescriptors = [NSSortDescriptor(key: #keyPath(Block.blknum), ascending: false)]
//            var foundObjects: [Block]?
//            do {
//                foundObjects = try context.fetch(fetchReq)
//            } catch let error {
//                // TODO: If this was a real project we would do something meaningful with this error
//                // for now we just print
//                print(error)
//            }
//
//            for model in response.data ?? [] {
//                guard !self.isCancelled else {
//                    break
//                }
//
//                if foundObjects?.contains(where: { obj -> Bool in
//                    return obj.blkhash == model.hash
//                }) == false {
//                    let block = Block(context: context)
//                    block.blkhash = model.hash
//                    block.blknum = model.blknum
//                    block.ethHeight = model.ethHeight
//                    block.txCount = model.txCount
//                }
//            }
//
//            do {
//                guard !self.isCancelled else {
//                    returnVal = false
//                    return
//                }
//                try context.save()
//            } catch let error {
//                // TODO: If this was a real project we would do something meaningful with this error
//                // for now we just print
//                print(error)
//            }
//        }
        return returnVal
    }
    
    
    private func checkForCache(block: TransactionBatchModel?) -> Bool {
        guard let block = block else { return false }
        
        let context = PersistentContainer.newBackgroundContext()
        var returnVal = false
//        context.performAndWait {
//            let fetchReq: NSFetchRequest<Block> = Block.fetchRequest()
//            fetchReq.sortDescriptors = [NSSortDescriptor(key: #keyPath(Block.blknum), ascending: false)]
//
//            do {
//                let foundObjects = try context.fetch(fetchReq)
//                guard foundObjects.count != 0 else { return }
//                if block.blknum > foundObjects.last?.blknum ?? 0 && block.blknum <= foundObjects.first?.blknum ?? block.blknum {
//                    returnVal = true
//                }
//            } catch let error {
//                // TODO: If this was a real project we would do something meaningful with this error
//                // for now we just print
//                print(error)
//            }
//        }
        
        //
        //  Check tx count..
        //
        return returnVal
    }
}
